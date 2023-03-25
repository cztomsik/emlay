// GENERATED FILE - DO NOT EDIT

const node = @import("../tests.zig").Node.init;
const expectLayout = @import("../tests.zig").expectLayout;

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, .{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 } }, .{
            node(.{ 0, 0, 20, 20 }, .{ .width = .{ .px = 20 } }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, .{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 } }, .{
            node(.{ 0, 0, 100, 20 }, .{ .flex_grow = 1, .flex_shrink = 1, .flex_basis = .auto }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, .{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 } }, .{
            node(.{ 0, 0, 50, 20 }, .{ .flex_grow = 1, .flex_shrink = 1, .flex_basis = .auto }, .{}),
            node(.{ 50, 0, 50, 20 }, .{ .flex_grow = 1, .flex_shrink = 1, .flex_basis = .auto }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, .{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 } }, .{
            node(.{ 0, 0, 33, 20 }, .{ .flex_grow = 1, .flex_shrink = 1, .flex_basis = .auto }, .{}),
            node(.{ 33, 0, 67, 20 }, .{ .flex_grow = 2, .flex_shrink = 1, .flex_basis = .auto }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, .{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 } }, .{
            node(.{ 0, 0, 20, 20 }, .{ .width = .{ .px = 20 } }, .{}),
            node(.{ 20, 0, 80, 20 }, .{ .flex_grow = 1, .flex_shrink = 1, .flex_basis = .auto }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, .{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 } }, .{
            node(.{ 0, 0, 40, 20 }, .{ .flex_grow = 1, .flex_shrink = 1, .flex_basis = .auto }, .{}),
            node(.{ 40, 0, 20, 20 }, .{ .width = .{ .px = 20 } }, .{}),
            node(.{ 60, 0, 40, 20 }, .{ .flex_grow = 1, .flex_shrink = 1, .flex_basis = .auto }, .{}),
        }),
    );
}

test {
    try expectLayout(
        node(.{ 0, 0, 100, 20 }, .{ .display = .flex, .width = .{ .px = 100 }, .height = .{ .px = 20 } }, .{
            node(.{ 0, 0, 10, 20 }, .{ .width = .{ .px = 10 } }, .{}),
            node(.{ 10, 0, 30, 20 }, .{ .flex_grow = 3, .flex_shrink = 1, .flex_basis = .auto }, .{}),
            node(.{ 40, 0, 20, 20 }, .{ .width = .{ .px = 20 } }, .{}),
            node(.{ 60, 0, 40, 20 }, .{ .flex_grow = 4, .flex_shrink = 1, .flex_basis = .auto }, .{}),
        }),
    );
}
