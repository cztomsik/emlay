const computeFlex = @import("flex.zig").computeFlex;
const computeBlock = @import("block.zig").computeBlock;

// Compute layout for the node, given its base size. This is because part of
// job has been already done by the parent (e.g. flexbox).
pub fn computeNode(ctx: anytype, node: anytype, style: anytype, target: anytype, size: [2]f32) void {
    switch (style.display) {
        .flex => computeFlex(ctx, node, style, target, size),
        .block => computeBlock(ctx, node, style, target, size),
        else => {
            target.pos = .{ 0, 0 };
            target.size = .{ 0, 0 };
        },
    }
}
