const std = @import("std");
const isNan = std.math.isNan;
const Node = @import("main.zig").Node;
const computeNode = @import("common.zig").computeNode;

pub fn computeBlock(node: *Node, size: [2]f32) void {
    var ctx = BlockContext.init(node, size);
    ctx.compute();
}

const BlockContext = struct {
    // args
    node: *Node,
    size: [2]f32,

    // consts
    avail_inner: [2]f32,

    // state
    y: f32,

    pub fn init(node: *Node, size: [2]f32) BlockContext {
        return .{
            .node = node,
            .size = size,

            .avail_inner = .{
                @max(@as(f32, 0), size[0] - node.style.padding_left.resolve(size[0]) - node.style.padding_right.resolve(size[0])),
                @max(@as(f32, 0), size[1] - node.style.padding_top.resolve(size[0]) - node.style.padding_bottom.resolve(size[0])),
            },
            .y = node.style.padding_top.resolve(size[0]),
        };
    }

    pub fn compute(self: *BlockContext) void {
        var iter = self.node.children();
        while (iter.next()) |child| {
            self.addChild(child);
        }

        self.finish();
    }

    fn addChild(self: *BlockContext, child: *Node) void {
        child.size[0] = child.style.width.resolve(self.size[0]);
        child.size[1] = child.style.height.resolve(self.size[1]);
        computeNode(child, self.avail_inner);

        child.pos[0] = child.style.padding_left.resolve(self.size[0]);
        child.pos[1] = self.y;

        self.y += child.size[1]; // TODO: margin
    }

    fn finish(self: *BlockContext) void {
        if (isNan(self.node.size[0])) {
            self.node.size[0] = self.size[0];
        }

        if (isNan(self.node.size[1])) {
            self.node.size[1] = self.y + self.node.style.padding_bottom.resolve(self.size[0]);
        }
    }
};
