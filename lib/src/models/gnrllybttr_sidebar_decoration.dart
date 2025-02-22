import 'package:flutter/material.dart';
import 'package:gnrllybttr_sidebar/src/values/values.dart';

/// A class that defines the overall decoration for the GnrllyBttrSidebar.
///
/// This class encapsulates the common, scaffold, sidebar, and sidebar item decorations.
/// It ensures that both `sidebar` and `sidebarItem` maps contain entries for both left and right positions.
class GnrllyBttrDecoration {
  /// Creates a [GnrllyBttrDecoration] with customizable properties.
  ///
  /// The [common] property defines shared animation settings.
  /// The [scaffold] property defines the scaffold's appearance.
  /// The [sidebar] property defines the appearance of sidebars at different positions.
  /// The [sidebarItem] property defines the appearance of items within the sidebars.
  ///
  /// Both [sidebar] and [sidebarItem] must have entries for [SidebarPosition.left] and [SidebarPosition.right].
  const GnrllyBttrDecoration({
    this.common = const GnrllyBttrCommonDecoration(),
    this.scaffold = const GnrllyBttrScaffoldDecoration(),
    this.sidebar = const <SidebarPosition, GnrllyBttrSidebarDecoration>{
      SidebarPosition.left: GnrllyBttrSidebarDecoration(),
      SidebarPosition.right: GnrllyBttrSidebarDecoration(),
    },
    this.sidebarItem = const <SidebarPosition, GnrllyBttrSidebarItemDecoration>{
      SidebarPosition.left: GnrllyBttrSidebarItemDecoration(),
      SidebarPosition.right: GnrllyBttrSidebarItemDecoration(),
    },
  })  : assert(
          sidebar.length == 2,
          'The sidebar map must both have a left and right key.',
        ),
        assert(
          sidebarItem.length == 2,
          'The sidebarItem map must both have a left and right key.',
        );

  /// Defines common animation settings such as duration and curve.
  final GnrllyBttrCommonDecoration common;

  /// Defines the appearance of the scaffold, including background color, padding, and border radius.
  final GnrllyBttrScaffoldDecoration scaffold;

  /// A map defining the appearance of sidebars at different positions (left and right).
  final Map<SidebarPosition, GnrllyBttrSidebarDecoration> sidebar;

  /// A map defining the appearance of sidebar items at different positions (left and right).
  final Map<SidebarPosition, GnrllyBttrSidebarItemDecoration> sidebarItem;
}

