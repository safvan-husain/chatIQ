import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CallObject {
  final String callerName;
  final String? iceCandidate;
  final String status;
  CallObject({
    required this.callerName,
    this.iceCandidate,
    required this.status,
  });
}
