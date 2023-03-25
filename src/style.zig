const std = @import("std");

// enums
pub const Display = enum { none, flex };
pub const FlexDirection = enum { row, column }; // , row_reverse, column_reverse }; // TODO
pub const FlexWrap = enum { no_wrap, wrap, wrap_reverse }; // TODO
pub const AlignContent = enum { flex_start, center, flex_end, stretch, space_between, space_around, space_evenly }; // TODO
pub const AlignItems = enum { flex_start, center, flex_end, baseline, stretch }; // TODO
pub const AlignSelf = enum { auto, flex_start, center, flex_end, baseline, stretch }; // TODO
pub const JustifyContent = enum { flex_start, center, flex_end, space_between, space_around, space_evenly }; // TODO
pub const Position = enum { static, absolute, relative }; // TODO

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

pub const Style = struct {
    display: Display = .flex,

    width: Dimension = .auto,
    height: Dimension = .auto,
    min_width: Dimension = .auto,
    min_height: Dimension = .auto,
    max_width: Dimension = .auto,
    max_height: Dimension = .auto,

    // TODO: compact
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
