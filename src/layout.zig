const std = @import("std");
const isNan = std.math.isNan;

pub const Style = @import("style.zig").Style;

pub const Layout = struct {
    pos: [2]f32 = .{ 0, 0 },
    size: [2]f32 = .{ 0, 0 },
};

pub fn layout(node: anytype, size: [2]f32) void {
    node.size[0] = node.style.width.resolve(size[0]);
    node.size[1] = node.style.height.resolve(size[1]);
    computeNode(node, &node.style, node.size);
}

fn computeNode(node: anytype, style: *const Style, size: [2]f32) void {
    const is_row = style.flex_direction == .row; // or style.flex_direction == .row_reverse;
    const main: u1 = if (is_row) 0 else 1;
    const cross: u1 = ~main;

    var flex_space = node.size[main];
    var grows: f32 = 0;
    var shrinks: f32 = 0;

    var iter = node.children();
    while (iter.next()) |ch| {
        grows += ch.style.flex_grow;
        shrinks += ch.style.flex_shrink;

        ch.size[0] = ch.style.width.resolve(size[0]);
        ch.size[1] = ch.style.height.resolve(size[1]);
        if (isNan(ch.size[main])) ch.size[main] = 0;
        if (isNan(ch.size[cross])) ch.size[cross] = size[cross]; // TODO: - margin[w/h]
        const basis = ch.style.flex_basis.resolve(size[main]);
        if (!isNan(basis)) ch.size[main] = basis;

        // TODO: skip if we can, but items should not directly cause overflow (text or child-child with given size)
        computeNode(ch, &ch.style, ch.size);

        node.size[cross] = @max(node.size[cross], ch.size[cross]);
        flex_space -= @max(0, ch.size[main]);
    }

    node.size[main] = @max(node.size[main], -flex_space);

    var pos: [2]f32 = .{
        @max(0, style.padding_left.resolve(size[0])),
        @max(0, style.padding_top.resolve(size[1])),
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

        // ch.pos[main] += @max(0, ch.style.margin_left/top.resolve())
        // pos[main] += @max(0, ch.style.margin_x/y.resolve())

        // TODO: align

        computeNode(ch, &ch.style, ch.size);

        // advance
        pos[main] += ch.size[main];
    }
}
