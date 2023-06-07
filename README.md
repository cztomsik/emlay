# emlay

Embeddable layout engine for the Zig programming language. **Work in progress**

## Overview
emlay is just an **algorithm that can be applied to any tree, with any style
struct, using any dimension types**. It makes no assumptions about your tree and
does not require you to create any special nodes.

## Usage
To use this library, you need to define a style struct and implement the
`LayoutContext` trait. Here is an example of what your style struct could look
like:

```zig
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
    flex_basis: Dimension = .auto,
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
```

Note that this struct is provided by the user, so you can add any fields you
want. The only requirement is that the struct has the listed fields, and the
enum values are using the same types. You are free to use different types for
any of the dimension fields. However, you must resolve that type in your
`LayoutContext.resolve()` function.

The `LayoutContext` trait is abstraction over your tree and how the dimensions
are resolved. Here's an example of what it could look like:

```zig
const MyLayoutContext = struct {
    pub fn style(self: *MyLayoutContext, node: *Node) *Style {
        return &node.style;
    }

    pub fn children(self: *MyLayoutContext, node: *Node) ChildrenIter {
        return .{ ... }
    }

    pub fn target(self: *MyLayoutContext, node: *Node) *Node {
        return node;
    }

    pub fn resolve(self: *MyLayoutContext, dimension: anytype, base: f32) f32 {
        return dim.resolve(base);
    }
};
```

- The `style()` function gets the style of a node.
- The `children()` function returns an iterator for the children of a node.
- The `target()` function returns the target where pos and size are written to.\
  This can be anything, including the node itself.
- The `resolve()` function resolves the dimensions and is used to convert them to
  a concrete value.

## License
This library is licensed under the MIT license.
