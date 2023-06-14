const std = @import("std");
const lib = @import("src/main.zig");

/// A node in our test tree.
const Node = lib.Node(struct {
    expected: [4]f32,
    children: []Node,
}, ChildrenIter);

/// Tell the layout algorithm how to iterate over our children.
const ChildrenIter = struct {
    nodes: []Node,
    index: usize = 0,

    pub fn init(node: *Node) @This() {
        return .{ .nodes = node.context.children };
    }

    pub fn next(self: *@This()) ?*Node {
        if (self.index >= self.nodes.len) return null;
        defer self.index += 1;
        return &self.nodes[self.index];
    }
};

/// Initialize a node with the given expected layout, style, and child
/// nodes. Child nodes are copied so they can be modified during layout.
pub fn createNode(expected: [4]f32, style: *const lib.Style, children: anytype) Node {
    return .{
        .context = .{
            .expected = expected,
            .children = std.testing.allocator.dupe(Node, &children) catch @panic("OOM"),
        },
        .style = style,
    };
}

/// Free all the extra memory we had to allocate for the child nodes.
pub fn deinitAll(node: Node) void {
    for (node.context.children) |child| {
        deinitAll(child);
    }

    std.testing.allocator.free(node.context.children);
}

/// Run algo and check that all nodes in the tree have the expected layout.
pub fn expectLayout(root: Node) !void {
    var copy = root;
    defer deinitAll(root);

    copy.compute(.{ 800, 600 });
    try expectLayoutsEqual(&copy);
}

// Recursive layout check.
fn expectLayoutsEqual(node: *const Node) !void {
    try expectEq(node.context.expected[0], node.pos[0]);
    try expectEq(node.context.expected[1], node.pos[1]);
    try expectEq(node.context.expected[2], node.size[0]);
    try expectEq(node.context.expected[3], node.size[1]);

    for (node.context.children) |*child| {
        try expectLayoutsEqual(child);
    }
}

// Compare floats with a small tolerance.
fn expectEq(a: f32, b: f32) !void {
    try std.testing.expectApproxEqAbs(a, b, 0.34);
}

test {
    _ = @import("tests/_all.zig");
}
