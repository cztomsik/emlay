const std = @import("std");
const lib = @import("src/main.zig");
const Node = lib.Node;

/// Initialize a node with the given expected layout, style, and children.
pub fn createNode(expected: [4]f32, style: lib.Style, children: anytype) *Node {
    var ctx = std.testing.allocator.create([4]f32) catch @panic("OOM");
    ctx.* = expected;

    var node = std.testing.allocator.create(lib.Node) catch @panic("OOM");
    node.* = .{
        .context = @as(*anyopaque, ctx),
        .style = style,
    };

    var prev: ?*Node = null;
    inline for (children) |ch| {
        if (prev) |p| p.next_sibling = ch else node.first_child = ch;
        prev = ch;
    }

    return node;
}

/// Free the whole tree.
pub fn deinitAll(node: *Node) void {
    var iter = node.children();
    while (iter.next()) |child| {
        deinitAll(child);
    }

    var expected = @ptrCast(*[4]f32, @alignCast(@alignOf([4]f32), node.context));

    std.testing.allocator.destroy(expected);
    std.testing.allocator.destroy(node);
}

/// Run algo and check that all nodes in the tree have the expected layout.
pub fn expectLayout(root: *Node) !void {
    defer deinitAll(root);

    root.compute(.{ 800, 600 });
    try expectLayoutsEqual(root);
}

// Recursive layout check.
fn expectLayoutsEqual(node: *Node) !void {
    var expected = @ptrCast(*[4]f32, @alignCast(@alignOf([4]f32), node.context));

    try expectEq(expected[0], node.pos[0]);
    try expectEq(expected[1], node.pos[1]);
    try expectEq(expected[2], node.size[0]);
    try expectEq(expected[3], node.size[1]);

    var iter = node.children();
    while (iter.next()) |child| {
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
