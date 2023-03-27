const std = @import("std");
const lib = @import("src/main.zig");

pub const Node = struct {
    expected: [4]f32,
    style: lib.Style,
    child_nodes: []Node,
    pos: [2]f32 = .{ 0, 0 },
    size: [2]f32 = .{ 0, 0 },

    pub fn children(self: *@This()) NodesIter {
        return .{ .nodes = self.child_nodes };
    }

    pub fn init(expected: [4]f32, style: lib.Style, child_nodes: anytype) Node {
        return .{
            .expected = expected,
            .style = style,
            .child_nodes = std.testing.allocator.dupe(Node, &child_nodes) catch @panic("OOM"),
        };
    }

    pub fn deinitAll(self: Node) void {
        for (self.child_nodes) |child| {
            deinitAll(child);
        }

        std.testing.allocator.free(self.child_nodes);
    }
};

pub fn expectLayout(root: Node) !void {
    var copy = root;
    defer root.deinitAll();

    lib.layout(&copy, .{ 800, 600 });
    try expectLayoutsEqual(&copy);
}

fn expectLayoutsEqual(node: *const Node) !void {
    try expectEq(node.expected[0], node.pos[0]);
    try expectEq(node.expected[1], node.pos[1]);
    try expectEq(node.expected[2], node.size[0]);
    try expectEq(node.expected[3], node.size[1]);

    for (node.child_nodes) |*child| {
        try expectLayoutsEqual(child);
    }
}

fn expectEq(a: f32, b: f32) !void {
    try std.testing.expectApproxEqAbs(a, b, 0.34);
}

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
