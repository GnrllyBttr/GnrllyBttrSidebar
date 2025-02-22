// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:gnrllybttr_sidebar/src/providers/providers.dart';
import 'package:gnrllybttr_sidebar/src/values/enums.dart';

// 🌎 Project imports:

void main() {
  group('Given an instance of GnrllyBttrSidebarPositionProvider', () {
    group('When created with a specific position', () {
      final position = SidebarPosition.left;
      final provider = GnrllyBttrSidebarPositionProvider(
        position: position,
        child: Container(),
      );

      test('Then it should hold the provided position', () {
        expect(provider.position, equals(position));
      });
    });

    group('When of is called with a valid context', () {
      final position = SidebarPosition.left;
      final provider = GnrllyBttrSidebarPositionProvider(
        position: position,
        child: Container(),
      );

      testWidgets('Then it should return the provided position',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: provider,
          ),
        );

        final foundController = GnrllyBttrSidebarPositionProvider.of(
          tester.element(find.byType(Container)),
        );
        expect(foundController, equals(position));
      });
    });

    group('When of is called with an invalid context', () {
      testWidgets('Then it should throw an assertion error', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Container(),
          ),
        );

        expect(
          () {
            GnrllyBttrSidebarPositionProvider.of(
              tester.element(find.byType(Container)),
            );
          },
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('When updateShouldNotify is called', () {
      final position1 = SidebarPosition.left;
      final position2 = SidebarPosition.right;
      final provider1 = GnrllyBttrSidebarPositionProvider(
        position: position1,
        child: Container(),
      );
      final provider2 = GnrllyBttrSidebarPositionProvider(
        position: position2,
        child: Container(),
      );

      test('Then it should return true if the controllers are different', () {
        expect(provider1.updateShouldNotify(provider2), isTrue);
      });

      test('Then it should return false if the controllers are the same', () {
        expect(provider1.updateShouldNotify(provider1), isFalse);
      });
    });

    group('When used in a widget tree', () {
      final position = SidebarPosition.left;
      final provider = GnrllyBttrSidebarPositionProvider(
        position: position,
        child: Container(),
      );

      testWidgets('Then it should notify dependents when the position changes',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: provider,
          ),
        );

        final foundPosition = GnrllyBttrSidebarPositionProvider.of(
          tester.element(find.byType(Container)),
        );
        expect(foundPosition, equals(position));

        final newPosition = SidebarPosition.right;
        final newProvider = GnrllyBttrSidebarPositionProvider(
          position: newPosition,
          child: Container(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: newProvider,
          ),
        );

        final newFoundPosition = GnrllyBttrSidebarPositionProvider.of(
          tester.element(find.byType(Container)),
        );
        expect(newFoundPosition, equals(newPosition));
      });
    });
  });
}
