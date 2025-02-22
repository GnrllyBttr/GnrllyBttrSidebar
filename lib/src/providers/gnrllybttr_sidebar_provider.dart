import 'package:flutter/material.dart';
import 'package:gnrllybttr_sidebar/src/models/models.dart';

/// A provider widget that supplies the [GnrllyBttrDecoration] configuration for the sidebar.
///
/// This widget uses the [InheritedWidget] mechanism to make the decoration configuration
/// accessible throughout the widget tree. It allows widgets to retrieve the decoration
/// settings using a static method.
class GnrllyBttrSidebarProvider extends InheritedWidget {
  /// Creates a [GnrllyBttrSidebarProvider] with the required decoration configuration.
  ///
  /// The [decoration] parameter defines the appearance and behavior settings for the sidebar.
  /// The [child] is the widget subtree that will have access to these decoration settings.
  const GnrllyBttrSidebarProvider({
    required this.decoration,
    required super.child,
    super.key,
  });

  /// The decoration configuration for the sidebar.
  ///
  /// This includes settings such as animations, scaffold appearance, sidebar styles, and item decorations.
  final GnrllyBttrDecoration decoration;

  /// Retrieves the [GnrllyBttrDecoration] from the nearest ancestor provider.
  ///
  /// This method uses the [BuildContext] to locate the nearest instance of
  /// [GnrllyBttrSidebarProvider] and returns its [decoration].
  static GnrllyBttrDecoration of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GnrllyBttrSidebarProvider>()!
        .decoration;
  }

  /// Determines whether the widget should notify dependents when updated.
  ///
  /// This method compares the current [decoration] with that of the [oldWidget].
  /// If the decoration has changed, dependents will be notified.
  @override
  bool updateShouldNotify(GnrllyBttrSidebarProvider oldWidget) {
    return decoration != oldWidget.decoration;
  }
}
