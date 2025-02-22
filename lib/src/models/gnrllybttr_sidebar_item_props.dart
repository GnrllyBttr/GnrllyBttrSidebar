import 'package:flutter/material.dart';
import 'package:gnrllybttr_sidebar/src/widgets/gnrllybttr_sidebar_item.dart';

/// A class that defines the properties for a single item in the GnrllyBttrSidebar.
///
/// This class encapsulates various attributes and behaviors of a sidebar item,
/// such as its level, hover behavior, selection state, expansion settings, and nested items.
class GnrllyBttrSidebarItemProps {
  /// Creates a [GnrllyBttrSidebarItemProps] with customizable properties.
  ///
  /// The [level] defines the nesting level of the item within the sidebar hierarchy.
  /// The [hoverable] determines whether the item can respond to hover events.
  /// The [selected] indicates whether the item is currently selected.
  /// The [initiallyExpanded] specifies whether the item starts in an expanded state.
  /// The [alwaysExpanded] ensures the item remains expanded regardless of user interaction.
  /// The [onHover] callback is triggered when the item is hovered over.
  /// The [onTap] callback is triggered when the item is tapped.
  /// The [nestedItems] list contains child items nested under this item.
  /// The [trailingBuilder] allows customization of the trailing widget displayed next to the item.
  const GnrllyBttrSidebarItemProps({
    this.onHover,
    this.onTap,
    this.trailingBuilder,
    this.level = 0,
    this.hoverable = true,
    this.selected = false,
    this.initiallyExpanded = false,
    this.alwaysExpanded = false,
    this.nestedItems = const <GnrllyBttrSidebarItem>[],
  });

  /// The nesting level of the item within the sidebar hierarchy.
  ///
  /// A level of `0` indicates a top-level item, while higher values indicate deeper nesting.
  final int level;

  /// Whether the item can respond to hover events.
  ///
  /// If set to `true`, the item will trigger the [onHover] callback when hovered over.
  final bool hoverable;

  /// Whether the item is currently selected.
  ///
  /// This property can be used to visually distinguish the selected item from others.
  final bool selected;

  /// Whether the item starts in an expanded state.
  ///
  /// If `true`, the item will initially display its nested items (if any).
  final bool initiallyExpanded;

  /// Whether the item should always remain expanded.
  ///
  /// If `true`, the item will ignore user interactions and always display its nested items.
  final bool alwaysExpanded;

  /// A callback triggered when the item is hovered over.
  ///
  /// The callback receives a boolean indicating whether the item is currently being hovered.
  final ValueChanged<bool>? onHover;

  /// A callback triggered when the item is tapped.
  ///
  /// The callback receives the current [BuildContext], which can be used to access the widget tree.
  final void Function(BuildContext)? onTap;

  /// A list of child items nested under this item.
  ///
  /// These nested items are displayed when the item is expanded.
  final List<GnrllyBttrSidebarItem> nestedItems;

  /// A builder function for customizing the trailing widget displayed next to the item.
  ///
  /// The builder receives the current [BuildContext] and a boolean indicating whether the item
  /// is expanded. This allows dynamic customization of the trailing widget based on the item's state.
  final Widget Function(BuildContext, bool)? trailingBuilder;

  /// Creates a copy of this [GnrllyBttrSidebarItemProps] with optional property overrides.
  ///
  /// This method is useful for creating modified versions of the current properties
  /// without altering the original instance. Each parameter corresponds to a property
  /// of the class and defaults to the current value if not provided.
  GnrllyBttrSidebarItemProps copyWith({
    int? level,
    bool? hoverable,
    bool? selected,
    bool? initiallyExpanded,
    bool? alwaysExpanded,
    ValueChanged<bool>? onHover,
    void Function(BuildContext)? onTap,
    List<GnrllyBttrSidebarItem>? nestedItems,
    Widget Function(BuildContext, bool)? trailingBuilder,
  }) {
    return GnrllyBttrSidebarItemProps(
      level: level ?? this.level,
      hoverable: hoverable ?? this.hoverable,
      selected: selected ?? this.selected,
      initiallyExpanded: initiallyExpanded ?? this.initiallyExpanded,
      alwaysExpanded: alwaysExpanded ?? this.alwaysExpanded,
      onHover: onHover ?? this.onHover,
      onTap: onTap ?? this.onTap,
      nestedItems: nestedItems ?? this.nestedItems,
      trailingBuilder: trailingBuilder ?? this.trailingBuilder,
    );
  }
}