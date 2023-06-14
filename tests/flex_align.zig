// GENERATED FILE - DO NOT EDIT

const node = @import("../tests.zig").createNode;
const expectLayout = @import("../tests.zig").expectLayout;

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, &.{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 }, .justify_content = .flex_start }, .{
            node(.{ 0, 0, 20, 20 }, &.{ .width = .{ .px = 20 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, &.{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 }, .justify_content = .center }, .{
            node(.{ 40, 0, 20, 20 }, &.{ .width = .{ .px = 20 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, &.{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 }, .justify_content = .flex_end }, .{
            node(.{ 80, 0, 20, 20 }, &.{ .width = .{ .px = 20 } }, .{}),
        }),
    );
}
