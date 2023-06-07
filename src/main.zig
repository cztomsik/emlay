const std = @import("std");
const common = @import("common.zig");

// Enums, these are fixed, you need to use these types
pub const Display = enum { none, block, flex };
pub const FlexDirection = enum { row, column, row_reverse, column_reverse }; // TODO: row_reverse, column_reverse
pub const FlexWrap = enum { no_wrap, wrap, wrap_reverse }; // TODO
pub const AlignContent = enum { flex_start, center, flex_end, stretch, space_between, space_around, space_evenly }; // TODO
pub const AlignItems = enum { flex_start, center, flex_end, baseline, stretch }; // TODO
pub const AlignSelf = enum { auto, flex_start, center, flex_end, baseline, stretch }; // TODO
pub const JustifyContent = enum { flex_start, center, flex_end, space_between, space_around, space_evenly }; // TODO
pub const Position = enum { static, absolute, relative }; // TODO

/// Basic dimension type. You can use this or create your own.
pub const Dimension = union(enum) {
    auto,
    px: f32,
    percent: f32,

    pub fn resolve(self: Dimension, base: f32) f32 {
        return switch (self) {
            .auto => std.math.nan_f32,
            .px => |v| v,
            .percent => |v| v / 100 * base,
        };
    }
};

/// An example of how your style struct could look like. Note it's using the
/// provided `Dimension` type but you are free to use any type you want. It can
/// be any type which your `LayoutContext.resolve()` method can handle. You can
/// even use multiple different types and use them for different properties.
pub const Style = struct {
    display: Display = .flex,

    width: Dimension = .auto,
    height: Dimension = .auto,
    min_width: Dimension = .auto,
    min_height: Dimension = .auto,
    max_width: Dimension = .auto,
    max_height: Dimension = .auto,

    flex_grow: f32 = 0,
    flex_shrink: f32 = 1,
    flex_basis: Dimension = .auto, // .percent = 0
    flex_direction: FlexDirection = .row,
    flex_wrap: FlexWrap = .no_wrap,

    align_content: AlignContent = .stretch,
    align_items: AlignItems = .stretch,
    align_self: AlignSelf = .auto,
    justify_content: JustifyContent = .flex_start,

    padding_top: Dimension = .{ .px = 0 },
    padding_right: Dimension = .{ .px = 0 },
    padding_bottom: Dimension = .{ .px = 0 },
    padding_left: Dimension = .{ .px = 0 },

    margin_top: Dimension = .{ .px = 0 },
    margin_right: Dimension = .{ .px = 0 },
    margin_bottom: Dimension = .{ .px = 0 },
    margin_left: Dimension = .{ .px = 0 },
};

/// LayoutContext is anything which has following methods:
/// - ctx.style(node) should return pointer to some struct with all the style properties
/// - ctx.children(node) should return iterator over children (Node)
/// - ctx.target(node) should return pointer to some struct with pos and size properties
/// - ctx.resolve(dim: anytype, base: f32) -> f32, where dim is some dimension type used in the style
fn isLayoutContext(comptime T: type) bool {
    return std.meta.trait.hasDecls(T, .{ "resolve", "style", "children", "target" });
}

/// Compute layout for the whole tree, using the provided `LayoutContext` impl
/// See `isLayoutContext` for more info.
pub fn compute_layout(ctx: anytype, node: anytype, size: [2]f32) void {
    const is_ctx = comptime if (@TypeOf(ctx) == type) isLayoutContext(ctx) else isLayoutContext(@TypeOf(ctx.*));
    if (comptime !is_ctx) @compileError("ctx must implement LayoutContext trait");

    const style = ctx.style(node);
    const target = ctx.target(node);

    target.size = .{
        ctx.resolve(style.width, size[0]),
        ctx.resolve(style.height, size[1]),
    };

    common.computeNode(ctx, node, style, target, target.size);
}
