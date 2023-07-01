const std = @import("std");
const isNan = std.math.isNan;
const Node = @import("main.zig").Node;
const computeNode = @import("common.zig").computeNode;

/// Context for the currently computed flex layout.
pub const FlexLayoutContext = struct {
    /// The flex node we're computing the layout for
    node: *Node,

    size: [2]f32,

    // Shared consts
    is_row: bool,
    is_wrap: bool,
    main: u1,
    cross: u1,

    // Per-line state
    y: f32,
    line_pos: f32,
    line_space: f32,
    line_height: f32 = 0,
    grows: f32 = 0,
    shrinks: f32 = 0,

    /// Initialize the context for the given node and size.
    pub fn init(node: *Node, size: [2]f32) FlexLayoutContext {
        const is_row = node.style.flex_direction == .row;
        const main: u1 = if (is_row) 0 else 1;

        return FlexLayoutContext{
            .node = node,
            .size = size,

            .is_row = is_row,
            .is_wrap = node.style.flex_wrap == .wrap,
            .main = main,
            .cross = ~main,

            .y = if (is_row) node.style.padding_top.resolve0(size[1]) else node.style.padding_left.resolve0(size[0]),
            .line_pos = if (is_row) node.style.padding_left.resolve0(size[0]) else node.style.padding_top.resolve0(size[1]),
            .line_space = @max(0, node.size[main]),
        };
    }

    /// Compute the layout for the node.
    pub fn compute(self: *FlexLayoutContext) void {
        // Compute base sizes, space per line, wrap if needed, etc.
        var iter = self.node.children();
        while (iter.next()) |ch| {
            self.addChild(ch);
        }

        // Finish the layout
        self.finish();
    }

    // Add a child to the current line.
    fn addChild(self: *FlexLayoutContext, child: *Node) void {
        // Compute base size of the child
        child.size[0] = child.style.width.resolve(self.size[0]);
        child.size[1] = child.style.height.resolve(self.size[1]);
        if (isNan(child.size[self.main])) child.size[self.main] = 0;
        if (isNan(child.size[self.cross])) child.size[self.cross] = self.size[self.cross]; // TODO: - margin[w/h]
        const basis = child.style.flex_basis.resolve(self.size[self.main]);
        if (!isNan(basis)) child.size[self.main] = basis;

        // TODO: skip if we can, but items should not directly cause overflow (text or child-child with given size)
        computeNode(child, child.size);

        // Wrap if needed
        if (self.is_wrap and child.size[self.main] > self.line_space) {
            self.finishLine();
        }

        // Update counters
        self.grows += child.style.flex_grow;
        self.shrinks += child.style.flex_shrink;

        // Update the line "height" & subtract from flex space
        self.line_height = @max(self.line_height, child.size[self.cross]); // TODO: include child margin
        self.line_space -= child.size[self.main];

        // Sanity checks
        std.debug.assert(self.y >= 0);
        std.debug.assert(self.line_height >= 0);
    }

    fn finishLine(self: *FlexLayoutContext) void {
        // grow/shrink, position, reverse, align, stretch, margin, ...
        var iter = self.node.children();
        while (iter.next()) |ch| {
            ch.pos[self.main] = self.line_pos + ch.style.margin_left.resolve0(self.size[0]);
            ch.pos[self.cross] = self.y + ch.style.margin_top.resolve0(self.size[1]);

            if (self.line_space > 0 and ch.style.flex_grow > 0) {
                ch.size[self.main] += (self.line_space / self.grows) * ch.style.flex_grow;
            }

            if (self.line_space < 0 and ch.style.flex_shrink > 0) {
                ch.size[self.main] += (self.line_space / self.shrinks) * ch.style.flex_shrink;
            }

            // TODO: align

            // Recompute again, with final size
            computeNode(ch, ch.size);

            // Update position for next child
            self.line_pos += ch.size[self.main] + ch.style.margin_left.resolve0(self.size[0]) + ch.style.margin_right.resolve0(self.size[0]);
        }

        // TODO: we should do this only if child main size is auto (but flexbox sets it to 0)
        if (self.line_space < 0) {
            self.node.size[self.main] = -self.line_space;
        }

        // Advance to next line
        self.y += self.line_height;
        self.line_space = @max(0, self.node.size[self.main]);
        self.line_height = 0;
        self.line_pos = if (self.is_row) self.node.style.padding_left.resolve(self.size[0]) else self.node.style.padding_top.resolve(self.size[1]);
        self.grows = 0;
        self.shrinks = 0;
    }

    fn finish(self: *FlexLayoutContext) void {
        self.finishLine();

        // should be already computed by finishLine()
        if (isNan(self.node.size[self.main])) self.node.size[self.main] = 0;

        if (isNan(self.node.size[self.cross])) self.node.size[self.cross] = 0;
        self.node.size[self.cross] = @max(self.node.size[self.cross], self.y);
        self.node.size[self.cross] += if (self.is_row) self.node.style.padding_bottom.resolve0(self.size[1]) else self.node.style.padding_right.resolve0(self.size[0]);
    }
};
