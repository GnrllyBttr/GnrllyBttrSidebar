import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnrllybttr_sidebar/src/models/models.dart';
import 'package:gnrllybttr_sidebar/src/notifiers/notifiers.dart';
import 'package:gnrllybttr_sidebar/src/providers/providers.dart';
import 'package:gnrllybttr_sidebar/src/values/values.dart';
import 'package:gnrllybttr_sidebar/src/widgets/widgets.dart';

void main() {
  group('Given a GnrllyBttrSidebar', () {
    late GnrllyBttrSidebarController controller;

    setUp(() {
      controller = GnrllyBttrSidebarController();
    });

    tearDown(() {
      controller.dispose();
    });

    Widget buildTestWidget({
      required List<Widget> children,
      SidebarMode mode = SidebarMode.expanded,
      SidebarPosition position = SidebarPosition.left,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: GnrllyBttrSidebarProvider(
            decoration: GnrllyBttrDecoration(),
            child: GnrllyBttrSidebarPositionProvider(
              position: position,
              child: GnrllyBttrSidebar(
                controller: controller,
                mode: mode,
                children: children,
              ),
            ),
          ),
        ),
      );
    }

    group('When in expanded mode', () {
      testWidgets('Then it should render children', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            children: const [
              Text('Item 1'),
              Text('Item 2'),
            ],
          ),
        );

        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
      });

      testWidgets('Then it should respect visibility state', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            children: const [Text('Content')],
          ),
        );

        // Initially visible
        expect(find.text('Content'), findsOneWidget);

        // Hide sidebar
        controller.hideSidebar();
        await tester.pumpAndSettle();

        // Should be hidden (positioned outside)
        final container = tester.widget<AnimatedPositioned>(
          find.byType(AnimatedPositioned),
        );
        expect(container.left, lessThan(0));
      });

      testWidgets('Then it should not hide on mouse exit', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            children: const [Text('Content')],
            mode: SidebarMode.expanded,
          ),
        );

        final gesture =
            await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: Offset.zero);
        await gesture.moveTo(const Offset(-10, 0));
        await tester.pumpAndSettle();

        expect(find.text('Content'), findsOneWidget);
      });
    });

    group('When in floating mode', () {
      testWidgets('Then it should show on hover', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            children: const [Text('Content')],
            mode: SidebarMode.floating,
          ),
        );

        // Initially hidden
        controller.hideSidebar();
        await tester.pumpAndSettle();

        // Hover over trigger area
        final gesture =
            await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: Offset.zero);
        await gesture.moveTo(const Offset(4, 100));
        await tester.pumpAndSettle();

        expect(controller.visibleNotifier.value, isTrue);
      });

      testWidgets('Then it should hide on mouse exit', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            children: const [Text('Content')],
            mode: SidebarMode.floating,
          ),
        );

        // Show sidebar
        controller.showSidebar();
        await tester.pumpAndSettle();

        // Move mouse out
        final gesture =
            await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: const Offset(100, 100));
        await gesture.moveTo(const Offset(-10, 100));
        await tester.pumpAndSettle();

        expect(controller.visibleNotifier.value, isFalse);
      });
    });

    group('When positioned on the right', () {
      testWidgets('Then it should align correctly', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            children: const [Text('Content')],
            position: SidebarPosition.right,
          ),
        );

        final positioned = tester.widget<AnimatedPositioned>(
          find.byType(AnimatedPositioned),
        );

        expect(positioned.left, isNull);
        expect(positioned.right, equals(0));
      });

      testWidgets('Then it should hide to the right', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            children: const [Text('Content')],
            position: SidebarPosition.right,
          ),
        );

        controller.hideSidebar();
        await tester.pumpAndSettle();

        final positioned = tester.widget<AnimatedPositioned>(
          find.byType(AnimatedPositioned),
        );
        expect(positioned.right, lessThan(0));
      });
    });

    group('When changing decoration', () {
      testWidgets('Then it should apply new styles', (tester) async {
        const backgroundColor = Colors.blue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GnrllyBttrSidebarProvider(
                decoration: GnrllyBttrDecoration(
                  sidebar: <SidebarPosition, GnrllyBttrSidebarDecoration>{
                    SidebarPosition.left: GnrllyBttrSidebarDecoration(
                      backgroundColor: backgroundColor,
                    ),
                    SidebarPosition.right: GnrllyBttrSidebarDecoration(),
                  },
                ),
                child: GnrllyBttrSidebarPositionProvider(
                  position: SidebarPosition.left,
                  child: GnrllyBttrSidebar(
                    controller: controller,
                    children: const [Text('Content')],
                  ),
                ),
              ),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(MouseRegion),
            matching: find.byType(Container),
          ),
        );

        final boxDecoration = container.decoration as BoxDecoration;
        expect(boxDecoration.color, equals(backgroundColor));
      });
    });

    group('When in mobile view', () {
      testWidgets('Then it should show close button and handle tap',
          (tester) async {
        tester.view.physicalSize = const Size(300, 600);

        await tester.pumpWidget(
          buildTestWidget(
            children: const [Text('Content')],
          ),
        );

        expect(find.byIcon(Icons.close), findsOneWidget);

        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        expect(controller.visibleNotifier.value, isFalse);

        addTearDown(() {
          tester.view.reset();
        });
      });

      testWidgets('Then it should show Spacer based on position',
          (tester) async {
        tester.view.physicalSize = const Size(300, 600);

        await tester.pumpWidget(
          buildTestWidget(
            children: const [Text('Content')],
            position: SidebarPosition.left,
          ),
        );

        expect(find.byType(Spacer), findsOneWidget);

        await tester.pumpWidget(
          buildTestWidget(
            children: const [Text('Content')],
            position: SidebarPosition.right,
          ),
        );

        expect(find.byType(Spacer), findsOneWidget);

        addTearDown(() {
          tester.view.reset();
        });
      });
    });
  });
}
