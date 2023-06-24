const std = @import("std");
const isNan = std.math.isNan;
const Node = @import("main.zig").Node;
const computeNode = @import("common.zig").computeNode;

pub fn computeFlex(node: *Node, size: [2]f32) void {
    var ctx = FlexContext.init(node, size);
    ctx.compute();
}

const FlexContext = struct {
    // Input args
    node: *Node,
    size: [2]f32,

    // Shared consts
    is_row: bool,
    main: u1,
    cross: u1,

    // Per-line state
    flex_space: f32,
    grows: f32 = 0,
    shrinks: f32 = 0,

    pub fn init(node: *Node, size: [2]f32) FlexContext {
        const is_row = node.style.flex_direction == .row; // or node.style.flex_direction == .row_reverse;
        // const is_reverse = node.style.flex_direction == .row_reverse or node.style.flex_direction == .column_reverse;

        return FlexContext{
            .node = node,
            .size = size,

            .is_row = is_row,
            // .is_reverse = is_reverse,
            .main = if (is_row) 0 else 1,
            .cross = if (is_row) 1 else 0,

            .flex_space = node.size[if (is_row) 0 else 1],
        };
    }

    pub fn compute(self: *FlexContext) void {
        // Go through children and determine their base sizes, and total flex space
        // available for growing/shrinking. This is done before positioning, as we
        // need to know the size of the container before we can compute flex space.
        var iter = self.node.children();
        while (iter.next()) |ch| {
            if (!self.addChild(ch)) {
                self.finishLine();
            }
        }

        self.finishLine();

        // Determine final size of the container
        self.node.size[self.main] = @max(self.node.size[self.main], -self.flex_space);
    }

    pub fn addChild(self: *FlexContext, child: *Node) bool {
        // Determine base size for the child
        child.size[0] = child.style.width.resolve(self.size[0]);
        child.size[1] = child.style.height.resolve(self.size[1]);
        if (isNan(child.size[self.main])) child.size[self.main] = 0;
        if (isNan(child.size[self.cross])) child.size[self.cross] = self.size[self.cross]; // TODO: - margin[w/h]
        const basis = child.style.flex_basis.resolve(self.size[self.main]);
        if (!isNan(basis)) child.size[self.main] = basis;

        // TODO: skip if we can, but items should not directly cause overflow (text or child-child with given size)
        computeNode(child, child.size);

        // Update counters
        self.grows += child.style.flex_grow;
        self.shrinks += child.style.flex_shrink;

        // Update container cross size & subtract from flex space
        self.node.size[self.cross] = @max(child.size[self.cross], child.size[self.cross]);
        self.flex_space -= @max(@as(f32, 0), child.size[self.main]);

        // TODO: if we can't fit, return false and don't add the child (flex-wrap)
        return true;
    }

    pub fn finishLine(self: *FlexContext) void {
        // Starting position for children
        var pos: [2]f32 = .{
            @max(@as(f32, 0), self.node.style.padding_left.resolve(self.size[0])),
            @max(@as(f32, 0), self.node.style.padding_top.resolve(self.size[1])),
        };

        // grow/shrink, position, reverse, align, stretch, margin, ...
        var iter = self.node.children();
        while (iter.next()) |ch| {
            ch.pos = pos;

            if (self.flex_space > 0 and ch.style.flex_grow > 0) {
                ch.size[self.main] += (self.flex_space / self.grows) * ch.style.flex_grow;
            }

            if (self.flex_space < 0 and ch.style.flex_shrink > 0) {
                ch.size[self.main] += (self.flex_space / self.shrinks) * ch.style.flex_shrink;
            }

            // ch.pos[main] += @max(@as(f32, 0), ch.style.margin_left/top.resolve())
            // pos[main] += @max(@as(f32, 0), ch.style.margin_x/y.resolve())

            // TODO: align

            // Now that we have the size, we can compute everything again, with
            // correct positions.
            computeNode(ch, ch.size);

            // advance
            pos[self.main] += ch.size[self.main];
        }
    }
};
