// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:client/features/home/data/models/message_model.dart';
import 'package:http/http.dart' as http;

import 'package:client/core/error/exception.dart';
import 'package:client/features/home/data/models/user_model.dart';

import '../../../../constance/constant_variebles.dart';
import '../../domain/entities/user.dart';

abstract class HomeRemoteDataSource {
  final http.Client client;
  HomeRemoteDataSource({
    required this.client,
  });
  Future<List<User>> getUnreadChats({required String token});
}

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  // final http.Client client;

  HomeRemoteDataSourceImpl({required super.client});
  @override
  Future<List<User>> getUnreadChats({required String token}) async {
    http.Response response = await client.get(
      Uri.parse('$uri/get-data/all-user'),
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-auth-token': token,
      },
    );
    if (response.statusCode == 200) {
      List<User> chats = [];
      List<dynamic> decodedUsers = jsonDecode(response.body);
      for (int i = 0; i < decodedUsers.length; i++) {
        chats.add(UserModel.fromMap(decodedUsers[i]));
      }

      return chats;
    } else {
      log("${response.statusCode} from home remote ");
      throw ServerException();
    }
  }
}
