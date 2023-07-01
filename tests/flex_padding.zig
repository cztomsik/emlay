// GENERATED FILE - DO NOT EDIT

const node = @import("../tests.zig").createNode;
const expectLayout = @import("../tests.zig").expectLayout;

test {
    try expectLayout(
        node(.{ 0, 0, 120, 60 }, .{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 40 }, .padding_top = .{ .px = 10 }, .padding_right = .{ .px = 10 }, .padding_bottom = .{ .px = 10 }, .padding_left = .{ .px = 10 } }, .{
            node(.{ 10, 10, 20, 20 }, .{ .display = .flex, .width = .{ .px = 20 }, .height = .{ .px = 20 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 120, 80 }, .{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 40 }, .padding_top = .{ .px = 20 }, .padding_right = .{ .px = 10 }, .padding_bottom = .{ .px = 20 }, .padding_left = .{ .px = 10 } }, .{
            node(.{ 10, 20, 100, 20 }, .{ .display = .flex, .flex_grow = 1, .flex_shrink = 1, .flex_basis = .auto, .height = .{ .px = 20 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 120, 60 }, .{ .display = .flex, .width = .{ .px = 60 }, .padding_top = .{ .px = 10 }, .padding_right = .{ .px = 20 }, .padding_bottom = .{ .px = 30 }, .padding_left = .{ .px = 40 } }, .{
            node(.{ 40, 10, 60, 20 }, .{ .display = .flex, .flex_grow = 1, .flex_shrink = 1, .flex_basis = .auto, .height = .{ .px = 20 } }, .{}),
        }),
    );
}
