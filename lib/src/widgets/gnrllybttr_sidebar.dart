import 'package:flutter/material.dart';
import 'package:gnrllybttr_sidebar/src/extensions/extensions.dart';
import 'package:gnrllybttr_sidebar/src/notifiers/notifiers.dart';
import 'package:gnrllybttr_sidebar/src/values/values.dart';

/// A widget that represents a sidebar in the [GnrllyBttrScaffold].
///
/// This widget provides a customizable sidebar that can be positioned on the left or right side of the screen.
/// It supports different modes (e.g., floating or expanded) and integrates with a controller to manage its state.
class GnrllyBttrSidebar extends StatelessWidget {
  /// Creates a [GnrllyBttrSidebar] with customizable properties.
  ///
  /// The [controller] manages the visibility and behavior of the sidebar.
  /// The [children] are the widgets displayed inside the sidebar.
  /// The [mode] defines the initial mode of the sidebar (e.g., floating or expanded).
  const GnrllyBttrSidebar({
    required this.controller,
    this.children = const <Widget>[],
    this.mode = SidebarMode.expanded,
    super.key,
  });

  /// The controller for managing the state and behavior of the sidebar.
  ///
  /// This includes visibility, mode switching, and other interactions.
  final GnrllyBttrSidebarController controller;

  /// The initial mode of the sidebar.
  ///
  /// Defaults to [SidebarMode.expanded], meaning the sidebar will occupy space in the layout.
  final SidebarMode mode;

  /// The list of widgets to be displayed as the content of the sidebar.
  ///
  /// Defaults to an empty list if no children are provided.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final floating = mode == SidebarMode.floating;
    final position = context.sidebarPosition;
    final common = context.decoration.common;
    final scaffold = context.decoration.scaffold;
    final decoration = context.decoration.sidebar[position]!;
    final left = position == SidebarPosition.left;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final mobile = maxWidth <= scaffold.mobileBreakpoint;
        final sidebarWidth = mobile ? maxWidth : decoration.expandedWidth;

        return ValueListenableBuilder<bool>(
          valueListenable: controller.visibleNotifier,
          builder: (context, visible, __) {
            return Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: common.animationDuration,
                  curve: common.animationCurve,
                  left: left ? (visible ? 0 : -sidebarWidth) : null,
                  top: 0,
                  right: left ? null : (visible ? 0 : -sidebarWidth),
                  bottom: 0,
                  child: MouseRegion(
                    onExit: floating && !mobile
                        ? (details) => controller.hideSidebar()
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: decoration.backgroundColor,
                      ),
                      padding: decoration.padding,
                      width: sidebarWidth,
                      child: Column(
                        children: <Widget>[
                          if (mobile)
                            Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Row(
                                children: <Widget>[
                                  if (left) const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      controller.toggleSidebarMode();
                                    },
                                  ),
                                  if (!left) const Spacer(),
                                ],
                              ),
                            ),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: children,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (floating && !mobile)
                  Positioned(
                    left: left ? 0 : null,
                    top: 0,
                    right: left ? null : 0,
                    bottom: 0,
                    child: MouseRegion(
                      onEnter: (details) => controller.showSidebar(),
                      child: SizedBox(width: 8.0),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
