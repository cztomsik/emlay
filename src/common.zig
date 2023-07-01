const std = @import("std");
const BlockLayoutContext = @import("block.zig").BlockLayoutContext;
const FlexLayoutContext = @import("flex.zig").FlexLayoutContext;
const Node = @import("main.zig").Node;

// Compute layout for the node, given its base size. This is because part of
// job has been already done by the parent (e.g. flexbox).
pub fn computeNode(node: *Node, size: [2]f32) void {
    if (node.measure_fn) |measure| {
        node.size = measure(node, node.size);

        // std.debug.print("measure {d} {d}\n", .{ node.size[0], node.size[1] });
        return;
    }

    switch (node.style.display) {
        .block => {
            var cx = BlockLayoutContext.init(node, size);
            cx.compute();
        },
        .flex => {
            var cx = FlexLayoutContext.init(node, size);
            cx.compute();
        },
        else => {
            node.pos = .{ 0, 0 };
            node.size = .{ 0, 0 };
        },
    }

    // std.debug.print("{s} {d} {d} <- {d} {d}\n", .{ @tagName(node.style.display), node.size[0], node.size[1], size[0], size[1] });
    std.debug.assert(node.size[0] >= 0);
    std.debug.assert(node.size[1] >= 0);
}
