import 'package:client/pages/sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget testableWidget(Widget widget) {
  return MaterialApp(home: widget);
}

void main() {
  var page = GoogleSignInPage();
  testWidgets('google sign in ...', (tester) async {
    // TODO: Implement test
  });
}
