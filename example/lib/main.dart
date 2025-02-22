import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gnrllybttr_sidebar/gnrllybttr_sidebar.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GnrllyBttr Sidebar Example',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(title: 'GnrllyBttr Sidebar Example'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    required this.title,
    super.key,
  });

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _leftController = GnrllyBttrSidebarController();
  final _rightController = GnrllyBttrSidebarController();

  var fontSize = 16.0;
  var volumeLevel = 70.0;
  var themeSource = 'system';
  var agreedToTerms = false;
  var notificationsEnabled = true;
  String? _path;

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();

    super.dispose();
  }

  void _navigateToProfile() {
    debugPrint('Navigating to profile...');
  }

  void _updateMembershipDate(DateTime? date) {
    debugPrint('Updating membership date to $date...');
  }

  void _openNotifications() {
    debugPrint('Opening notifications...');
  }

  void _refreshData() {
    debugPrint('Refreshing data...');
  }

  Future<void> _selectFolder() async {
    debugPrint('Selecting folder...');

    try {
      final selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        return;
      }

      setState(() {
        _path = selectedDirectory;
      });
    } catch (e) {
      debugPrint('Error selecting folder: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GnrllyBttrScaffold(
      decoration: GnrllyBttrDecoration(
        scaffold: GnrllyBttrScaffoldDecoration(
          inset: true,
        ),
      ),
      leftSidebar: GnrllyBttrSidebarConfig(
        controller: _leftController,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
          ),
          GnrllyBttrSidebarItem.profile(
            name: 'Luffy D. Monkey',
            email: 'luffy@strawhat.world',
            avatarImage: NetworkImage(
              'https://comicbook.com/wp-content/uploads/sites/4/2023/08/d6059664-fb2e-4d86-9456-4c38ca11c60a.jpg',
            ),
            props: GnrllyBttrSidebarItemProps(
              onTap: (context) => _navigateToProfile(),
            ),
          ),
          GnrllyBttrSidebarItem.section(
            title: 'Account Settings',
          ),
          GnrllyBttrSidebarItem.calendar(
            title: 'Date',
            onDateSelected: (date) => _updateMembershipDate(date),
            icon: Icons.calendar_today,
          ),
          GnrllyBttrSidebarItem.badge(
            title: 'Notifications',
            count: 3,
            icon: Icons.notifications,
            props: GnrllyBttrSidebarItemProps(
              onTap: (context) => _openNotifications(),
            ),
          ),
          GnrllyBttrSidebarItem.progress(
            title: 'Profile Completion',
            progress: 0.75,
            icon: Icons.person_pin,
          ),
          GnrllyBttrSidebarItem.section(
            title: 'App Settings',
          ),
          GnrllyBttrSidebarItem.simple(
            title: 'Appearance',
            icon: Icons.palette,
            props: GnrllyBttrSidebarItemProps(
              alwaysExpanded: true,
              nestedItems: [
                GnrllyBttrSidebarItem.slider(
                  title: 'Font Size',
                  value: fontSize,
                  onChanged: (v) => setState(() => fontSize = v),
                  icon: Icons.text_fields,
                ),
                GnrllyBttrSidebarItem.section(
                  title: 'Theme',
                ),
                GnrllyBttrSidebarItem.radio(
                  title: 'System Default',
                  value: 'system',
                  groupValue: themeSource,
                  onChanged: (v) => setState(() => themeSource = v),
                  icon: Icons.smartphone,
                ),
                GnrllyBttrSidebarItem.radio(
                  title: 'Light Theme',
                  value: 'light',
                  groupValue: themeSource,
                  onChanged: (v) => setState(() => themeSource = v),
                  icon: Icons.light_mode,
                ),
                GnrllyBttrSidebarItem.radio(
                  title: 'Dark Theme',
                  value: 'dark',
                  groupValue: themeSource,
                  onChanged: (v) => setState(() => themeSource = v),
                  icon: Icons.dark_mode,
                ),
              ],
            ),
          ),
          GnrllyBttrSidebarItem.section(
            title: 'Preferences',
          ),
          GnrllyBttrSidebarItem.simple(
            title: 'Notifications',
            icon: Icons.notifications_active,
            props: GnrllyBttrSidebarItemProps(
              nestedItems: [
                GnrllyBttrSidebarItem.switchToggle(
                  title: 'Enable Notifications',
                  value: notificationsEnabled,
                  onChanged: (v) => setState(() => notificationsEnabled = v),
                ),
                GnrllyBttrSidebarItem.slider(
                  title: 'Volume Level',
                  value: volumeLevel,
                  onChanged: (v) => setState(() => volumeLevel = v),
                  icon: Icons.volume_up,
                ),
                GnrllyBttrSidebarItem.loading(
                  title: 'Syncing...',
                  icon: Icons.sync,
                ),
              ],
            ),
          ),
          GnrllyBttrSidebarItem.checkbox(
            title: 'I agree to terms',
            value: agreedToTerms,
            onChanged: (v) => setState(() => agreedToTerms = v),
            icon: Icons.assignment,
          ),
          GnrllyBttrSidebarItem.iconAction(
            title: 'Refresh Data',
            actionIcon: Icons.refresh,
            onAction: () => _refreshData(),
            leadingIcon: Icons.cloud_download,
          ),
        ],
      ),
      rightSidebar: GnrllyBttrSidebarConfig(
        controller: _rightController,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
          ),
          GnrllyBttrSidebarItem.section(
            title: 'Files',
            trailingBuilder: (context, expanded) {
              return IconButton(
                icon: const Icon(Icons.folder_open),
                onPressed: () => _selectFolder(),
              );
            },
          ),
          if (_path != null)
            GnrllyBttrSidebarItem.fileTree(
              path: _path!,
              onFileSelected: (string) {
                debugPrint('File selected: $string');
              },
              props: GnrllyBttrSidebarItemProps(
                initiallyExpanded: true,
                onTap: (context) {
                  debugPrint('Folder/File tapped');
                },
              ),
            ),
        ],
      ),
      body: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _leftController.toggleSidebarMode(),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            int itemsPerRow;

            if (constraints.maxWidth > 1200) {
              itemsPerRow = 4;
            } else if (constraints.maxWidth > 600) {
              itemsPerRow = 3;
            } else {
              itemsPerRow = 1;
            }

            final spacing = 8.0;
            final horizontalPadding = 16.0;
            final availableWidth = math.max(
              0,
              constraints.maxWidth - (horizontalPadding * 2),
            );
            final itemWidth = math.max(
              1.0,
              (availableWidth - (spacing * (itemsPerRow - 1))) / itemsPerRow,
            );

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: List.generate(
                    50,
                    (index) {
                      return SizedBox(
                        width: itemWidth,
                        height: itemWidth,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _rightController.toggleSidebarMode(),
          tooltip: 'Right sidebar',
          child: const Icon(Icons.folder_open),
        ),
      ),
    );
  }
}
