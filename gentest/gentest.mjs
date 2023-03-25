// npm i && node gentest.mjs && zig test tests.zig

import puppeteer from 'puppeteer-core'
import fs from 'fs'
import { fileURLToPath } from 'url'
import { dirname } from 'path'

// config
const VIEWPORT_SIZE = { width: 800, height: 600 }
const __dirname = dirname(fileURLToPath(import.meta.url))
const SRC_DIR = `${__dirname}/../test-fixtures`
const TARGET_DIR = `${__dirname}/../tests`
const FILE_HEADER = '// GENERATED FILE - DO NOT EDIT\n'

// util
const writeFile = (file, content) => {
  fs.writeFileSync(file, FILE_HEADER + content.replace(/\s+$/s, '\n'))
  console.log(`Generated ${file}`)
}

// start puppeteer
const browser = await puppeteer.launch({ channel: 'chrome' })

// get list of all .html files in test-fixtures/
const fixtureFiles = fs.readdirSync(SRC_DIR).filter((f) => f.endsWith('.html'))

// generate test files
for (const file of fixtureFiles) {
  const targetFile = `${TARGET_DIR}/${file.replace(/-/, '_').replace(/\.html$/, '.zig')}`
  const fixtures = await readFixtureFile(`${SRC_DIR}/${file}`)
  const content = renderFile(fixtures)

  writeFile(targetFile, content)
}

// write a file that imports all the generated test files
writeFile(`${TARGET_DIR}/_all.zig`, renderEntrypoint())

// stop puppeteer so the process can exit
await browser.close()

async function readFixtureFile(file) {
  const page = await browser.newPage()
  page.setViewport(VIEWPORT_SIZE)
  await page.goto(`file://${file}`, { waitUntil: 'load' })

  return await page.evaluate(() => window.fixtures)
}

function renderFile(fixtures) {
  return `
  const node = @import("../tests.zig").Node.init;
  const expectLayout = @import("../tests.zig").expectLayout;
  ${fixtures.map(renderFixture).join('')}
  `.replace(/^ {2}/gm, '')
}

function renderFixture(fixture) {
  return `
  test {
      try expectLayout(
          ${renderNode(fixture, 2)},
      );
  }
  `
}

function renderNode(node, depth = 0) {
  const indent = (n) => ' '.repeat(n * 4)

  let props = node.props.map(([k, v]) => `.${k.replace(/-/, '_')} = ${renderValue(v)}`).join(', ')
  props = props ? ` ${props} ` : ''

  let children = node.children.map((c) => '\n  ' + indent(depth + 1) + renderNode(c, depth + 1) + ',').join('')
  children = children ? children + '\n  ' + indent(depth) : ''

  return `node(.{ ${node.layout.join(', ')} }, .{${props}}, .{${children}})`
}

function renderValue(value) {
  switch (true) {
    case /^[a-z-]+$/.test(value):
      return `.${value.replace(/-/, '_')}`

    case /^[\d\.]+px$/.test(value):
      return `.{ .px = ${value.slice(0, -2)} }`

    // TODO: fix this
    case value === '0%':
      return '.auto'

    default:
      return value
  }
}

function renderEntrypoint() {
  return `
  const std = @import("std");

  test {
    ${fixtureFiles.map((f) => `  _ = @import("${f.replace(/-/, '_').replace(/\.html$/, '.zig')}");`).join('\n    ')}
  }
  `.replace(/^ {2}/gm, '')
}
