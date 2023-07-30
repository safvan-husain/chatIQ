import 'dart:convert';

import 'package:client/features/video_call/domain/entities/call_object.dart';

class CallObjectModel extends CallObject {
  CallObjectModel({
    required super.callerName,
    required super.status,
    super.iceCandidate,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callerName': callerName,
      'iceCandidate': iceCandidate,
      'status': status,
    };
  }

  factory CallObjectModel.fromMap(Map<String, dynamic> map) {
    return CallObjectModel(
      callerName: map['callerName'] as String,
      iceCandidate:
          map['iceCandidate'] != null ? map['iceCandidate'] as String : null,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CallObjectModel.fromJson(String source) =>
      CallObjectModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
