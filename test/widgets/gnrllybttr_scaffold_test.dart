import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnrllybttr_sidebar/src/models/models.dart';
import 'package:gnrllybttr_sidebar/src/notifiers/notifiers.dart';
import 'package:gnrllybttr_sidebar/src/values/values.dart';
import 'package:gnrllybttr_sidebar/src/widgets/widgets.dart';

void main() {
  group('Given a GnrllyBttrScaffold', () {
    late GnrllyBttrSidebarController leftController;
    late GnrllyBttrSidebarController rightController;

    setUp(() {
      leftController = GnrllyBttrSidebarController();
      rightController = GnrllyBttrSidebarController();
    });

    Widget buildTestWidget({
      Widget? body,
      GnrllyBttrDecoration? decoration,
      GnrllyBttrSidebarConfig? leftSidebar,
      GnrllyBttrSidebarConfig? rightSidebar,
    }) {
      return MaterialApp(
        home: GnrllyBttrScaffold(
          body: body ?? const SizedBox(),
          decoration: decoration,
          leftSidebar: leftSidebar ?? const GnrllyBttrSidebarConfig(),
          rightSidebar: rightSidebar ?? const GnrllyBttrSidebarConfig(),
        ),
      );
    }

    group('When initializing', () {
      testWidgets('Then it should render body content', (tester) async {
        const bodyText = 'Main Content';

        await tester.pumpWidget(
          buildTestWidget(
            body: const Text(bodyText),
          ),
        );

        expect(find.text(bodyText), findsOneWidget);
      });

      testWidgets('Then it should use default decoration if none provided',
          (tester) async {
        await tester.pumpWidget(buildTestWidget());

        final scaffold = tester.widget<GnrllyBttrScaffold>(
          find.byType(GnrllyBttrScaffold),
        );
        expect(scaffold.decoration, isNull);
      });
    });

    group('When using left sidebar', () {
      testWidgets('Then it should render sidebar content', (tester) async {
        const sidebarText = 'Left Sidebar';

        await tester.pumpWidget(
          buildTestWidget(
            leftSidebar: GnrllyBttrSidebarConfig(
              controller: leftController,
              children: const [
                Text(sidebarText),
              ],
            ),
          ),
        );

        expect(find.text(sidebarText), findsOneWidget);
      });

      testWidgets('Then it should handle sidebar mode changes', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            leftSidebar: GnrllyBttrSidebarConfig(
              controller: leftController,
              children: const [Text('Sidebar')],
            ),
          ),
        );

        // Initially expanded
        expect(leftController.sidebarModeNotifier.value,
            equals(SidebarMode.expanded));

        // Switch to floating
        leftController.switchToFloatingMode();
        await tester.pumpAndSettle();

        expect(leftController.sidebarModeNotifier.value,
            equals(SidebarMode.floating));
      });
    });

    group('When using right sidebar', () {
      testWidgets('Then it should render sidebar content', (tester) async {
        const sidebarText = 'Right Sidebar';

        await tester.pumpWidget(
          buildTestWidget(
            rightSidebar: GnrllyBttrSidebarConfig(
              controller: rightController,
              children: const [Text(sidebarText)],
            ),
          ),
        );

        expect(find.text(sidebarText), findsOneWidget);
      });

      testWidgets('Then it should handle visibility changes', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            rightSidebar: GnrllyBttrSidebarConfig(
              controller: rightController,
              children: const [Text('Sidebar')],
            ),
          ),
        );

        // Initially visible
        expect(rightController.visibleNotifier.value, isTrue);

        // Hide sidebar
        rightController.hideSidebar();
        await tester.pumpAndSettle();

        expect(rightController.visibleNotifier.value, isFalse);
      });
    });

    group('When using custom decoration', () {
      testWidgets('Then it should apply custom colors', (tester) async {
        const backgroundColor = Colors.blue;

        await tester.pumpWidget(
          buildTestWidget(
            decoration: GnrllyBttrDecoration(
              scaffold: GnrllyBttrScaffoldDecoration(
                backgroundColor: backgroundColor,
              ),
            ),
          ),
        );

        final container = tester.widget<AnimatedContainer>(
          find.descendant(
            of: find.byType(Stack),
            matching: find.byType(AnimatedContainer),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, equals(backgroundColor));
      });

      testWidgets('Then it should apply custom padding when inset',
          (tester) async {
        const padding = EdgeInsets.all(16.0);

        await tester.pumpWidget(
          buildTestWidget(
            decoration: GnrllyBttrDecoration(
              scaffold: GnrllyBttrScaffoldDecoration(
                padding: padding,
                inset: true,
              ),
            ),
          ),
        );

        final container = tester.widget<AnimatedContainer>(
          find.descendant(
            of: find.byType(Stack),
            matching: find.byType(AnimatedContainer),
          ),
        );

        expect(container.padding, equals(padding));
      });
    });
  });
}
