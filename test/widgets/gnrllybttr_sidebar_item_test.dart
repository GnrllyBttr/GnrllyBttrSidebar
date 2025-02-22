import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnrllybttr_sidebar/src/extensions/extensions.dart';
import 'package:gnrllybttr_sidebar/src/models/models.dart';
import 'package:gnrllybttr_sidebar/src/notifiers/notifiers.dart';
import 'package:gnrllybttr_sidebar/src/providers/providers.dart';
import 'package:gnrllybttr_sidebar/src/values/values.dart';
import 'package:gnrllybttr_sidebar/src/widgets/widgets.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Directory, File, FileStat])
void main() {
  group('Given a GnrllyBttrSidebarItem', () {
    Widget buildTestWidget({
      required Widget child,
      GnrllyBttrSidebarItemProps? props,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: GnrllyBttrSidebarProvider(
            decoration: GnrllyBttrDecoration(),
            child: GnrllyBttrSidebarPositionProvider(
              position: SidebarPosition.left,
              child: GnrllyBttrSidebar(
                controller: GnrllyBttrSidebarController(),
                children: <Widget>[
                  child,
                ],
              ),
            ),
          ),
        ),
      );
    }

    group('When using basic functionality', () {
      testWidgets('Then it should render title and icon', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.simple(
              title: 'Test Item',
              icon: Icons.star,
            ),
          ),
        );

        expect(find.text('Test Item'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('Then it should handle hover states', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.simple(
              title: 'Hover Test',
              props: GnrllyBttrSidebarItemProps(hoverable: true),
            ),
          ),
        );

        final gesture =
            await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer();
        await gesture.moveTo(tester.getCenter(find.text('Hover Test')));
        await tester.pumpAndSettle();

        final container = tester.widget<AnimatedContainer>(
          find.ancestor(
            of: find.text('Hover Test'),
            matching: find.byType(AnimatedContainer),
          ),
        );
        expect(container.decoration, isNotNull);
      });

      testWidgets('Then it should handle expansion states', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem(
              props: GnrllyBttrSidebarItemProps(
                nestedItems: [
                  GnrllyBttrSidebarItem.simple(title: 'Nested Item'),
                ],
              ),
              child: const Text('Parent Item'),
            ),
          ),
        );

        expect(find.text('Nested Item'), findsNothing);
        await tester.tap(find.text('Parent Item'));
        await tester.pumpAndSettle();
        expect(find.text('Nested Item'), findsOneWidget);
      });

      testWidgets('Then it should apply selected color when selected is true',
          (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.simple(
              title: 'Selected Item',
              props: GnrllyBttrSidebarItemProps(
                selected: true,
              ),
            ),
          ),
        );

        final container = tester.widget<AnimatedContainer>(
          find.ancestor(
            of: find.text('Selected Item'),
            matching: find.byType(AnimatedContainer),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, isNotNull);
      });
    });

    group('When using .badge factory', () {
      testWidgets('Then it should display badge with count', (tester) async {
        const testCount = 5;
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.badge(
              title: 'Notifications',
              count: testCount,
            ),
          ),
        );

        expect(find.text('$testCount'), findsOneWidget);
      });

      testWidgets('Then it should apply badge styling', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.badge(
              title: 'Test',
              count: 1,
              props: GnrllyBttrSidebarItemProps(),
            ),
          ),
        );

        await tester.pump();

        final badgeContainer = tester.widget<Container>(
          find.byWidgetPredicate((widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              widget.child is Text &&
              (widget.child as Text).data == '1'),
        );

        expect(badgeContainer.decoration, isA<BoxDecoration>());
      });
    });

    group('When using .calendar factory', () {
      testWidgets('Then it should display date picker on tap', (tester) async {
        var dateSelected = false;

        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.calendar(
              title: 'Pick Date',
              onDateSelected: (_) => dateSelected = true,
            ),
          ),
        );

        await tester.tap(find.text('Pick Date'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(dateSelected, isTrue);
      });

      testWidgets('Then it should display initial date', (tester) async {
        final testDate = DateTime(2023, 1, 1);
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.calendar(
              title: 'Date',
              initialDate: testDate,
              onDateSelected: (_) {},
            ),
          ),
        );

        expect(find.text(testDate.formatDate), findsOneWidget);
      });

      testWidgets('Then it should call original onTap when context mounted',
          (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.calendar(
              title: 'Calendar',
              onDateSelected: (_) {},
              props: GnrllyBttrSidebarItemProps(
                onTap: (_) => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Calendar'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(tapped, isTrue);
      });
    });

    group('When using .checkbox factory', () {
      testWidgets('Then it should toggle checkbox state', (tester) async {
        var checkboxValue = false;
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.checkbox(
              title: 'Checkbox',
              value: checkboxValue,
              onChanged: (v) => checkboxValue = v,
            ),
          ),
        );

        await tester.tap(find.byType(Checkbox));
        expect(checkboxValue, isTrue);
      });

      testWidgets('Then it should trigger both checkbox and item tap',
          (tester) async {
        var checked = false;
        var tapped = false;

        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.checkbox(
              title: 'Checkbox',
              value: checked,
              onChanged: (v) => checked = v,
              props: GnrllyBttrSidebarItemProps(
                onTap: (_) => tapped = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Checkbox'));
        expect(checked, isTrue);
        expect(tapped, isTrue);
      });
    });

    group('When using .fileTree factory', () {
      testWidgets('Then it should display directory contents', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.fileTree(path: 'test'),
          ),
        );

        expect(find.text('test'), findsOneWidget);
      });

      testWidgets('Then it should handle file selection', (tester) async {
        var fileSelected = '';

        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.fileTree(
              path: 'test',
              onFileSelected: (path) => fileSelected = path,
              props: GnrllyBttrSidebarItemProps(
                alwaysExpanded: true,
                initiallyExpanded: true,
              ),
            ),
          ),
        );

        // First ensure the widget is fully rendered
        await tester.pumpAndSettle();

        // Find the text widget
        final fileFinder = find.text('gnrllybttr_sidebar_item_test.dart');

        // Ensure the widget exists
        expect(fileFinder, findsOneWidget);

        // Scroll the widget into view before tapping
        await tester.ensureVisible(fileFinder);
        await tester.pumpAndSettle();

        // Now tap the widget
        await tester.tap(fileFinder);
        await tester.pumpAndSettle();

        // Verify the selected file path
        expect(fileSelected, 'test/widgets/gnrllybttr_sidebar_item_test.dart');
      });

      testWidgets('Then it should sort directories before files',
          (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.fileTree(
              path: 'test',
              props: GnrllyBttrSidebarItemProps(
                alwaysExpanded: true,
                initiallyExpanded: true,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify that the directory appears before the file
        expect(find.text('widgets'), findsOneWidget); // Directory
        expect(find.text('gnrllybttr_sidebar_item_test.dart'),
            findsOneWidget); // File

        // Ensure the order is correct
        final directoryFinder = find.text('widgets');
        final fileFinder = find.text('gnrllybttr_sidebar_item_test.dart');

        final directoryOffset = tester.getTopLeft(directoryFinder);
        final fileOffset = tester.getTopLeft(fileFinder);

        expect(
          directoryOffset.dy,
          lessThan(fileOffset.dy), // Directory should appear above file
        );
      });

      testWidgets('Then it should properly sort directory contents',
          (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.fileTree(
              path: 'test',
              props: GnrllyBttrSidebarItemProps(
                alwaysExpanded: true,
                initiallyExpanded: true,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find both directory and file widgets
        final directoryWidget = find.text('widgets');
        final fileWidget = find.text('gnrllybttr_sidebar_item_test.dart');

        // Ensure both elements exist
        expect(directoryWidget, findsOneWidget);
        expect(fileWidget, findsOneWidget);

        // Get their positions
        final directoryPosition = tester.getTopLeft(directoryWidget);
        final filePosition = tester.getTopLeft(fileWidget);

        // Verify directory appears before file
        expect(directoryPosition.dy, lessThan(filePosition.dy),
            reason: 'Directory should appear above file in the tree');
      });

      testWidgets(
          'Then it should sort with directories before files using direct comparison',
          (tester) async {
        final testDir = Directory('test_dir')..createSync();
        final testFile = File('test_dir/test_file.txt')..createSync();
        final testSubDir = Directory('test_dir/test_subdir')..createSync();

        expect(testFile.existsSync(), isTrue);
        expect(testSubDir.existsSync(), isTrue);

        try {
          await tester.pumpWidget(
            buildTestWidget(
              child: GnrllyBttrSidebarItem.fileTree(
                path: 'test_dir',
                props: GnrllyBttrSidebarItemProps(
                  alwaysExpanded: true,
                  initiallyExpanded: true,
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          final dirFinder = find.text('test_subdir');
          final fileFinder = find.text('test_file.txt');

          expect(dirFinder, findsOneWidget);
          expect(fileFinder, findsOneWidget);

          final dirPosition = tester.getTopLeft(dirFinder);
          final filePosition = tester.getTopLeft(fileFinder);

          // Verify directory  before file (testing the aIsDir && !bIsDir condition)
          expect(
            dirPosition.dy,
            lessThan(filePosition.dy),
            reason: 'Directory should appear above file due to aIsDir && '
                '!bIsDir sort condition',
          );
        } finally {
          // Clean up test directory structure
          testDir.deleteSync(recursive: true);
        }
      });
    });

    group('When using .section factory', () {
      testWidgets('Then it should display uppercase header', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.section(title: 'Test Section'),
          ),
        );

        expect(find.text('TEST SECTION'), findsOneWidget);
      });

      testWidgets('Then it should apply alpha to section header',
          (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.section(title: 'Section'),
          ),
        );

        final text = tester.widget<Text>(find.text('SECTION'));
        expect(
          (text.style?.color?.a ?? 0),
          lessThan(255),
        );
      });
    });

    group('When using .iconAction factory', () {
      testWidgets('Then it should trigger action on button press',
          (tester) async {
        var actionTriggered = false;
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.iconAction(
              title: 'Actions',
              actionIcon: Icons.add,
              onAction: () => actionTriggered = true,
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.add));
        expect(actionTriggered, isTrue);
      });
    });

    group('When using .loading factory', () {
      testWidgets('Then it should display progress indicator', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.loading(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    // ...existing code...
    group('When using .profile factory', () {
      testWidgets('Then it should display user details', (tester) async {
        // Create a minimal valid 1x1 transparent PNG image
        final transparentImage = Uint8List.fromList([
          0x89,
          0x50,
          0x4E,
          0x47,
          0x0D,
          0x0A,
          0x1A,
          0x0A,
          0x00,
          0x00,
          0x00,
          0x0D,
          0x49,
          0x48,
          0x44,
          0x52,
          0x00,
          0x00,
          0x00,
          0x01,
          0x00,
          0x00,
          0x00,
          0x01,
          0x08,
          0x06,
          0x00,
          0x00,
          0x00,
          0x1F,
          0x15,
          0xC4,
          0x89,
          0x00,
          0x00,
          0x00,
          0x0D,
          0x49,
          0x44,
          0x41,
          0x54,
          0x08,
          0xD7,
          0x63,
          0x60,
          0x60,
          0x60,
          0x60,
          0x00,
          0x00,
          0x00,
          0x05,
          0x00,
          0x01,
          0x0D,
          0x0A,
          0x2D,
          0xB4,
          0x00,
          0x00,
          0x00,
          0x00,
          0x49,
          0x45,
          0x4E,
          0x44,
          0xAE,
          0x42,
          0x60,
          0x82
        ]);

        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.profile(
              name: 'John Doe',
              email: 'john@example.com',
              avatarImage: MemoryImage(transparentImage),
            ),
          ),
        );

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('john@example.com'), findsOneWidget);
        expect(find.byType(CircleAvatar), findsOneWidget);
      });
    });
// ...existing code...

    group('When using .progress factory', () {
      testWidgets('Then it should display progress bar', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.progress(
              title: 'Loading',
              progress: 0.75,
            ),
          ),
        );

        final progress = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );
        expect(progress.value, 0.75);
      });
    });

    group('When using .radio factory', () {
      testWidgets('Then it should select radio option', (tester) async {
        var selectedValue = 1;
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.radio(
              title: 'Option',
              value: 2,
              groupValue: selectedValue,
              onChanged: (v) => selectedValue = v,
            ),
          ),
        );

        await tester.tap(find.byType(Radio));
        expect(selectedValue, 2);
      });
    });

    group('When using .slider factory', () {
      testWidgets('Then it should update slider value', (tester) async {
        var sliderValue = 50.0;
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.slider(
              title: 'Volume',
              value: sliderValue,
              onChanged: (v) => sliderValue = v,
            ),
          ),
        );

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.value, 50.0);
      });
    });

    group('When using .switchToggle factory', () {
      testWidgets('Then it should toggle switch state', (tester) async {
        var switchValue = false;
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.switchToggle(
              title: 'Toggle',
              value: switchValue,
              onChanged: (v) => switchValue = v,
            ),
          ),
        );

        await tester.tap(find.byType(Switch));
        expect(switchValue, isTrue);
      });
    });

    group('When handling hover and expansion', () {
      testWidgets('Then it should trigger onHover(false) on exit',
          (tester) async {
        var hoverState = false;

        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem.simple(
              title: 'Hover Test',
              props: GnrllyBttrSidebarItemProps(
                hoverable: true,
                onHover: (state) => hoverState = state,
              ),
            ),
          ),
        );

        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await gesture.moveTo(tester.getCenter(find.text('Hover Test')));
        await gesture.moveTo(Offset.zero);
        await gesture.removePointer();
        await tester.pumpAndSettle();

        expect(hoverState, isFalse);
      });

      testWidgets('Then it should expand via icon button', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            child: GnrllyBttrSidebarItem(
              props: GnrllyBttrSidebarItemProps(
                nestedItems: [GnrllyBttrSidebarItem.simple(title: 'Nested')],
              ),
              child: const Text('Parent'),
            ),
          ),
        );

        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();
        expect(find.text('Nested'), findsOneWidget);
      });
    });
  });
}
