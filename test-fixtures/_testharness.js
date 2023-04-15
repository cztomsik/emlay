const sheet = Object.assign(document.createElement('link'), { rel: 'stylesheet', href: '_styles.css' })
document.head.appendChild(sheet)

window.onload = () => {
  // get the test cases
  const testCases = [...document.querySelectorAll('test-case')]

  // wrap for styling
  for (tc of testCases) {
    const wrapper = document.createElement('test-case-wrapper')
    const pre = document.createElement('pre')
    pre.textContent = tc.innerHTML.trim().replace(/^ {2}/gm, '')

    tc.replaceWith(wrapper)
    wrapper.appendChild(tc)
    tc.after(pre)
  }

  // get the computed layout for an element
  const getLayout = el => [el.offsetLeft, el.offsetTop, el.offsetWidth, el.offsetHeight]

  // get the structure, style and computed layouts for each element in each test case
  window.fixtures = testCases.map(tc => {
    if (tc.children.length !== 1) throw new Error('test cases must have exactly one child')

    const dump = el => {
      return {
        props: Array.from(el.style).map(k => [k, el.style[k]]),
        children: Array.from(el.children).map(dump),
        layout: getLayout(el),
      }
    }

    return dump(tc.children[0])
  })

  // debug
  let hoverEl = null
  const debugBar = document.body.appendChild(Object.assign(document.createElement('div'), { id: 'debug-bar' }))
  document.addEventListener('mouseover', e => {
    if (hoverEl) hoverEl.classList.remove('hover')
    hoverEl = e.target
    hoverEl.classList.add('hover')
    debugBar.textContent = JSON.stringify(getLayout(hoverEl), null, 2)
  })
}
