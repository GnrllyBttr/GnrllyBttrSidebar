import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gnrllybttr_sidebar/src/extensions/extensions.dart';
import 'package:gnrllybttr_sidebar/src/models/models.dart';

/// A widget that represents an item in the [GnrllyBttrSidebar].
///
/// This widget provides a customizable sidebar item with various factory constructors
/// to create different types of items, such as badges, calendars, checkboxes, file trees,
/// sections, icons with actions, loading indicators, profiles, progress bars, radio buttons,
/// simple text items, sliders, and switches.
class GnrllyBttrSidebarItem extends StatefulWidget {
  /// Creates a [GnrllyBttrSidebarItem] with customizable properties.
  ///
  /// The [props] define the behavior and appearance of the sidebar item.
  /// The [child] is the widget displayed as the content of the sidebar item.
  const GnrllyBttrSidebarItem({
    required this.props,
    required this.child,
    super.key,
  });

  /// Creates a sidebar item with a badge.
  ///
  /// The [title] is the main text of the item.
  /// The [count] is the number displayed in the badge.
  /// The [icon] is an optional icon displayed next to the title.
  /// The [props] define additional properties for the item.
  factory GnrllyBttrSidebarItem.badge({
    required String title,
    required int count,
    IconData? icon,
    GnrllyBttrSidebarItemProps props = const GnrllyBttrSidebarItemProps(),
  }) {
    return GnrllyBttrSidebarItem(
      props: props,
      child: _SidebarRowContent(
        title: title,
        icon: icon,
        trailing: Builder(builder: (context) {
          final decoration =
              context.decoration.sidebarItem[context.sidebarPosition]!;

          return Container(
            padding: decoration.badgePadding,
            decoration: BoxDecoration(
              color: decoration.badgeColor,
              shape: decoration.badgeShape,
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: decoration.badgeTextColor,
                fontSize: decoration.badgeFontSize,
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Creates a sidebar item with a calendar date picker.
  ///
  /// The [title] is the main text of the item.
  /// The [onDateSelected] callback is triggered when a date is selected.
  /// The [icon] is an optional icon displayed next to the title.
  /// The [initialDate], [firstDate], and [lastDate] define the date picker's range.
  /// The [props] define additional properties for the item.
  factory GnrllyBttrSidebarItem.calendar({
    required String title,
    required ValueChanged<DateTime?> onDateSelected,
    IconData? icon,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    GnrllyBttrSidebarItemProps props = const GnrllyBttrSidebarItemProps(),
  }) {
    final date = initialDate ?? DateTime.now();
    final onTap = props.onTap;

    return GnrllyBttrSidebarItem(
      props: props.copyWith(
        onTap: (context) async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: firstDate ?? DateTime(2000),
            lastDate: lastDate ?? DateTime(2100),
          );

          onDateSelected(selectedDate);

          if (context.mounted) {
            onTap?.call(context);
          }
        },
        trailingBuilder: (context, _) {
          final decoration =
              context.decoration.sidebarItem[context.sidebarPosition]!;

          return Text(
            date.formatDate,
            style: TextStyle(
              color: decoration.contentTextColor,
            ),
          );
        },
      ),
      child: _SidebarRowContent(
        title: title,
        icon: icon,
      ),
    );
  }

  /// Creates a sidebar item with a checkbox.
  ///
  /// The [title] is the main text of the item.
  /// The [value] defines the current state of the checkbox.
  /// The [onChanged] callback is triggered when the checkbox state changes.
  /// The [icon] is an optional icon displayed next to the title.
  /// The [props] define additional properties for the item.
  factory GnrllyBttrSidebarItem.checkbox({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    IconData? icon,
    GnrllyBttrSidebarItemProps props = const GnrllyBttrSidebarItemProps(),
  }) {
    final onTap = props.onTap;

    return GnrllyBttrSidebarItem(
      props: props.copyWith(
        onTap: (context) {
          onChanged(!value);
          onTap?.call(context);
        },
      ),
      child: _SidebarRowContent(
        title: title,
        icon: icon,
        trailing: Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
        ),
      ),
    );
  }

  /// Creates a sidebar item representing a file tree.
  ///
  /// The [path] is the directory path.
  /// The [onFileSelected] callback is triggered when a file is selected.
  /// The [props] define additional properties for the item.
  factory GnrllyBttrSidebarItem.fileTree({
    required String path,
    ValueChanged<String>? onFileSelected,
    GnrllyBttrSidebarItemProps props = const GnrllyBttrSidebarItemProps(),
  }) {
    final fileInfo = Directory(path).statSync();
    final isDirectory = fileInfo.type == FileSystemEntityType.directory;
    final name = path.split(Platform.pathSeparator).last;

    if (!isDirectory) {
      return GnrllyBttrSidebarItem.simple(
        title: name,
        icon: name.fileIcon,
        props: props.copyWith(
          onTap: (context) {
            props.onTap?.call(context);
            onFileSelected?.call(path);
          },
        ),
      );
    }

    final contents = Directory(path).listSync()
      ..sort((a, b) {
        final aIsDir = a is Directory;
        final bIsDir = b is Directory;

        if (aIsDir && !bIsDir) return -1;
        if (!aIsDir && bIsDir) return 1;

        return a.path.compareTo(b.path);
      });

    final childItems = contents.map((entity) {
      return GnrllyBttrSidebarItem.fileTree(
        path: entity.path,
        onFileSelected: onFileSelected,
        props: props.copyWith(
          level: props.level + 1,
        ),
      );
    }).toList();

    return GnrllyBttrSidebarItem(
      props: props.copyWith(
        initiallyExpanded: false,
        nestedItems: childItems,
      ),
      child: _SidebarRowContent(
        title: name,
        icon: Icons.folder,
      ),
    );
  }

  /// Creates a sidebar item representing a section header.
  ///
  /// The [title] is the text displayed as the section header.
  /// The [trailingBuilder] allows customization of the trailing widget.
  factory GnrllyBttrSidebarItem.section({
    required String title,
    Widget Function(BuildContext, bool)? trailingBuilder,
  }) {
    return GnrllyBttrSidebarItem(
      props: GnrllyBttrSidebarItemProps(
        hoverable: false,
        trailingBuilder: trailingBuilder,
      ),
      child: Builder(
        builder: (context) {
          final decoration =
              context.decoration.sidebarItem[context.sidebarPosition]!;

          return Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: decoration.contentTextColor.withValues(alpha: 0.8),
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Creates a sidebar item with an icon action button.
  ///
  /// The [title] is the main text of the item.
  /// The [actionIcon] is the icon displayed in the action button.
  /// The [onAction] callback is triggered when the action button is pressed.
  /// The [leadingIcon] is an optional icon displayed next to the title.
  /// The [props] define additional properties for the item.
  factory GnrllyBttrSidebarItem.iconAction({
    required String title,
    required IconData actionIcon,
    required VoidCallback onAction,
    IconData? leadingIcon,
    GnrllyBttrSidebarItemProps props = const GnrllyBttrSidebarItemProps(),
  }) {
    return GnrllyBttrSidebarItem(
      props: props,
      child: _SidebarRowContent(
        title: title,
        icon: leadingIcon,
        trailing: IconButton(
          icon: Icon(actionIcon),
          onPressed: onAction,
        ),
      ),
    );
  }

  /// Creates a sidebar item with a loading indicator.
  ///
  /// The [title] is the main text of the item.
  /// The [icon] is an optional icon displayed next to the title.
  /// The [props] define additional properties for the item.
  factory GnrllyBttrSidebarItem.loading({
    String? title,
    IconData? icon,
    GnrllyBttrSidebarItemProps props = const GnrllyBttrSidebarItemProps(),
  }) {
    return GnrllyBttrSidebarItem(
      props: props,
      child: _SidebarRowContent(
        title: title ?? 'Loading...',
        icon: icon ?? Icons.hourglass_empty,
        trailing: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  /// Creates a sidebar item representing a user profile.
  ///
  /// The [name] is the user's name.
  /// The [email] is the user's email address.
  /// The [avatarImage] is the image provider for the user's avatar.
  /// The [props] define additional properties for the item.
  factory GnrllyBttrSidebarItem.profile({
    required String name,
    required String email,
    required ImageProvider avatarImage,
    GnrllyBttrSidebarItemProps props = const GnrllyBttrSidebarItemProps(),
  }) {
    return GnrllyBttrSidebarItem(
      props: props,
      child: Builder(
        builder: (context) {
          final decoration =
              context.decoration.sidebarItem[context.sidebarPosition]!;

          return Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: avatarImage,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: decoration.contentTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        color: decoration.contentTextColor.withValues(
                          alpha: 0.8,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Creates a sidebar item with a progress bar.
  ///
  /// The [title] is the main text of the item.
  /// The [progress] is the current progress value (between 0.0 and 1.0).
  /// The [icon] is an optional icon displayed next to the title.
  /// The [props] define additional properties for the item.
  factory GnrllyBttrSidebarItem.progress({
    required String title,
    required double progress,
    IconData? icon,
    GnrllyBttrSidebarItemProps props = const GnrllyBttrSidebarItemProps(),
  }) {
    return GnrllyBttrSidebarItem(
      props: props,
      child: _SidebarRowContent(
        title: title,
        icon: icon,
        trailing: SizedBox(
          width: 80,
          child: Builder(builder: (context) {
            final decoration =
                context.decoration.sidebarItem[context.sidebarPosition]!;

            return LinearProgressIndicator(
              value: progress,
              backgroundColor: decoration.progressBackgroundColor,
              valueColor: AlwaysStoppedAnimation(
                decoration.progressColor,
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Creates a sidebar item with a radio button.
  ///
  /// The [title] is the main text of the item.
  /// The [value] is the value of the radio button.
  /// The [groupValue] is the currently selected value in the group.
  /// The [onChanged] callback is triggered when the radio button is selected.
  /// The [icon] is an optional icon displayed next to the title.
  /// The [props] define additional properties for the item.
  factory GnrllyBttrSidebarItem.radio({
    required String title,
    required dynamic value,
    required dynamic groupValue,
    required ValueChanged<dynamic> onChanged,
    IconData? icon,
    GnrllyBttrSidebarItemProps props = const GnrllyBttrSidebarItemProps(),
  }) {
    return GnrllyBttrSidebarItem(
      props: props,
      child: _SidebarRowContent(
        title: title,
        icon: icon,
        trailing: Radio(
          value: value,
          groupValue: groupValue,
          onChanged: (v) => onChanged(v),
        ),
      ),
    );
  }

  /// Creates a simple sidebar item with text and an optional icon.
  ///
  /// The [title] is the main text of the item.
  /// The [icon] is an optional icon displayed next to the title.
  /// The [props] define additional properties for the item.
  factory GnrllyBttrSidebarItem.simple({
    required String title,
    IconData? icon,
    GnrllyBttrSidebarItemProps props = const GnrllyBttrSidebarItemProps(),
  }) {
    return GnrllyBttrSidebarItem(
      props: props,
      child: _SidebarRowContent(
        title: title,
        icon: icon,
      ),
    );
  }

  /// Creates a sidebar item with a slider.
  ///
  /// The [title] is the main text of the item.
  /// The [value] is the current value of the slider.
  /// The [onChanged] callback is triggered when the slider value changes.
  /// The [icon] is an optional icon displayed next to the title.
  /// The [props] define additional properties for the item.
  factory GnrllyBttrSidebarItem.slider({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
    IconData? icon,
    GnrllyBttrSidebarItemProps props = const GnrllyBttrSidebarItemProps(),
  }) {
    return GnrllyBttrSidebarItem(
      props: props,
      child: _SidebarRowContent(
        title: title,
        icon: icon,
        trailing: SizedBox(
          width: 100,
          child: Slider(
            value: value,
            onChanged: onChanged,
            min: 0,
            max: 100,
          ),
        ),
      ),
    );
  }

  /// Creates a sidebar item with a switch toggle.
  ///
  /// The [title] is the main text of the item.
  /// The [value] is the current state of the switch.
  /// The [onChanged] callback is triggered when the switch state changes.
  /// The [icon] is an optional icon displayed next to the title.
  /// The [props] define additional properties for the item.
  factory GnrllyBttrSidebarItem.switchToggle({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    IconData? icon,
    GnrllyBttrSidebarItemProps props = const GnrllyBttrSidebarItemProps(),
  }) {
    return GnrllyBttrSidebarItem(
      props: props,
      child: _SidebarRowContent(
        title: title,
        icon: icon,
        trailing: Switch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// The properties defining the behavior and appearance of the sidebar item.
  final GnrllyBttrSidebarItemProps props;

  /// The widget displayed as the content of the sidebar item.
  final Widget child;

  @override
  State<GnrllyBttrSidebarItem> createState() => _GnrllyBttrSidebarItemState();
}

/// The state class for [GnrllyBttrSidebarItem].
///
/// Manages the hover and expansion states of the sidebar item.
class _GnrllyBttrSidebarItemState extends State<GnrllyBttrSidebarItem> {
  /// A notifier for tracking the hover state of the item.
  final _hoverNotifier = ValueNotifier<bool>(false);

  /// A notifier for tracking the expansion state of the item.
  final _expandedNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _expandedNotifier.value = _props.initiallyExpanded || _props.alwaysExpanded;
  }

  @override
  void dispose() {
    _hoverNotifier.dispose();
    _expandedNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nestedItems = _props.nestedItems;
    final common = context.decoration.common;
    final decoration = context.decoration.sidebarItem[context.sidebarPosition]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ValueListenableBuilder<bool>(
          valueListenable: _hoverNotifier,
          builder: (context, hovered, child) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) {
                _hoverNotifier.value = true;
                _props.onHover?.call(true);
              },
              onExit: (_) {
                _hoverNotifier.value = false;
                _props.onHover?.call(false);
              },
              child: GestureDetector(
                onTap: () {
                  _props.onTap?.call(context);

                  if (nestedItems.isNotEmpty && !_props.alwaysExpanded) {
                    _expandedNotifier.value = !_expandedNotifier.value;
                  }
                },
                child: AnimatedContainer(
                  duration: common.animationDuration,
                  curve: common.animationCurve,
                  decoration: BoxDecoration(
                    color: _props.selected
                        ? decoration.itemSelectedColor
                        : hovered && _props.hoverable
                            ? decoration.itemHoverColor
                            : null,
                    borderRadius: decoration.itemBorderRadius,
                  ),
                  padding: decoration.itemPadding,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: widget.child,
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: _expandedNotifier,
                        builder: (context, expanded, _) {
                          if (_props.trailingBuilder != null) {
                            return _props.trailingBuilder!(
                              context,
                              expanded,
                            );
                          }

                          if (nestedItems.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return IconButton(
                            icon: Icon(
                              expanded
                                  ? decoration.contentExpandedIcon
                                  : decoration.contentCollapsedIcon,
                              color: decoration.contentIconColor,
                            ),
                            onPressed: () {
                              _expandedNotifier.value = !expanded;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        if (nestedItems.isNotEmpty)
          ValueListenableBuilder<bool>(
            valueListenable: _expandedNotifier,
            builder: (context, expanded, child) {
              if (!expanded) return const SizedBox.shrink();

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (decoration.branchVisible && nestedItems.isNotEmpty)
                      Container(
                        width: decoration.branchWidth,
                        margin: decoration.branchMargin,
                        color: decoration.branchColor,
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left:
                              decoration.nestedItemIndentFactor * _props.level,
                        ),
                        child: Column(
                          children: nestedItems,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  /// Retrieves the properties of the sidebar item.
  GnrllyBttrSidebarItemProps get _props => widget.props;
}

/// A helper widget for displaying the content of a sidebar item.
class _SidebarRowContent extends StatelessWidget {
  /// Creates a [_SidebarRowContent] with customizable properties.
  ///
  /// The [title] is the main text of the content.
  /// The [icon] is an optional icon displayed next to the title.
  /// The [trailing] is an optional widget displayed at the end of the row.
  const _SidebarRowContent({
    required this.title,
    this.icon,
    this.trailing,
  });

  /// The main text of the content.
  final String title;

  /// An optional icon displayed next to the title.
  final IconData? icon;

  /// An optional widget displayed at the end of the row.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final decoration = context.decoration.sidebarItem[context.sidebarPosition]!;

    return Row(
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, color: decoration.contentIconColor),
          const SizedBox(width: 16.0),
        ],
        Expanded(
          child: Text(
            title,
            style: TextStyle(color: decoration.contentTextColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: 16.0),
          trailing!,
        ],
      ],
    );
  }
}
