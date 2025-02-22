import 'package:flutter/material.dart';
import 'package:gnrllybttr_sidebar/src/notifiers/notifiers.dart';

/// A class that defines the configuration for the GnrllyBttrSidebar.
///
/// This class encapsulates the controller and the list of children widgets
/// that are displayed within the sidebar. It provides a way to customize
/// the behavior and content of the sidebar.
class GnrllyBttrSidebarConfig {
  /// Creates a [GnrllyBttrSidebarConfig] with customizable properties.
  ///
  /// The [controller] is an optional property that allows control over the sidebar's state,
  /// such as expanding, collapsing, or toggling the sidebar.
  /// The [children] property defines the list of widgets to be displayed inside the sidebar.
  /// By default, the [children] list is empty.
  const GnrllyBttrSidebarConfig({
    this.controller,
    this.children = const <Widget>[],
  });

  /// An optional controller that manages the state of the sidebar.
  ///
  /// This can be used to programmatically control actions like expanding,
  /// collapsing, or toggling the sidebar. If not provided, the sidebar will
  /// rely on its default behavior.
  final GnrllyBttrSidebarController? controller;

  /// The list of widgets to be displayed as the content of the sidebar.
  ///
  /// This is a required property, but it defaults to an empty list if no
  /// children are provided. These widgets represent the items or components
  /// that make up the sidebar's content.
  final List<Widget> children;
}