/// A class that defines common animation settings for the sidebar.
///
/// This includes the duration and curve used for animations.
class GnrllyBttrCommonDecoration {
  /// Creates a [GnrllyBttrCommonDecoration] with customizable properties.
  ///
  /// The [animationDuration] defines the duration of animations.
  /// The [animationCurve] defines the curve used for animations.
  const GnrllyBttrCommonDecoration({
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  /// The duration of animations, defaulting to 300 milliseconds.
  final Duration animationDuration;

  /// The curve used for animations, defaulting to [Curves.easeInOut].
  final Curve animationCurve;
}

/// A class that defines the appearance of the scaffold.
///
/// This includes the background color, padding, and border radius.
class GnrllyBttrScaffoldDecoration {
  /// Creates a [GnrllyBttrScaffoldDecoration] with customizable properties.
  ///
  /// The [backgroundColor] defines the background color of the scaffold.
  /// The [mobileBreakpoint] defines the breakpoint at which the sidebar switches to full screen
  /// The [inset] determines whether the scaffold is inset.
  /// The [padding] defines the padding around the scaffold's content.
  /// The [borderRadius] defines the border radius of the scaffold.
  const GnrllyBttrScaffoldDecoration({
    this.backgroundColor = const Color(0xFF18181B),
    this.mobileBreakpoint = 600.0,
    this.inset = false,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });

  /// The background color of the scaffold, defaulting to a dark gray (#18181B).
  final Color backgroundColor;

  /// The breakpoint at which the sidebar switches to full screen, defaulting to 600.0.
  final double mobileBreakpoint;

  /// Whether the scaffold is inset, defaulting to false.
  final bool inset;

  /// The padding around the scaffold's content, defaulting to 16.0 on all sides.
  final EdgeInsets padding;

  /// The border radius of the scaffold, defaulting to 8.0.
  final BorderRadius borderRadius;
}

/// A class that defines the appearance of a sidebar.
///
/// This includes the background color, collapsed and expanded widths, and padding.
class GnrllyBttrSidebarDecoration {
  /// Creates a [GnrllyBttrSidebarDecoration] with customizable properties.
  ///
  /// The [backgroundColor] defines the background color of the sidebar.
  /// The [collapsedWidth] defines the width of the sidebar when collapsed.
  /// The [expandedWidth] defines the width of the sidebar when expanded.
  /// The [padding] defines the padding inside the sidebar.
  const GnrllyBttrSidebarDecoration({
    this.backgroundColor = const Color(0xFF18181B),
    this.collapsedWidth = 56.0,
    this.expandedWidth = 300.0,
    this.padding = const EdgeInsets.all(16.0),
  });

  /// The background color of the sidebar, defaulting to a dark gray (#18181B).
  final Color backgroundColor;

  /// The width of the sidebar when collapsed, defaulting to 56.0.
  final double collapsedWidth;

  /// The width of the sidebar when expanded, defaulting to 300.0.
  final double expandedWidth;

  /// The padding inside the sidebar, defaulting to 16.0 on all sides.
  final EdgeInsets padding;
}

/// A class that defines the appearance of items within a sidebar.
///
/// This includes badge styling, branch styling, content icons, and item interactions.
class GnrllyBttrSidebarItemDecoration {
  /// Creates a [GnrllyBttrSidebarItemDecoration] with customizable properties.
  ///
  /// The [badgePadding] defines the padding around the badge.
  /// The [badgeShape] defines the shape of the badge.
  /// The [badgeColor] defines the background color of the badge.
  /// The [badgeTextColor] defines the text color of the badge.
  /// The [badgeFontSize] defines the font size of the badge text.
  /// The [branchColor] defines the color of the branch lines.
  /// The [branchMargin] defines the margin around the branch lines.
  /// The [branchVisible] determines whether branch lines are visible.
  /// The [branchWidth] defines the width of the branch lines.
  /// The [contentCollapsedIcon] defines the icon displayed when content is collapsed.
  /// The [contentExpandedIcon] defines the icon displayed when content is expanded.
  /// The [contentIconColor] defines the color of content icons.
  /// The [contentTextColor] defines the color of content text.
  /// The [itemBorderRadius] defines the border radius of sidebar items.
  /// The [itemSelectedColor] defines the color of selected items.
  /// The [itemHoverColor] defines the color of hovered items.
  /// The [itemPadding] defines the padding around sidebar items.
  /// The [nestedItemIndentFactor] defines the indentation factor for nested items.
  /// The [progressBackgroundColor] defines the background color of progress indicators.
  /// The [progressColor] defines the color of progress indicators.
  const GnrllyBttrSidebarItemDecoration({
    this.badgePadding = const EdgeInsets.all(8.0),
    this.badgeShape = BoxShape.circle,
    this.badgeColor = const Color(0xFFFF9800),
    this.badgeTextColor = const Color(0xFFFFFFFF),
    this.badgeFontSize = 16.0,
    this.branchColor = const Color(0xFF27272A),
    this.branchMargin = const EdgeInsets.only(left: 8.0),
    this.branchVisible = true,
    this.branchWidth = 2.0,
    this.contentCollapsedIcon = Icons.keyboard_arrow_right_rounded,
    this.contentExpandedIcon = Icons.keyboard_arrow_down_rounded,
    this.contentIconColor = const Color(0xFFEAEAEA),
    this.contentTextColor = const Color(0xFFFAFAFA),
    this.itemBorderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.itemSelectedColor = const Color(0xFF27272A),
    this.itemHoverColor = const Color(0xFF27272A),
    this.itemPadding = const EdgeInsets.all(8.0),
    this.nestedItemIndentFactor = 4.0,
    this.progressBackgroundColor = const Color(0xFF27272A),
    this.progressColor = const Color(0xFFEAEAEA),
  });

  /// The padding around the badge, defaulting to 8.0 on all sides.
  final EdgeInsets badgePadding;

  /// The shape of the badge, defaulting to a circle.
  final BoxShape badgeShape;

  /// The background color of the badge, defaulting to orange (#FF9800).
  final Color badgeColor;

  /// The text color of the badge, defaulting to white (#FFFFFFFF).
  final Color badgeTextColor;

  /// The font size of the badge text, defaulting to 16.0.
  final double badgeFontSize;

  /// The color of the branch lines, defaulting to a dark gray (#27272A).
  final Color branchColor;

  /// The margin around the branch lines, defaulting to 8.0 on the left.
  final EdgeInsets branchMargin;

  /// Whether branch lines are visible, defaulting to true.
  final bool branchVisible;

  /// The width of the branch lines, defaulting to 2.0.
  final double branchWidth;

  /// The icon displayed when content is collapsed, defaulting to [Icons.keyboard_arrow_right_rounded].
  final IconData contentCollapsedIcon;

  /// The icon displayed when content is expanded, defaulting to [Icons.keyboard_arrow_down_rounded].
  final IconData contentExpandedIcon;

  /// The color of content icons, defaulting to a light gray (#EAEAEA).
  final Color contentIconColor;

  /// The color of content text, defaulting to a very light gray (#FAFAFA).
  final Color contentTextColor;

  /// The border radius of sidebar items, defaulting to 4.0.
  final BorderRadius itemBorderRadius;

  /// The color of selected items, defaulting to a dark gray (#27272A).
  final Color itemSelectedColor;

  /// The color of hovered items, defaulting to a dark gray (#27272A).
  final Color itemHoverColor;

  /// The padding around sidebar items, defaulting to 8.0 on all sides.
  final EdgeInsets itemPadding;

  /// The indentation factor for nested items, defaulting to 4.0.
  final double nestedItemIndentFactor;

  /// The background color of progress indicators, defaulting to a dark gray (#27272A).
  final Color progressBackgroundColor;

  /// The color of progress indicators, defaulting to a light gray (#EAEAEA).
  final Color progressColor;
}
