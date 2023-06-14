const std = @import("std");
const common = @import("common.zig");

// Enums for all the different style properties. See the CSS spec for more info.
pub const Display = enum { none, block, flex };
pub const FlexDirection = enum { row, column }; // TODO: row_reverse, column_reverse
pub const FlexWrap = enum { no_wrap, wrap, wrap_reverse }; // TODO
pub const AlignContent = enum { flex_start, center, flex_end, stretch, space_between, space_around, space_evenly }; // TODO
pub const AlignItems = enum { flex_start, center, flex_end, baseline, stretch }; // TODO
pub const AlignSelf = enum { auto, flex_start, center, flex_end, baseline, stretch }; // TODO
pub const JustifyContent = enum { flex_start, center, flex_end, space_between, space_around, space_evenly }; // TODO
pub const Position = enum { static, absolute, relative }; // TODO

/// A dimension can be auto, a fixed pixel value, or a fraction of the parent's
/// size. The fraction is a number between 0 and 1.
pub const Dimension = union(enum) {
    auto,
    px: f32,
    fraction: f32,

    pub fn resolve(self: Dimension, base: f32) f32 {
        return switch (self) {
            .auto => std.math.nan_f32,
            .px => |v| v,
            .fraction => |v| v * base,
        };
    }
};

/// A style is a set of properties that can be applied to a node.
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

/// A node is a single element in the layout tree.
pub fn Node(comptime Context: type, comptime Children: type) type {
    return struct {
        context: Context,
        style: *const Style,
        pos: [2]f32 = .{ 0, 0 },
        size: [2]f32 = .{ 0, 0 },
        measure_fn: ?*const fn (*Self, [2]f32) [2]f32 = null, // TODO

        const Self = @This();

        /// Get iterator over the children of this node.
        pub fn children(self: *Self) Children {
            return Children.init(self);
        }

        /// Compute the layout of this node and its children.
        pub fn compute(self: *Self, size: [2]f32) void {
            self.size = .{
                self.style.width.resolve(size[0]),
                self.style.height.resolve(size[1]),
            };

            common.computeNode(self, self.size);
        }
    };
}
