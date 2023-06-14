// GENERATED FILE - DO NOT EDIT

const node = @import("../tests.zig").createNode;
const expectLayout = @import("../tests.zig").expectLayout;

test {
    try expectLayout(
        node(.{ 0, 0, 20, 100 }, &.{ .display = .flex, .flex_direction = .column, .width = .{ .px = 20 }, .height = .{ .px = 100 } }, .{
            node(.{ 0, 0, 20, 20 }, &.{ .height = .{ .px = 20 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 200 }, &.{ .display = .flex, .flex_direction = .column, .width = .{ .px = 100 }, .height = .{ .px = 200 } }, .{
            node(.{ 0, 0, 100, 50 }, &.{ .display = .flex }, .{
                node(.{ 0, 0, 50, 50 }, &.{ .width = .{ .px = 50 }, .height = .{ .px = 50 } }, .{}),
            }),
            node(.{ 0, 50, 100, 150 }, &.{ .flex_grow = 1, .flex_shrink = 1, .flex_basis = .auto }, .{}),
        }),
    );
}
