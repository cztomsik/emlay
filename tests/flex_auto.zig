// GENERATED FILE - DO NOT EDIT

const node = @import("../tests.zig").createNode;
const expectLayout = @import("../tests.zig").expectLayout;

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, .{ .display = .flex, .width = .{ .px = 100 } }, .{
            node(.{ 0, 0, 20, 20 }, .{ .display = .flex }, .{
                node(.{ 0, 0, 20, 20 }, .{ .width = .{ .px = 20 }, .height = .{ .px = 20 } }, .{}),
            }),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, .{ .display = .block, .width = .{ .px = 100 } }, .{
            node(.{ 0, 0, 100, 20 }, .{ .display = .flex }, .{
                node(.{ 0, 0, 20, 20 }, .{ .display = .flex }, .{
                    node(.{ 0, 0, 20, 20 }, .{ .width = .{ .px = 20 }, .height = .{ .px = 20 } }, .{}),
                }),
                node(.{ 20, 0, 20, 20 }, .{ .display = .flex }, .{
                    node(.{ 0, 0, 20, 20 }, .{ .width = .{ .px = 20 }, .height = .{ .px = 20 } }, .{}),
                }),
            }),
        }),
    );
}
