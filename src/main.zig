const std = @import("std");
const common = @import("common.zig");

// Enums for all the different style properties. See the CSS spec for more info.
pub const Display = enum { none, block, flex };
pub const FlexDirection = enum { row, column }; // TODO: row_reverse, column_reverse
pub const FlexWrap = enum { no_wrap, wrap }; // TODO: wrap_reverse
pub const AlignContent = enum { flex_start, center, flex_end, stretch, space_between, space_around, space_evenly }; // TODO
pub const AlignItems = enum { flex_start, center, flex_end, baseline, stretch }; // TODO
pub const AlignSelf = enum { auto, flex_start, center, flex_end, baseline, stretch }; // TODO
pub const JustifyContent = enum { flex_start, center, flex_end, space_between, space_around, space_evenly }; // TODO
pub const Position = enum { static, absolute, relative }; // TODO

/// Value type for all the different dimension properties.
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

    pub fn resolve0(self: Dimension, base: f32) f32 {
        return @max(@as(f32, 0), self.resolve(base));
    }
};

/// Layout properties for a node.
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

    border_top_width: Dimension = .{ .px = 0 },
    border_right_width: Dimension = .{ .px = 0 },
    border_bottom_width: Dimension = .{ .px = 0 },
    border_left_width: Dimension = .{ .px = 0 },
};

/// A node in the layout tree.
pub const Node = struct {
    style: Style = .{},
    context: ?*anyopaque = null,
    measure_fn: ?*const fn (*Node, [2]f32) [2]f32 = null, // TODO

    // children
    first_child: ?*Node = null,
    next_sibling: ?*Node = null,

    // result
    pos: [2]f32 = .{ 0, 0 },
    size: [2]f32 = .{ 0, 0 },

    /// An iterator over the children of a node.
    pub const Children = struct {
        next_child: ?*Node,

        pub fn next(self: *Children) ?*Node {
            const ch = self.next_child orelse return null;
            self.next_child = ch.next_sibling;
            return ch;
        }
    };

    /// Get iterator over the children of this node.
    pub fn children(self: *Node) Children {
        return .{ .next_child = self.first_child };
    }

    /// Compute the layout of this node and its children.
    pub fn compute(self: *Node, size: [2]f32) void {
        self.size = .{
            self.style.width.resolve(size[0]),
            self.style.height.resolve(size[1]),
        };

        common.computeNode(self, self.size);
    }
};
