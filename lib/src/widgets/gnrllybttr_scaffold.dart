import 'package:flutter/material.dart';
import 'package:gnrllybttr_sidebar/src/models/models.dart';
import 'package:gnrllybttr_sidebar/src/notifiers/notifiers.dart';
import 'package:gnrllybttr_sidebar/src/providers/providers.dart';
import 'package:gnrllybttr_sidebar/src/values/values.dart';
import 'package:gnrllybttr_sidebar/src/widgets/widgets.dart';

/// A customizable scaffold widget that supports left and right sidebars.
///
/// This widget provides a flexible layout structure with optional sidebars on
/// the left and/or right sides of the main content. It integrates with various
/// providers and controllers to manage the appearance, behavior, and state of
/// the sidebars.
class GnrllyBttrScaffold extends StatefulWidget {
  /// Creates a [GnrllyBttrScaffold] with customizable properties.
  ///
  /// The [body] is the main content of the scaffold.
  /// The [decoration] defines the overall appearance and behavior of the
  /// scaffold and sidebars.
  /// The [leftSidebar] configures the left sidebar, defaulting to an empty
  /// configuration.
  /// The [rightSidebar] configures the right sidebar, defaulting to an empty
  /// configuration.
  const GnrllyBttrScaffold({
    required this.body,
    this.decoration,
    this.leftSidebar = const GnrllyBttrSidebarConfig(),
    this.rightSidebar = const GnrllyBttrSidebarConfig(),
    super.key,
  });

  /// The decoration settings for the scaffold and sidebars.
  ///
  /// If not provided, a default [GnrllyBttrDecoration] instance will be used.
  final GnrllyBttrDecoration? decoration;

  /// The configuration for the left sidebar.
  ///
  /// Defaults to an empty [GnrllyBttrSidebarConfig], meaning no left sidebar
  /// will be displayed.
  final GnrllyBttrSidebarConfig leftSidebar;

  /// The configuration for the right sidebar.
  ///
  /// Defaults to an empty [GnrllyBttrSidebarConfig], meaning no right sidebar
  /// will be displayed.
  final GnrllyBttrSidebarConfig rightSidebar;

  /// The main content of the scaffold.
  ///
  /// This widget represents the central area of the layout, surrounded by the
  /// sidebars (if any).
  final Widget body;

  @override
  State<GnrllyBttrScaffold> createState() => _GnrllyBttrScaffoldState();
}

/// The state class for [GnrllyBttrScaffold].
///
/// Manages the initialization, disposal, and building of the scaffold's layout,
/// including the integration of sidebars and their controllers.
class _GnrllyBttrScaffoldState extends State<GnrllyBttrScaffold> {
  /// The resolved decoration settings for the scaffold and sidebars.
  late final GnrllyBttrDecoration _decoration;

  /// The controller for managing the state of the left sidebar.
  late final GnrllyBttrSidebarController _leftController;

  /// The controller for managing the state of the right sidebar.
  late final GnrllyBttrSidebarController _rightController;

  /// The main content of the scaffold.
  late final Widget _body;

  @override
  void initState() {
    super.initState();

    _decoration = widget.decoration ?? GnrllyBttrDecoration();
    _leftController =
        widget.leftSidebar.controller ?? GnrllyBttrSidebarController();
    _rightController =
        widget.rightSidebar.controller ?? GnrllyBttrSidebarController();
    _body = widget.body;
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leftSidebar = widget.leftSidebar.children.isNotEmpty;
    final rightSidebar = widget.rightSidebar.children.isNotEmpty;

    return GnrllyBttrSidebarProvider(
      decoration: _decoration,
      child: GnrllyBttrSidebarControllerProvider(
        leftController: _leftController,
        rightController: _rightController,
        child: Material(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final mobile =
                  constraints.maxWidth <= _decoration.scaffold.mobileBreakpoint;

              return ValueListenableBuilder<SidebarMode>(
                valueListenable: _leftController.sidebarModeNotifier,
                builder: (context, leftMode, __) {
                  final leftFloating = leftMode == SidebarMode.floating;

                  return ValueListenableBuilder<SidebarMode>(
                    valueListenable: _rightController.sidebarModeNotifier,
                    builder: (context, rightMode, __) {
                      final rightFloating = rightMode == SidebarMode.floating;

                      return Stack(
                        children: <Widget>[
                          AnimatedContainer(
                            duration: _decoration.common.animationDuration,
                            curve: _decoration.common.animationCurve,
                            decoration: BoxDecoration(
                              color: _decoration.scaffold.backgroundColor,
                            ),
                            margin: EdgeInsets.only(
                              left: leftSidebar && !leftFloating && !mobile
                                  ? _decoration.sidebar[SidebarPosition.left]!
                                      .expandedWidth
                                  : 0.0,
                              right: rightSidebar && !rightFloating && !mobile
                                  ? _decoration.sidebar[SidebarPosition.right]!
                                      .expandedWidth
                                  : 0.0,
                            ),
                            padding: _decoration.scaffold.inset && !mobile
                                ? _decoration.scaffold.padding
                                : null,
                            child: ClipRRect(
                              borderRadius: mobile
                                  ? BorderRadius.zero
                                  : _decoration.scaffold.borderRadius,
                              child: _body,
                            ),
                          ),
                          if (leftSidebar)
                            GnrllyBttrSidebarPositionProvider(
                              position: SidebarPosition.left,
                              child: GnrllyBttrSidebar(
                                controller: _leftController,
                                mode: leftMode,
                                children: widget.leftSidebar.children,
                              ),
                            ),
                          if (rightSidebar)
                            GnrllyBttrSidebarPositionProvider(
                              position: SidebarPosition.right,
                              child: GnrllyBttrSidebar(
                                controller: _rightController,
                                mode: rightMode,
                                children: widget.rightSidebar.children,
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
