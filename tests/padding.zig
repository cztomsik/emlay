// GENERATED FILE - DO NOT EDIT

const node = @import("../tests.zig").createNode;
const expectLayout = @import("../tests.zig").expectLayout;

test {
    try expectLayout(
        node(.{ 0, 0, 120, 120 }, .{ .display = .block, .width = .{ .px = 100 }, .height = .{ .px = 100 }, .padding_top = .{ .px = 10 }, .padding_right = .{ .px = 10 }, .padding_bottom = .{ .px = 10 }, .padding_left = .{ .px = 10 } }, .{
            node(.{ 10, 10, 25, 25 }, .{ .width = .{ .px = 25 }, .height = .{ .px = 25 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 120, 120 }, .{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 100 }, .padding_top = .{ .px = 10 }, .padding_right = .{ .px = 10 }, .padding_bottom = .{ .px = 10 }, .padding_left = .{ .px = 10 } }, .{
            node(.{ 10, 10, 25, 25 }, .{ .width = .{ .px = 25 }, .height = .{ .px = 25 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 100 }, .{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 100 }, .align_items = .flex_start }, .{
            node(.{ 0, 0, 45, 45 }, .{ .display = .flex, .padding_top = .{ .px = 10 }, .padding_right = .{ .px = 10 }, .padding_bottom = .{ .px = 10 }, .padding_left = .{ .px = 10 } }, .{
                node(.{ 10, 10, 25, 25 }, .{ .width = .{ .px = 25 }, .height = .{ .px = 25 } }, .{}),
            }),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 140, 130 }, .{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 100 }, .padding_top = .{ .px = 10 }, .padding_right = .{ .px = 15 }, .padding_bottom = .{ .px = 20 }, .padding_left = .{ .px = 25 } }, .{
            node(.{ 25, 10, 25, 25 }, .{ .width = .{ .px = 25 }, .height = .{ .px = 25 } }, .{}),
        }),
    );
}
