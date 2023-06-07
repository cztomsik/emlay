const std = @import("std");
const isNan = std.math.isNan;
const computeNode = @import("common.zig").computeNode;

pub fn computeBlock(ctx: anytype, node: anytype, style: anytype, target: anytype, size: [2]f32) void {
    var y = ctx.resolve(style.padding_top, size[0]);
    var content_height: f32 = 0;

    // Available space for children
    const avail_inner: [2]f32 = .{
        @max(@as(f32, 0), size[0] - ctx.resolve(style.padding_left, size[0]) - ctx.resolve(style.padding_right, size[0])),
        @max(@as(f32, 0), size[1] - ctx.resolve(style.padding_top, size[0]) - ctx.resolve(style.padding_bottom, size[0])),
    };

    // Go through children and compute their layout, and total height
    var iter = ctx.children(node);
    while (iter.next()) |ch| {
        const ch_style = ctx.style(ch);
        const ch_target = ctx.target(ch);

        ch_target.size[0] = ctx.resolve(ch_style.width, size[0]);
        ch_target.size[1] = ctx.resolve(ch_style.height, size[1]);
        computeNode(ctx, ch, ch_style, ch_target, avail_inner);

        ch_target.pos[0] = ctx.resolve(style.padding_left, size[0]);
        ch_target.pos[1] = y;

        content_height += ch_target.size[1];
        y += ch_target.size[1];
    }

    // Fall back to parent width & content height if not specified
    if (isNan(target.size[0])) target.size[0] = size[0];
    if (isNan(target.size[1])) target.size[1] = content_height + ctx.resolve(style.padding_top, size[0]) + ctx.resolve(style.padding_bottom, size[0]);
}
