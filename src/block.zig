const std = @import("std");
const isNan = std.math.isNan;
const computeNode = @import("common.zig").computeNode;

pub fn computeBlock(node: anytype, size: [2]f32) void {
    var y = node.style.padding_top.resolve(size[0]);
    var content_height: f32 = 0;

    // Available space for children
    const avail_inner: [2]f32 = .{
        @max(@as(f32, 0), size[0] - node.style.padding_left.resolve(size[0]) - node.style.padding_right.resolve(size[0])),
        @max(@as(f32, 0), size[1] - node.style.padding_top.resolve(size[0]) - node.style.padding_bottom.resolve(size[0])),
    };

    // Go through children and compute their layout, and total height
    var iter = node.children();
    while (iter.next()) |ch| {
        ch.size[0] = ch.style.width.resolve(size[0]);
        ch.size[1] = ch.style.height.resolve(size[1]);
        computeNode(ch, avail_inner);

        ch.pos[0] = ch.style.padding_left.resolve(size[0]);
        ch.pos[1] = y;

        content_height += ch.size[1];
        y += ch.size[1];
    }

    // Fall back to parent width & content height if not specified
    if (isNan(node.size[0])) node.size[0] = size[0];
    if (isNan(node.size[1])) node.size[1] = content_height + node.style.padding_top.resolve(size[0]) + node.style.padding_bottom.resolve(size[0]);
}
