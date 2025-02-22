// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:gnrllybttr_sidebar/src/models/models.dart';
import 'package:gnrllybttr_sidebar/src/values/values.dart';

void main() {
  group('Given an instance of GnrllyBttrDecoration', () {
    group('When created with default values', () {
      final decoration = GnrllyBttrDecoration();

      test('Then common decoration should have default values', () {
        expect(decoration.common.animationDuration, equals(const Duration(milliseconds: 300)));
        expect(decoration.common.animationCurve, equals(Curves.easeInOut));
      });

      test('Then scaffold decoration should have default values', () {
        expect(decoration.scaffold.backgroundColor, equals(const Color(0xFF18181B)));
        expect(decoration.scaffold.inset, isFalse);
        expect(decoration.scaffold.padding, equals(const EdgeInsets.all(16.0)));
        expect(decoration.scaffold.borderRadius, equals(const BorderRadius.all(Radius.circular(8.0))));
      });

      test('Then sidebar map should contain both positions', () {
        expect(decoration.sidebar.length, equals(2));
        expect(decoration.sidebar.containsKey(SidebarPosition.left), isTrue);
        expect(decoration.sidebar.containsKey(SidebarPosition.right), isTrue);
      });

      test('Then sidebarItem map should contain both positions', () {
        expect(decoration.sidebarItem.length, equals(2));
        expect(decoration.sidebarItem.containsKey(SidebarPosition.left), isTrue);
        expect(decoration.sidebarItem.containsKey(SidebarPosition.right), isTrue);
      });
    });

    group('When created with custom values', () {
      final customCommon = GnrllyBttrCommonDecoration(
        animationDuration: const Duration(milliseconds: 500),
        animationCurve: Curves.bounceIn,
      );

      final customScaffold = GnrllyBttrScaffoldDecoration(
        backgroundColor: Colors.blue,
        inset: true,
        padding: const EdgeInsets.all(24.0),
        borderRadius: BorderRadius.zero,
      );

      final customSidebar = <SidebarPosition, GnrllyBttrSidebarDecoration>{
        SidebarPosition.left: GnrllyBttrSidebarDecoration(
          backgroundColor: Colors.red,
          collapsedWidth: 80.0,
          expandedWidth: 400.0,
          padding: const EdgeInsets.all(24.0),
        ),
        SidebarPosition.right: GnrllyBttrSidebarDecoration(
          backgroundColor: Colors.green,
          collapsedWidth: 70.0,
          expandedWidth: 350.0,
          padding: const EdgeInsets.all(20.0),
        ),
      };

      final customSidebarItem = <SidebarPosition, GnrllyBttrSidebarItemDecoration>{
        SidebarPosition.left: const GnrllyBttrSidebarItemDecoration(
          badgeColor: Colors.purple,
          contentTextColor: Colors.white,
        ),
        SidebarPosition.right: const GnrllyBttrSidebarItemDecoration(
          badgeColor: Colors.orange,
          contentTextColor: Colors.black,
        ),
      };

      final decoration = GnrllyBttrDecoration(
        common: customCommon,
        scaffold: customScaffold,
        sidebar: customSidebar,
        sidebarItem: customSidebarItem,
      );

      test('Then it should hold the custom common decoration', () {
        expect(decoration.common.animationDuration, equals(const Duration(milliseconds: 500)));
        expect(decoration.common.animationCurve, equals(Curves.bounceIn));
      });

      test('Then it should hold the custom scaffold decoration', () {
        expect(decoration.scaffold.backgroundColor, equals(Colors.blue));
        expect(decoration.scaffold.inset, isTrue);
        expect(decoration.scaffold.padding, equals(const EdgeInsets.all(24.0)));
        expect(decoration.scaffold.borderRadius, equals(BorderRadius.zero));
      });

      test('Then it should hold the custom sidebar decorations', () {
        expect(decoration.sidebar[SidebarPosition.left]?.backgroundColor, equals(Colors.red));
        expect(decoration.sidebar[SidebarPosition.right]?.backgroundColor, equals(Colors.green));
      });

      test('Then it should hold the custom sidebarItem decorations', () {
        expect(decoration.sidebarItem[SidebarPosition.left]?.badgeColor, equals(Colors.purple));
        expect(decoration.sidebarItem[SidebarPosition.right]?.badgeColor, equals(Colors.orange));
      });
    });

    group('When created with invalid maps', () {
      test('Then it should throw assertion error for incomplete sidebar map', () {
        expect(
          () => GnrllyBttrDecoration(
            sidebar: const <SidebarPosition, GnrllyBttrSidebarDecoration>{
              SidebarPosition.left: GnrllyBttrSidebarDecoration(),
            },
          ),
          throwsAssertionError,
        );
      });

      test('Then it should throw assertion error for incomplete sidebarItem map', () {
        expect(
          () => GnrllyBttrDecoration(
            sidebarItem: const <SidebarPosition, GnrllyBttrSidebarItemDecoration>{
              SidebarPosition.right: GnrllyBttrSidebarItemDecoration(),
            },
          ),
          throwsAssertionError,
        );
      });
    });

    group('When used in a widget tree', () {
      testWidgets('Then it should properly apply decorations', (tester) async {
        final decoration = GnrllyBttrDecoration(
          scaffold: const GnrllyBttrScaffoldDecoration(
            backgroundColor: Colors.red,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Container(
              decoration: BoxDecoration(
                color: decoration.scaffold.backgroundColor,
              ),
            ),
          ),
        );

        final container = tester.widget<Container>(find.byType(Container));
        final boxDecoration = container.decoration as BoxDecoration;
        expect(boxDecoration.color, equals(Colors.red));
      });
    });
  });
}