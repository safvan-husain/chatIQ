import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

bool httpErrorHandler({
  required BuildContext context,
  required http.Response response,
  required VoidCallback onSuccess,
}) {
  log(response.statusCode.toString());
  switch (response.statusCode) {
    case 200:
      onSuccess();
      return true;
    case 401:
      log(response.body);
      return false;
    default:
      return false;
  }
}
