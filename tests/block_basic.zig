// GENERATED FILE - DO NOT EDIT

const node = @import("../tests.zig").createNode;
const expectLayout = @import("../tests.zig").expectLayout;

test {
    try expectLayout(
        node(.{ 0, 0, 100, 40 }, .{ .display = .block, .width = .{ .px = 100 }, .height = .{ .px = 40 } }, .{
            node(.{ 0, 0, 20, 20 }, .{ .display = .block, .width = .{ .px = 20 }, .height = .{ .px = 20 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 40 }, .{ .display = .block, .width = .{ .px = 100 }, .height = .{ .px = 40 } }, .{
            node(.{ 0, 0, 20, 20 }, .{ .display = .block, .width = .{ .px = 20 }, .height = .{ .px = 20 } }, .{}),
            node(.{ 0, 20, 40, 20 }, .{ .display = .block, .width = .{ .px = 40 }, .height = .{ .px = 20 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 40 }, .{ .display = .block, .width = .{ .px = 100 }, .height = .{ .px = 40 } }, .{
            node(.{ 0, 0, 50, 20 }, .{ .display = .block, .width = .{ .percent = 50 }, .height = .{ .percent = 50 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 40 }, .{ .display = .block, .width = .{ .px = 100 }, .height = .{ .px = 40 } }, .{
            node(.{ 0, 0, 50, 20 }, .{ .display = .block, .width = .{ .percent = 50 }, .height = .{ .percent = 50 } }, .{}),
            node(.{ 0, 20, 75, 20 }, .{ .display = .block, .width = .{ .percent = 75 }, .height = .{ .percent = 50 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 40 }, .{ .display = .block, .width = .{ .px = 100 }, .height = .{ .px = 40 } }, .{
            node(.{ 0, 0, 100, 20 }, .{ .display = .block, .height = .{ .px = 20 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 40 }, .{ .display = .block, .width = .{ .px = 100 }, .height = .{ .px = 40 } }, .{
            node(.{ 0, 0, 100, 10 }, .{ .display = .block, .height = .{ .px = 10 } }, .{}),
            node(.{ 0, 10, 100, 20 }, .{ .display = .block, .height = .{ .px = 20 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 60 }, .{ .display = .block, .width = .{ .px = 100 } }, .{
            node(.{ 0, 0, 100, 20 }, .{ .display = .block, .height = .{ .px = 20 } }, .{}),
            node(.{ 0, 20, 100, 40 }, .{ .display = .block, .height = .{ .px = 40 } }, .{}),
        }),
    );
}
