const std = @import("std");
const computeFlex = @import("flex.zig").computeFlex;
const computeBlock = @import("block.zig").computeBlock;
const Node = @import("main.zig").Node;

// Compute layout for the node, given its base size. This is because part of
// job has been already done by the parent (e.g. flexbox).
pub fn computeNode(node: *Node, size: [2]f32) void {
    if (node.measure_fn) |measure| {
        node.size = measure(node, node.size);
    }

    switch (node.style.display) {
        .flex => computeFlex(node, size),
        .block => computeBlock(node, size),
        else => {
            node.pos = .{ 0, 0 };
            node.size = .{ 0, 0 };
        },
    }

    // std.debug.assert(node.size[0] >= 0);
    // std.debug.assert(node.size[1] >= 0);
    // std.debug.print("{d} {d}\n", .{ node.size[0], node.size[1] });
}
