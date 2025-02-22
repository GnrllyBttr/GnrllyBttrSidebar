// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:gnrllybttr_sidebar/src/notifiers/notifiers.dart';
import 'package:gnrllybttr_sidebar/src/values/values.dart';

void main() {
  group('Given an instance of GnrllyBttrSidebarController', () {
    late GnrllyBttrSidebarController controller;

    setUp(() {
      controller = GnrllyBttrSidebarController();
    });

    group('When created with default values', () {
      tearDown(() {
        controller.dispose();
      });

      test('Then it should initialize with expanded mode', () {
        expect(
            controller.sidebarModeNotifier.value, equals(SidebarMode.expanded));
      });

      test('Then it should initialize as visible', () {
        expect(controller.visibleNotifier.value, isTrue);
      });
    });

    group('When created with custom values', () {
      setUp(() {
        controller = GnrllyBttrSidebarController(
          mode: SidebarMode.floating,
          visible: false,
        );
      });

      tearDown(() {
        controller.dispose();
      });

      test('Then it should initialize with provided mode', () {
        expect(
            controller.sidebarModeNotifier.value, equals(SidebarMode.floating));
      });

      test('Then it should initialize with provided visibility', () {
        expect(controller.visibleNotifier.value, isFalse);
      });
    });

    group('When controlling visibility', () {
      tearDown(() {
        controller.dispose();
      });

      test('Then showSidebar should make sidebar visible', () {
        controller.hideSidebar();
        controller.showSidebar();
        expect(controller.visibleNotifier.value, isTrue);
      });

      test('Then hideSidebar should hide sidebar', () {
        controller.showSidebar();
        controller.hideSidebar();
        expect(controller.visibleNotifier.value, isFalse);
      });

      test('Then toggleSidebarVisibility should toggle visibility', () {
        final initialVisibility = controller.visibleNotifier.value;
        controller.toggleSidebarVisibility();
        expect(controller.visibleNotifier.value, equals(!initialVisibility));
      });
    });

    group('When controlling sidebar mode', () {
      tearDown(() {
        controller.dispose();
      });

      test('Then setSidebarMode should update mode and visibility', () {
        controller.setSidebarMode(SidebarMode.floating);
        expect(
            controller.sidebarModeNotifier.value, equals(SidebarMode.floating));

        controller.setSidebarMode(SidebarMode.expanded);
        expect(
            controller.sidebarModeNotifier.value, equals(SidebarMode.expanded));
        expect(controller.visibleNotifier.value, isTrue);
      });

      test('Then toggleSidebarMode should switch between modes', () {
        controller.toggleSidebarMode();
        expect(
            controller.sidebarModeNotifier.value, equals(SidebarMode.floating));
        expect(controller.visibleNotifier.value, isFalse);

        controller.toggleSidebarMode();
        expect(
            controller.sidebarModeNotifier.value, equals(SidebarMode.expanded));
        expect(controller.visibleNotifier.value, isTrue);
      });

      test('Then switchToFloatingMode should set floating mode and hide', () {
        controller.switchToFloatingMode();
        expect(
            controller.sidebarModeNotifier.value, equals(SidebarMode.floating));
        expect(controller.visibleNotifier.value, isFalse);
      });

      test('Then switchToExpandedMode should set expanded mode and show', () {
        controller.switchToFloatingMode();
        controller.switchToExpandedMode();
        expect(
            controller.sidebarModeNotifier.value, equals(SidebarMode.expanded));
        expect(controller.visibleNotifier.value, isTrue);
      });
    });

    group('When used with ValueListenableBuilder', () {
      tearDown(() {
        controller.dispose();
      });

      testWidgets('Then it should rebuild on visibility changes',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ValueListenableBuilder<bool>(
              valueListenable: controller.visibleNotifier,
              builder: (context, visible, _) {
                return Text(visible ? 'Visible' : 'Hidden');
              },
            ),
          ),
        );

        expect(find.text('Visible'), findsOneWidget);

        controller.hideSidebar();
        await tester.pump();

        expect(find.text('Hidden'), findsOneWidget);
      });

      testWidgets('Then it should rebuild on mode changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ValueListenableBuilder<SidebarMode>(
              valueListenable: controller.sidebarModeNotifier,
              builder: (context, mode, _) {
                return Text(mode.toString());
              },
            ),
          ),
        );

        expect(find.text('SidebarMode.expanded'), findsOneWidget);

        controller.switchToFloatingMode();
        await tester.pump();

        expect(find.text('SidebarMode.floating'), findsOneWidget);
      });
    });

    group('When disposing', () {
      test('Then it should dispose notifiers without errors', () {
        expect(() => controller.dispose(), returnsNormally);
      });
    });
  });
}
