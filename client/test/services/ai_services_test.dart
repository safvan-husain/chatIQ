import 'package:client/services/ai_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late AiService service;
  setUp(() {
    service = AiService();
  });
  testWidgets('me testing', (WidgetTester tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) {
          var actual = service.sendMessage(context: context, text: 'Hi there');
          expect(actual, Future<String>);

          // The builder function must return a widget.
          return const Placeholder();
        },
      ),
    );
  });
}
