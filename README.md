# GnrllyBttrSidebar 🗂️✨

Developed with ❤️ by

[<img src="https://github.com/GnrllyBttr/gnrllybttr.dev/raw/production/images/logo.png" width="225" alt="GnrllyBttr Logo">](https://gnrllybttr.dev/)

[![GitHub Stars](https://img.shields.io/github/stars/GnrllyBttr/GnrllyBttrSidebar.svg?logo=github)](https://github.com/GnrllyBttr/GnrllyBttrSidebar/stargazers)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/GnrllyBttr/GnrllyBttrSidebar/raw/main/LICENSE)
![Coverage](https://github.com/GnrllyBttr/GnrllyBttrSidebar/raw/main/coverage_badge.svg?sanitize=true)

[![Package](https://img.shields.io/pub/v/gnrllybttr_sidebar.svg?logo=flutter)](https://pub.dartlang.org/packages/gnrllybttr_sidebar)
[![Platform](https://img.shields.io/badge/platform-all-brightgreen.svg?logo=flutter)](https://img.shields.io/badge/platform-android%20|%20ios%20|%20linux%20|%20macos%20|%20web%20|%20windows-green.svg)
[![Likes](https://img.shields.io/pub/likes/gnrllybttr_sidebar?logo=flutter)](https://pub.dev/packages/gnrllybttr_sidebar/score)
[![Points](https://img.shields.io/pub/points/gnrllybttr_sidebar?logo=flutter)](https://pub.dev/packages/gnrllybttr_sidebar/score)

---

![Screenshot of GnrllyBttrSidebar](https://github.com/GnrllyBttr/GnrllyBttrSidebar/raw/main/showcase.png)

## 📑 Table of Contents

- [GnrllyBttrSidebar 🗂️✨](#gnrllybttrsidebar-️)
  - [📑 Table of Contents](#-table-of-contents)
  - [🌟 Features](#-features)
  - [🚀 Installation](#-installation)
  - [📚 Examples](#-examples)
    - [Basic Navigation Sidebar](#basic-navigation-sidebar)
    - [Settings Panel Sidebar](#settings-panel-sidebar)
    - [Advanced Nested Sidebar](#advanced-nested-sidebar)
    - [File Explorer Sidebar](#file-explorer-sidebar)
  - [🏁 Getting Started](#-getting-started)
  - [📖 Usage](#-usage)
    - [Creating a Scaffold with Sidebars](#creating-a-scaffold-with-sidebars)
    - [Adding Sidebar Items](#adding-sidebar-items)
    - [Customizing Sidebar Appearance](#customizing-sidebar-appearance)
    - [Managing Sidebar State](#managing-sidebar-state)
  - [🤝 Contributing](#-contributing)
  - [🆘 Support](#-support)
  - [📝 Changelog](#-changelog)
  - [📄 License](#-license)

---

## 🌟 Features

The `GnrllyBttrSidebar` package provides a highly customizable scaffold widget for Flutter applications, supporting left and right sidebars. Key features include:

- **Flexible Layout**: Add optional left and/or right sidebars to your app's main content.
- **Rich Sidebar Items**: Supports badges, calendars, checkboxes, file trees, progress bars, sliders, switches, and more.
- **Customizable Appearance**: Fine-tune the look and feel of sidebars and their items using decoration classes.
- **State Management**: Built-in controllers for managing sidebar visibility, expansion, and modes (e.g., floating or expanded).
- **Nested Items**: Easily create hierarchical sidebar structures with expandable/collapsible nested items.
- **Cross-Platform**: Works seamlessly across all Flutter-supported platforms.

---

## 🚀 Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  gnrllybttr_sidebar: ^1.0.0
```

Then run:

```shell
flutter pub get
```

---

## 📚 Examples

Here are various examples showing different ways to use GnrllyBttrSidebar:

### Basic Navigation Sidebar

```dart
GnrllyBttrScaffold(
  leftSidebar: GnrllyBttrSidebarConfig(
    controller: _leftController,
    children: <Widet>[
      GnrllyBttrSidebarItem.simple(
        title: 'Dashboard',
        icon: Icons.dashboard,
        props: GnrllyBttrSidebarItemProps(
          onTap: (context) => Navigator.pushNamed(context, '/dashboard'),
        ),
      ),
      GnrllyBttrSidebarItem.section(title: 'Management'),
      GnrllyBttrSidebarItem.simple(
        title: 'Users',
        icon: Icons.people,
        props: GnrllyBttrSidebarItemProps(
          onTap: (context) => Navigator.pushNamed(context, '/users'),
        ),
      ),
      GnrllyBttrSidebarItem.simple(
        title: 'Settings',
        icon: Icons.settings,
        props: GnrllyBttrSidebarItemProps(
          onTap: (context) => Navigator.pushNamed(context, '/settings'),
        ),
      ),
    ],
  ),
  body: YourMainContent(),
)
```

### Settings Panel Sidebar

```dart
GnrllyBttrScaffold(
  rightSidebar: GnrllyBttrSidebarConfig(
    controller: _rightController,
    children: <Widet>[
      GnrllyBttrSidebarItem.section(title: 'Appearance'),
      GnrllyBttrSidebarItem.slider(
        title: 'Font Size',
        value: fontSize,
        onChanged: (value) => setState(() => fontSize = value),
        icon: Icons.text_fields,
      ),
      GnrllyBttrSidebarItem.switchToggle(
        title: 'Dark Mode',
        value: isDarkMode,
        onChanged: (value) => setState(() => isDarkMode = value),
        icon: Icons.dark_mode,
      ),
      GnrllyBttrSidebarItem.section(title: 'Notifications'),
      GnrllyBttrSidebarItem.checkbox(
        title: 'Email Alerts',
        value: emailAlerts,
        onChanged: (value) => setState(() => emailAlerts = value),
        icon: Icons.mail,
      ),
    ],
  ),
  body: YourMainContent(),
)
```

### Advanced Nested Sidebar

```dart
GnrllyBttrScaffold(
  leftSidebar: GnrllyBttrSidebarConfig(
    controller: _leftController,
    children: <Widet>[
      GnrllyBttrSidebarItem.profile(
        name: 'Jane Doe',
        email: 'jane@example.com',
        avatarImage: NetworkImage('https://example.com/avatar.jpg'),
      ),
      GnrllyBttrSidebarItem.simple(
        title: 'Project Settings',
        icon: Icons.folder,
        props: GnrllyBttrSidebarItemProps(
          alwaysExpanded: true,
          nestedItems: <Widet>[
            GnrllyBttrSidebarItem.simple(
              title: 'General',
              icon: Icons.settings,
              props: GnrllyBttrSidebarItemProps(
                onTap: (context) => handleNavigation('general'),
              ),
            ),
            GnrllyBttrSidebarItem.badge(
              title: 'Team Members',
              count: 5,
              icon: Icons.group,
              props: GnrllyBttrSidebarItemProps(
                onTap: (context) => handleNavigation('team'),
              ),
            ),
            GnrllyBttrSidebarItem.progress(
              title: 'Storage',
              progress: 0.7,
              icon: Icons.storage,
            ),
          ],
        ),
      ),
    ],
  ),
  body: YourMainContent(),
)
```

### File Explorer Sidebar

```dart
GnrllyBttrScaffold(
  rightSidebar: GnrllyBttrSidebarConfig(
    controller: _rightController,
    children: <Widet>[
      GnrllyBttrSidebarItem.section(
        title: 'Project Files',
        trailingBuilder: (context, expanded) {
          return IconButton(
            icon: Icon(Icons.create_new_folder),
            onPressed: () => handleNewFolder(),
          );
        },
      ),
      GnrllyBttrSidebarItem.fileTree(
        path: projectPath,
        onFileSelected: (path) {
          debugPrint('Selected file: $path');
          openFile(path);
        },
        props: GnrllyBttrSidebarItemProps(
          initiallyExpanded: true,
        ),
      ),
    ],
  ),
  body: YourMainContent(),
)
```

---

## 🏁 Getting Started

To get started with `GnrllyBttrSidebar`, follow these steps:

1. **Add the Package**: Install the package via `pubspec.yaml`.
2. **Create a Scaffold**: Use the `GnrllyBttrScaffold` widget to define your app's layout.
3. **Configure Sidebars**: Customize the left and/or right sidebars using `GnrllyBttrSidebarConfig`.
4. **Add Sidebar Items**: Populate the sidebars with various types of items using factory constructors like `.profile`, `.badge`, `.fileTree`, etc.
5. **Manage State**: Use `GnrllyBttrSidebarController` to control sidebar behavior programmatically.

---

## 📖 Usage

### Creating a Scaffold with Sidebars

The `GnrllyBttrScaffold` widget is the core of this package. It allows you to
define a layout with optional left and right sidebars.

```dart
GnrllyBttrScaffold(
  leftSidebar: GnrllyBttrSidebarConfig(
    controller: _leftController,
    children: <Widget>[
      // Add sidebar items here
    ],
  ),
  rightSidebar: GnrllyBttrSidebarConfig(
    controller: _rightController,
    children: <Widget>[
      // Add sidebar items here
    ],
  ),
  body: const Center(child: Text('Main Content')),
);
```

### Adding Sidebar Items

The `GnrllyBttrSidebarItem` class provides multiple factory constructors for
creating different types of sidebar items:

- `.profile`: Displays a user profile with an avatar, name, and email.
- `.badge`: Shows a badge with a count next to the item.
- `.calendar`: Allows users to select a date.
- `.checkbox`: Adds a checkbox for toggling states.
- `.fileTree`: Displays a hierarchical file tree.
- `.progress`: Shows a progress bar.
- `.slider`: Adds a slider for adjusting values.
- `.switchToggle`: Includes a switch for enabling/disabling options.

Example:

```dart
GnrllyBttrSidebarItem.progress(
  title: 'Profile Completion',
  progress: 0.75,
  icon: Icons.person_pin,
);
```

### Customizing Sidebar Appearance

Use the `GnrllyBttrDecoration` class to customize the appearance of the scaffold
and sidebars:

```dart
GnrllyBttrDecoration(
  scaffold: GnrllyBttrScaffoldDecoration(
    backgroundColor: Colors.grey[900],
    padding: const EdgeInsets.all(16),
  ),
  sidebar: <SidebarPosition, GnrllyBttrSidebarDecoration>{
    SidebarPosition.left: GnrllyBttrSidebarDecoration(
      backgroundColor: Colors.grey[850],
      expandedWidth: 300,
    ),
    SidebarPosition.right: GnrllyBttrSidebarDecoration(
      backgroundColor: Colors.grey[850],
      expandedWidth: 250,
    ),
  },
);
```

### Managing Sidebar State

The `GnrllyBttrSidebarController` class provides methods for controlling sidebar behavior:

- `toggleSidebarMode()`: Switches between expanded and floating modes.
- `showSidebar()`: Makes the sidebar visible.
- `hideSidebar()`: Hides the sidebar.

Example:

```dart
_leftController.toggleSidebarMode();
_rightController.showSidebar();
```

---

## 🤝 Contributing

We welcome contributions! Please see our [contributing guidelines](https://github.com/GnrllyBttr/GnrllyBttrSidebar/raw/main/CONTRIBUTING.md) for more details.

---

## 🆘 Support

If you encounter any issues or have questions, please [open an issue](https://github.com/GnrllyBttr/GnrllyBttrSidebar/issues) on GitHub.

---

## 📝 Changelog

See the [changelog](https://github.com/GnrllyBttr/GnrllyBttrSidebar/raw/main/CHANGELOG.md) for updates and changes.

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/GnrllyBttr/GnrllyBttrSidebar/raw/main/LICENSE) file for details.

---

Let me know if you'd like further refinements!
