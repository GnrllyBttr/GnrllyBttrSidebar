/// An enumeration that defines the possible modes of the sidebar.
///
/// This enum is used to specify how the sidebar behaves and appears:
/// - [floating]: The sidebar is detached from the main content and can float above it.
/// - [expanded]: The sidebar is integrated into the layout and expands to occupy space.
enum SidebarMode {
  floating,
  expanded,
}

/// An enumeration that defines the possible positions of the sidebar.
///
/// This enum is used to specify where the sidebar is located relative to the screen:
/// - [left]: The sidebar is positioned on the left side of the screen.
/// - [right]: The sidebar is positioned on the right side of the screen.
enum SidebarPosition {
  left,
  right,
}

/// An enumeration that defines the possible types of the sidebar.
///
/// This enum is used to specify the visual and functional style of the sidebar:
/// - [simple]: A basic sidebar with no special effects or overlays.
/// - [inset]: The sidebar is inset into the main content, creating a seamless integration.
/// - [overlay]: The sidebar overlays the main content, appearing above it.
enum SidebarType {
  simple,
  inset,
  overlay,
}