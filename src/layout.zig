const std = @import("std");
const isNan = std.math.isNan;
const Style = @import("style.zig").Style;

fn isLayoutContext(comptime T: anytype) bool {
    return std.meta.trait.hasDecls(T, .{ "resolve", "style", "children", "target" });
}

/// Compute layout for the whole tree, using the provided `LayoutContext` impl
/// with the following methods:
/// - ctx.resolve(dim: anytype, base: f32) -> f32, where dim is some dimension type used in the style
/// - ctx.style(node) should return pointer to some struct with all the style properties
/// - ctx.children(node) should return iterator over children (Node)
/// - ctx.target(node) should return pointer to some struct with pos and size properties
///   (TODO: order, border, cache, ?)
pub fn layout(ctx: anytype, node: anytype, size: [2]f32) void {
    if (comptime !isLayoutContext(@TypeOf(ctx.*))) @compileError("ctx must implement LayoutContext trait");

    const style = ctx.style(node);
    const target = ctx.target(node);
    target.size[0] = style.width.resolve(size[0]);
    target.size[1] = style.height.resolve(size[1]);
    computeNode(ctx, node, style, target.size);
}

// Compute layout for the node, given its base size. This is because part of
// job has been already done by the parent (e.g. flexbox).
fn computeNode(ctx: anytype, node: anytype, style: anytype, size: [2]f32) void {
    const is_row = style.flex_direction == .row or style.flex_direction == .row_reverse;
    // const is_reverse = style.flex_direction == .row_reverse or style.flex_direction == .column_reverse;
    const main: u1 = if (is_row) 0 else 1;
    const cross: u1 = ~main;

    // Available space for flexing + counters
    var flex_space = node.size[main];
    var grows: f32 = 0;
    var shrinks: f32 = 0;

    // Go through children and determine their base sizes, and total flex space
    // available for growing/shrinking. This is done before positioning, as we
    // need to know the size of the container before we can compute flex space.
    var iter = ctx.children(node);
    while (iter.next()) |ch| {
        const ch_style = ctx.style(ch);
        const ch_target = ctx.target(ch);

        // Update counters
        grows += ch_style.flex_grow;
        shrinks += ch_style.flex_shrink;

        // Determine base size for the child
        ch_target.size[0] = ch_style.width.resolve(size[0]);
        ch_target.size[1] = ch_style.height.resolve(size[1]);
        if (isNan(ch_target.size[main])) ch_target.size[main] = 0;
        if (isNan(ch_target.size[cross])) ch_target.size[cross] = size[cross]; // TODO: - margin[w/h]
        const basis = ch_style.flex_basis.resolve(size[main]);
        if (!isNan(basis)) ch_target.size[main] = basis;

        // TODO: skip if we can, but items should not directly cause overflow (text or child-child with given size)
        computeNode(ctx, ch, ch_style, ch_target.size);

        // Determine cross size & subtract from flex space
        node.size[cross] = @max(node.size[cross], ch_target.size[cross]);
        flex_space -= @max(0, ch_target.size[main]);
    }

    // Determine final size of the container
    node.size[main] = @max(node.size[main], -flex_space);

    // Starting position for children
    var pos: [2]f32 = .{
        @max(0, style.padding_left.resolve(size[0])),
        @max(0, style.padding_top.resolve(size[1])),
    };

    // grow/shrink, position, reverse, align, stretch, margin, ...
    iter = ctx.children(node);
    while (iter.next()) |ch| {
        const ch_style = ctx.style(ch);
        const ch_target = ctx.target(ch);

        ch_target.pos = pos;

        if (flex_space > 0 and ch_style.flex_grow > 0) {
            ch_target.size[main] += (flex_space / grows) * ch_style.flex_grow;
        }

        if (flex_space < 0 and ch_style.flex_shrink > 0) {
            ch_target.size[main] += (flex_space / shrinks) * ch_style.flex_shrink;
        }

        // ch_target.pos[main] += @max(0, ch_style.margin_left/top.resolve())
        // pos[main] += @max(0, ch_style.margin_x/y.resolve())

        // TODO: align

        // Now that we have the size, we can compute everything again, with
        // correct positions.
        computeNode(ctx, ch, ch_style, ch_target.size);

        // advance
        pos[main] += ch_target.size[main];
    }
}
