const std = @import("std");
const lib = @import("src/main.zig");

/// A node in our test tree.
pub const Node = struct {
    expected: [4]f32,
    style: lib.Style,
    child_nodes: []Node,
    pos: [2]f32 = .{ 0, 0 },
    size: [2]f32 = .{ 0, 0 },

    /// Initialize a node with the given expected layout, style, and child
    /// nodes. Child nodes are copied so they can be modified during layout.
    pub fn init(expected: [4]f32, style: lib.Style, child_nodes: anytype) Node {
        return .{
            .expected = expected,
            .style = style,
            .child_nodes = std.testing.allocator.dupe(Node, &child_nodes) catch @panic("OOM"),
        };
    }

    /// Free all the extra memory we had to allocate for the child nodes.
    pub fn deinitAll(self: Node) void {
        for (self.child_nodes) |child| {
            deinitAll(child);
        }

        std.testing.allocator.free(self.child_nodes);
    }
};

/// Run algo and check that all nodes in the tree have the expected layout.
pub fn expectLayout(root: Node) !void {
    var copy = root;
    defer root.deinitAll();

    var ctx: LayoutContext = .{};
    lib.compute_layout(&ctx, &copy, .{ 800, 600 });
    try expectLayoutsEqual(&copy);
}

// Recursive layout check.
fn expectLayoutsEqual(node: *const Node) !void {
    try expectEq(node.expected[0], node.pos[0]);
    try expectEq(node.expected[1], node.pos[1]);
    try expectEq(node.expected[2], node.size[0]);
    try expectEq(node.expected[3], node.size[1]);

    for (node.child_nodes) |*child| {
        try expectLayoutsEqual(child);
    }
}

// Compare floats with a small tolerance.
fn expectEq(a: f32, b: f32) !void {
    try std.testing.expectApproxEqAbs(a, b, 0.34);
}

// Adapter to make the layout algorithm work with our test tree.
const LayoutContext = struct {
    pub fn resolve(_: @This(), dim: lib.Dimension, base: f32) f32 {
        return dim.resolve(base);
    }

    pub fn style(_: @This(), node: *const Node) *const lib.Style {
        return &node.style;
    }

    pub fn children(_: @This(), node: *const Node) NodesIter {
        return .{ .nodes = node.child_nodes };
    }

    pub fn target(_: @This(), node: *Node) *Node {
        return node;
    }
};

// Just a simple iterator over a slice of nodes.
const NodesIter = struct {
    nodes: []Node,
    index: usize = 0,

    pub fn next(self: *@This()) ?*Node {
        if (self.index >= self.nodes.len) return null;
        defer self.index += 1;
        return &self.nodes[self.index];
    }
};

test {
    _ = @import("tests/_all.zig");
}
