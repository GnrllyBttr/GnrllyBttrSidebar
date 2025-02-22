import 'package:flutter/material.dart';
import 'package:gnrllybttr_sidebar/src/values/values.dart';

/// A controller class for managing the state and behavior of the GnrllyBttrSidebar.
///
/// This class provides methods and notifiers to control the visibility and mode
/// of the sidebar, such as showing, hiding, toggling, and switching between modes.
class GnrllyBttrSidebarController {
  /// Creates a [GnrllyBttrSidebarController] with customizable properties.
  ///
  /// The [mode] defines the initial mode of the sidebar (e.g., expanded or floating).
  /// The [visible] determines whether the sidebar is initially visible.
  GnrllyBttrSidebarController({
    SidebarMode mode = SidebarMode.expanded,
    bool visible = true,
  })  : _initialMode = mode,
        _sidebarModeNotifier = ValueNotifier<SidebarMode>(mode),
        _visibleNotifier = ValueNotifier<bool>(visible);

  /// The initial mode of the sidebar when the controller is created.
  final SidebarMode _initialMode;

  /// A notifier that tracks the current mode of the sidebar.
  final ValueNotifier<SidebarMode> _sidebarModeNotifier;

  /// A notifier that tracks the visibility state of the sidebar.
  final ValueNotifier<bool> _visibleNotifier;

  /// A getter for the visibility notifier.
  ///
  /// This can be used to listen to changes in the sidebar's visibility state.
  ValueNotifier<bool> get visibleNotifier => _visibleNotifier;

  /// A getter for the sidebar mode notifier.
  ///
  /// This can be used to listen to changes in the sidebar's mode (e.g., expanded or floating).
  ValueNotifier<SidebarMode> get sidebarModeNotifier => _sidebarModeNotifier;

  /// Makes the sidebar visible.
  ///
  /// Updates the [_visibleNotifier] to `true`, making the sidebar appear.
  void showSidebar() {
    _visibleNotifier.value = true;
  }

  /// Hides the sidebar.
  ///
  /// Updates the [_visibleNotifier] to `false`, making the sidebar disappear.
  void hideSidebar() {
    _visibleNotifier.value = false;
  }

  /// Toggles the visibility of the sidebar.
  ///
  /// If the sidebar is currently visible, it will be hidden, and vice versa.
  void toggleSidebarVisibility() {
    _visibleNotifier.value = !_visibleNotifier.value;
  }

  /// Sets the sidebar to a specific mode.
  ///
  /// The [mode] parameter determines the new mode of the sidebar. If the mode is not
  /// [SidebarMode.floating], the sidebar will also be made visible.
  void setSidebarMode(SidebarMode mode) {
    _sidebarModeNotifier.value = mode;
    if (mode != SidebarMode.floating) {
      showSidebar();
    }
  }

  /// Toggles the sidebar mode between its current mode and floating mode.
  ///
  /// If the current mode is [SidebarMode.floating], it switches back to the initial mode.
  /// Otherwise, it switches to [SidebarMode.floating] and hides the sidebar.
  void toggleSidebarMode() {
    if (_sidebarModeNotifier.value == SidebarMode.floating) {
      _sidebarModeNotifier.value = _initialMode;
      showSidebar();
    } else {
      _sidebarModeNotifier.value = SidebarMode.floating;
      hideSidebar();
    }
  }

  /// Switches the sidebar to floating mode.
  ///
  /// Updates the sidebar mode to [SidebarMode.floating] and hides the sidebar.
  void switchToFloatingMode() {
    _sidebarModeNotifier.value = SidebarMode.floating;
    hideSidebar();
  }

  /// Switches the sidebar to expanded mode.
  ///
  /// Updates the sidebar mode to [SidebarMode.expanded] and makes the sidebar visible.
  void switchToExpandedMode() {
    _sidebarModeNotifier.value = SidebarMode.expanded;
    showSidebar();
  }

  /// Disposes of the notifiers to free up resources.
  ///
  /// This method should be called when the controller is no longer needed to prevent memory leaks.
  void dispose() {
    _sidebarModeNotifier.dispose();
    _visibleNotifier.dispose();
  }
}