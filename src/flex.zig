const std = @import("std");
const isNan = std.math.isNan;
const computeNode = @import("common.zig").computeNode;

pub fn computeFlex(node: anytype, size: [2]f32) void {
    const is_row = node.style.flex_direction == .row; // or node.style.flex_direction == .row_reverse;
    // const is_reverse = node.style.flex_direction == .row_reverse or node.style.flex_direction == .column_reverse;
    const main: u1 = if (is_row) 0 else 1;
    const cross: u1 = ~main;

    // Available space for flexing + counters
    var flex_space = node.size[main];
    var grows: f32 = 0;
    var shrinks: f32 = 0;

    // Go through children and determine their base sizes, and total flex space
    // available for growing/shrinking. This is done before positioning, as we
    // need to know the size of the container before we can compute flex space.
    var iter = node.children();
    while (iter.next()) |ch| {
        // Update counters
        grows += ch.style.flex_grow;
        shrinks += ch.style.flex_shrink;

        // Determine base size for the child
        ch.size[0] = ch.style.width.resolve(size[0]);
        ch.size[1] = ch.style.height.resolve(size[1]);
        if (isNan(ch.size[main])) ch.size[main] = 0;
        if (isNan(ch.size[cross])) ch.size[cross] = size[cross]; // TODO: - margin[w/h]
        const basis = ch.style.flex_basis.resolve(size[main]);
        if (!isNan(basis)) ch.size[main] = basis;

        // TODO: skip if we can, but items should not directly cause overflow (text or child-child with given size)
        computeNode(ch, ch.size);

        // Determine cross size & subtract from flex space
        node.size[cross] = @max(ch.size[cross], ch.size[cross]);
        flex_space -= @max(@as(f32, 0), ch.size[main]);
    }

    // Determine final size of the container
    node.size[main] = @max(node.size[main], -flex_space);

    // Starting position for children
    var pos: [2]f32 = .{
        @max(@as(f32, 0), node.style.padding_left.resolve(size[0])),
        @max(@as(f32, 0), node.style.padding_top.resolve(size[1])),
    };

    // grow/shrink, position, reverse, align, stretch, margin, ...
    iter = node.children();
    while (iter.next()) |ch| {
        ch.pos = pos;

        if (flex_space > 0 and ch.style.flex_grow > 0) {
            ch.size[main] += (flex_space / grows) * ch.style.flex_grow;
        }

        if (flex_space < 0 and ch.style.flex_shrink > 0) {
            ch.size[main] += (flex_space / shrinks) * ch.style.flex_shrink;
        }

        // ch.pos[main] += @max(@as(f32, 0), ch.style.margin_left/top.resolve())
        // pos[main] += @max(@as(f32, 0), ch.style.margin_x/y.resolve())

        // TODO: align

        // Now that we have the size, we can compute everything again, with
        // correct positions.
        computeNode(ch, ch.size);

        // advance
        pos[main] += ch.size[main];
    }
}
