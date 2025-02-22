import 'package:flutter/material.dart';
import 'package:gnrllybttr_sidebar/src/values/values.dart';

/// A provider widget that supplies the [SidebarPosition] for the sidebar.
///
/// This widget uses the [InheritedWidget] mechanism to make the sidebar's position
/// accessible throughout the widget tree. It allows widgets to retrieve the current
/// position of the sidebar using a static method.
class GnrllyBttrSidebarPositionProvider extends InheritedWidget {
  /// Creates a [GnrllyBttrSidebarPositionProvider] with the required sidebar position.
  ///
  /// The [position] parameter defines the position of the sidebar (e.g., left or right).
  /// The [child] is the widget subtree that will have access to this position.
  const GnrllyBttrSidebarPositionProvider({
    required this.position,
    required super.child,
    super.key,
  });

  /// The position of the sidebar.
  ///
  /// This indicates whether the sidebar is positioned on the left or right side
  /// of the screen, as defined by the [SidebarPosition] enum.
  final SidebarPosition position;

  /// Retrieves the [SidebarPosition] from the nearest ancestor provider.
  ///
  /// This method uses the [BuildContext] to locate the nearest instance of
  /// [GnrllyBttrSidebarPositionProvider] and returns its [position].
  static SidebarPosition of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            GnrllyBttrSidebarPositionProvider>()!
        .position;
  }

  /// Determines whether the widget should notify dependents when updated.
  ///
  /// This method compares the current [position] with that of the [oldWidget].
  /// If the position has changed, dependents will be notified.
  @override
  bool updateShouldNotify(GnrllyBttrSidebarPositionProvider oldWidget) {
    return position != oldWidget.position;
  }
}
