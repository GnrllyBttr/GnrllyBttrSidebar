import 'package:flutter/material.dart';
import 'package:gnrllybttr_sidebar/src/notifiers/notifiers.dart';

/// A provider widget that supplies [GnrllyBttrSidebarController] instances for left and right sidebars.
///
/// This widget uses the [InheritedWidget] mechanism to make the controllers accessible
/// throughout the widget tree. It allows widgets to retrieve the controllers for the left
/// and right sidebars using static methods.
class GnrllyBttrSidebarControllerProvider extends InheritedWidget {
  /// Creates a [GnrllyBttrSidebarControllerProvider] with required controllers for the left and right sidebars.
  ///
  /// The [leftController] is the controller for the left sidebar.
  /// The [rightController] is the controller for the right sidebar.
  /// The [child] is the widget subtree that will have access to these controllers.
  const GnrllyBttrSidebarControllerProvider({
    required this.leftController,
    required this.rightController,
    required super.child,
    super.key,
  });

  /// The controller for managing the state and behavior of the left sidebar.
  final GnrllyBttrSidebarController leftController;

  /// The controller for managing the state and behavior of the right sidebar.
  final GnrllyBttrSidebarController rightController;

  /// Retrieves the controller for the left sidebar from the nearest ancestor provider.
  ///
  /// This method uses the [BuildContext] to locate the nearest instance of
  /// [GnrllyBttrSidebarControllerProvider] and returns its [leftController].
  static GnrllyBttrSidebarController leftOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            GnrllyBttrSidebarControllerProvider>()!
        .leftController;
  }

  /// Retrieves the controller for the right sidebar from the nearest ancestor provider.
  ///
  /// This method uses the [BuildContext] to locate the nearest instance of
  /// [GnrllyBttrSidebarControllerProvider] and returns its [rightController].
  static GnrllyBttrSidebarController rightOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
            GnrllyBttrSidebarControllerProvider>()!
        .rightController;
  }

  /// Determines whether the widget should notify dependents when updated.
  ///
  /// This method compares the current [leftController] and [rightController] with those
  /// of the [oldWidget]. If either controller has changed, dependents will be notified.
  @override
  bool updateShouldNotify(GnrllyBttrSidebarControllerProvider oldWidget) {
    return leftController != oldWidget.leftController ||
        rightController != oldWidget.rightController;
  }
}