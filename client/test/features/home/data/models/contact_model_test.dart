import 'dart:convert';

import 'package:client/features/home/data/models/contact_model.dart';
import 'package:client/features/home/domain/entities/contact.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String jsonString = json.encode({"username": "john"});
  Contact contact = Contact(username: "john");
  test(
    'contactModel should be a subtype of Contact',
    () {
      expect(ContactModel is Contact, true);
    },
  );
  test(
    'should make a contact from a json',
    () {
      var actual = ContactModel.fromJson(jsonString);
      expect(actual, contact);
    },
  );
}
