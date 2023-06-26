const std = @import("std");
const isNan = std.math.isNan;
const Node = @import("main.zig").Node;
const computeNode = @import("common.zig").computeNode;

pub fn computeBlock(node: *Node, size: [2]f32) void {
    var ctx = BlockLayoutContext.init(node, size);
    ctx.compute();
}

/// Context for the currently computed block layout.
const BlockLayoutContext = struct {
    /// The block node being computed.
    node: *Node,

    /// Size used for resolving.
    size: [2]f32,

    /// Available size for the inner content.
    avail_inner: [2]f32,

    /// The Y position for the next child.
    next_y: f32,

    // Init the context for the given node and size.
    fn init(node: *Node, size: [2]f32) BlockLayoutContext {
        return .{
            .node = node,
            .size = size,
            .avail_inner = .{
                @max(0, size[0] - node.style.padding_left.resolve0(size[0]) - node.style.padding_right.resolve0(size[0])),
                @max(0, size[1] - node.style.padding_top.resolve0(size[0]) - node.style.padding_bottom.resolve0(size[0])),
            },
            .next_y = node.style.padding_top.resolve0(node.size[0]),
        };
    }

    // Compute the layout.
    fn compute(self: *BlockLayoutContext) void {
        var iter = self.node.children();
        while (iter.next()) |child| {
            self.addChild(child);
        }

        self.finish();
    }

    // Add a child to the layout.
    fn addChild(self: *BlockLayoutContext, child: *Node) void {
        child.size[0] = child.style.width.resolve(self.size[0]);
        child.size[1] = child.style.height.resolve(self.size[1]);
        computeNode(child, self.avail_inner);

        // Position the child.
        child.pos = .{
            self.node.style.padding_left.resolve0(self.size[0]),
            self.next_y + child.style.margin_top.resolve0(self.size[0]),
        };

        // Update the Y position for the next child.
        self.next_y = child.pos[1] + child.size[1] + child.style.margin_bottom.resolve0(self.size[0]);
    }

    // Finish the layout.
    fn finish(self: *BlockLayoutContext) void {
        if (isNan(self.node.size[0])) {
            self.node.size[0] = self.size[0];
        }

        if (isNan(self.node.size[1])) {
            // TODO: we should still clamp to max-height - padding.
            self.node.size[1] = self.next_y + self.node.style.padding_bottom.resolve0(self.size[0]);
        }
    }
};
