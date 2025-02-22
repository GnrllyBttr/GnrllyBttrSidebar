// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:gnrllybttr_sidebar/src/notifiers/notifiers.dart';
import 'package:gnrllybttr_sidebar/src/providers/providers.dart';

void main() {
  group('Given an instance of GnrllyBttrSidebarControllerProvider', () {
    group('When created with specific controllers', () {
      final leftController = GnrllyBttrSidebarController();
      final rightController = GnrllyBttrSidebarController();
      final provider = GnrllyBttrSidebarControllerProvider(
        leftController: leftController,
        rightController: rightController,
        child: Container(),
      );

      test('Then it should hold the provided left controller', () {
        expect(provider.leftController, equals(leftController));
      });

      test('Then it should hold the provided right controller', () {
        expect(provider.rightController, equals(rightController));
      });
    });

    group('When leftOf is called with a valid context', () {
      final leftController = GnrllyBttrSidebarController();
      final rightController = GnrllyBttrSidebarController();
      final provider = GnrllyBttrSidebarControllerProvider(
        leftController: leftController,
        rightController: rightController,
        child: Container(),
      );

      testWidgets('Then it should return the provided left controller',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: provider,
          ),
        );

        final foundController = GnrllyBttrSidebarControllerProvider.leftOf(
          tester.element(find.byType(Container)),
        );
        expect(foundController, equals(leftController));
      });
    });

    group('When rightOf is called with a valid context', () {
      final leftController = GnrllyBttrSidebarController();
      final rightController = GnrllyBttrSidebarController();
      final provider = GnrllyBttrSidebarControllerProvider(
        leftController: leftController,
        rightController: rightController,
        child: Container(),
      );

      testWidgets('Then it should return the provided right controller',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: provider,
          ),
        );

        final foundController = GnrllyBttrSidebarControllerProvider.rightOf(
          tester.element(find.byType(Container)),
        );
        expect(foundController, equals(rightController));
      });
    });

    group('When leftOf is called with an invalid context', () {
      testWidgets('Then it should throw an error', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Container(),
          ),
        );

        expect(
          () {
            GnrllyBttrSidebarControllerProvider.leftOf(
              tester.element(find.byType(Container)),
            );
          },
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('When rightOf is called with an invalid context', () {
      testWidgets('Then it should throw an error', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Container(),
          ),
        );

        expect(
          () {
            GnrllyBttrSidebarControllerProvider.rightOf(
              tester.element(find.byType(Container)),
            );
          },
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('When updateShouldNotify is called', () {
      final leftController1 = GnrllyBttrSidebarController();
      final rightController1 = GnrllyBttrSidebarController();
      final leftController2 = GnrllyBttrSidebarController();
      final rightController2 = GnrllyBttrSidebarController();

      final provider1 = GnrllyBttrSidebarControllerProvider(
        leftController: leftController1,
        rightController: rightController1,
        child: Container(),
      );

      final provider2 = GnrllyBttrSidebarControllerProvider(
        leftController: leftController2,
        rightController: rightController2,
        child: Container(),
      );

      test('Then it should return true if either controller is different', () {
        expect(provider1.updateShouldNotify(provider2), isTrue);
      });

      test('Then it should return false if both controllers are the same', () {
        expect(provider1.updateShouldNotify(provider1), isFalse);
      });
    });

    group('When used in a widget tree', () {
      testWidgets('Then it should notify dependents when controllers change',
          (tester) async {
        final initialLeftController = GnrllyBttrSidebarController();
        final initialRightController = GnrllyBttrSidebarController();

        await tester.pumpWidget(
          MaterialApp(
            home: GnrllyBttrSidebarControllerProvider(
              leftController: initialLeftController,
              rightController: initialRightController,
              child: Container(),
            ),
          ),
        );

        final foundLeftController = GnrllyBttrSidebarControllerProvider.leftOf(
          tester.element(find.byType(Container)),
        );
        expect(foundLeftController, equals(initialLeftController));

        final newLeftController = GnrllyBttrSidebarController();
        final newRightController = GnrllyBttrSidebarController();

        await tester.pumpWidget(
          MaterialApp(
            home: GnrllyBttrSidebarControllerProvider(
              leftController: newLeftController,
              rightController: newRightController,
              child: Container(),
            ),
          ),
        );

        final updatedLeftController =
            GnrllyBttrSidebarControllerProvider.leftOf(
          tester.element(find.byType(Container)),
        );
        expect(updatedLeftController, equals(newLeftController));
      });
    });
  });
}
