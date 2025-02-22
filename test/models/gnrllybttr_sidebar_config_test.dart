// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:gnrllybttr_sidebar/src/models/models.dart';
import 'package:gnrllybttr_sidebar/src/notifiers/notifiers.dart';

void main() {
  group('Given an instance of GnrllyBttrSidebarConfig', () {
    group('When created with default values', () {
      final config = GnrllyBttrSidebarConfig();

      test('Then controller should be null', () {
        expect(config.controller, isNull);
      });

      test('Then children should be an empty list', () {
        expect(config.children, isEmpty);
      });

      test('Then children should be immutable', () {
        expect(config.children, isA<List<Widget>>());
        expect(() => config.children.add(Container()), throwsUnsupportedError);
      });
    });

    group('When created with specific values', () {
      final controller = GnrllyBttrSidebarController();
      final children = [
        Container(),
        Text('Test'),
        Icon(Icons.home),
      ];

      final config = GnrllyBttrSidebarConfig(
        controller: controller,
        children: children,
      );

      test('Then it should hold the provided controller', () {
        expect(config.controller, equals(controller));
      });

      test('Then it should hold the provided children', () {
        expect(config.children, equals(children));
      });

      test('Then children should be a separate list from the input', () {
        children.add(Container());
        expect(config.children.length, equals(4));
      });
    });

    group('When comparing instances', () {
      final controller1 = GnrllyBttrSidebarController();
      final controller2 = GnrllyBttrSidebarController();
      final children1 = [Container()];
      final children2 = [Text('Test')];

      test('Then identical configs should be equal', () {
        final config1 = GnrllyBttrSidebarConfig(
          controller: controller1,
          children: children1,
        );
        final config2 = GnrllyBttrSidebarConfig(
          controller: controller1,
          children: children1,
        );

        expect(config1.controller, equals(config2.controller));
        expect(config1.children, equals(config2.children));
      });

      test('Then configs with different controllers should not be equal', () {
        final config1 = GnrllyBttrSidebarConfig(
          controller: controller1,
          children: children1,
        );
        final config2 = GnrllyBttrSidebarConfig(
          controller: controller2,
          children: children1,
        );

        expect(config1.controller, isNot(equals(config2.controller)));
      });

      test('Then configs with different children should not be equal', () {
        final config1 = GnrllyBttrSidebarConfig(
          controller: controller1,
          children: children1,
        );
        final config2 = GnrllyBttrSidebarConfig(
          controller: controller1,
          children: children2,
        );

        expect(config1.children, isNot(equals(config2.children)));
      });
    });

    group('When used in a widget tree', () {
      testWidgets('Then it should properly handle widget rebuilds',
          (tester) async {
        final controller = GnrllyBttrSidebarController();
        final initialChildren = [Container()];

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final config = GnrllyBttrSidebarConfig(
                  controller: controller,
                  children: initialChildren,
                );
                return Column(children: config.children);
              },
            ),
          ),
        );

        expect(find.byType(Container), findsOneWidget);
      });
    });
  });
}
