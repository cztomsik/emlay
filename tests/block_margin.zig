// GENERATED FILE - DO NOT EDIT

const node = @import("../tests.zig").createNode;
const expectLayout = @import("../tests.zig").expectLayout;

test {
    try expectLayout(
        node(.{ 0, 0, 100, 40 }, .{ .display = .block, .width = .{ .px = 100 }, .height = .{ .px = 40 } }, .{
            node(.{ 0, 20, 20, 20 }, .{ .display = .block, .width = .{ .px = 20 }, .height = .{ .px = 20 }, .margin_top = .{ .px = 20 } }, .{}),
        }),
    );
}
