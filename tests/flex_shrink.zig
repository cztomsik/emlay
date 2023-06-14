// GENERATED FILE - DO NOT EDIT

const node = @import("../tests.zig").createNode;
const expectLayout = @import("../tests.zig").expectLayout;

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, &.{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 } }, .{
            node(.{ 0, 0, 60, 20 }, &.{ .width = .{ .px = 100 }, .flex_shrink = 2 }, .{}),
            node(.{ 60, 0, 40, 20 }, &.{ .width = .{ .px = 100 }, .flex_shrink = 3 }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, &.{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 } }, .{
            node(.{ 0, 0, 67, 20 }, &.{ .width = .{ .px = 100 } }, .{}),
            node(.{ 67, 0, 33, 20 }, &.{ .width = .{ .px = 100 }, .flex_shrink = 2 }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, &.{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 } }, .{
            node(.{ 0, 0, 60, 20 }, &.{ .width = .{ .px = 100 }, .flex_shrink = 1 }, .{}),
            node(.{ 60, 0, 40, 20 }, &.{ .width = .{ .px = 100 }, .flex_shrink = 1.5 }, .{}),
        }),
    );
}
