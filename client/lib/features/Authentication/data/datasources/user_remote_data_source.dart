import 'dart:convert';
import 'dart:developer';

import 'package:client/constance/color_log.dart';
import 'package:client/features/Authentication/data/models/remote_message_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../constance/constant_variebles.dart';
import '../../../../core/error/exception.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

abstract class UserRemoteDataSource {
  http.Client httpClient;

  UserRemoteDataSource({required this.httpClient});

  ///Attention! Prepare to make contact with http://server.com/auth/sign-in !
  ///
  ///But be warned! The sly [serverException] could be thrown!
  Future<UserModel> getUser(
    String emailorUsername,
    String password,
  );

  ///Attention! Prepare to make contact with http://server.com/auth/google-in !
  ///
  ///But be warned! The sly [serverException] could be thrown!
  Future<UserModel> getUserWithGoogle(String email);

  ///Attention! Prepare to make contact with http://server.com/auth/sign-up !
  ///
  ///But be warned! The sly [serverException] could be thrown!
  Future<UserModel> registerUser(
    String email,
    String username,
    String password,
  );
  Future<List<RemoteMesseageModel>> getUnredChats(String authtoken);
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  UserRemoteDataSourceImpl({required super.httpClient});
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<UserModel> getUser(
    String emailorUsername,
    String password,
  ) async {
    String? token;
    if (!kIsWeb) {
      token = await _firebaseMessaging.getToken();
    }

    final http.Response response = await httpClient.post(
      Uri.parse('$uri/auth/sign-in'),
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-auth-token': '',
      },
      body: jsonEncode({
        'emailorUsername': emailorUsername,
        'password': password,
        'apptoken': token
      }),
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> registerUser(
      String email, String username, String password) async {
    String? token;
    if (!kIsWeb) {
      token = await _firebaseMessaging.getToken();
    }
    final http.Response response = await httpClient.post(
      Uri.parse('$uri/auth/sign-up'),
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-auth-token': '',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'apptoken': token,
      }),
    );
    if (response.statusCode == 200) {
      return UserModel.fromApiJson(response.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getUserWithGoogle(String email) async {
    String? token;
    if (!kIsWeb) {
      token = await _firebaseMessaging.getToken();
      log("token: $token");
    }
    final http.Response response = await httpClient.post(
      Uri.parse('$uri/auth/google-in'),
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-auth-token': '',
      },
      body: jsonEncode({
        'email': email,
        'apptoken': token,
      }),
    );
    if (response.statusCode == 200) {
      return UserModel.fromApiJson(response.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<RemoteMesseageModel>> getUnredChats(authtoken) async {
    final http.Response response = await httpClient.get(
      Uri.parse('$uri/message'),
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-auth-token': authtoken,
      },
    );
    if (response.statusCode == 200) {
      List<RemoteMesseageModel> remoteMesse = [];
      for (var i in jsonDecode(response.body) as List) {
        remoteMesse.add(RemoteMesseageModel.fromMap(i));
      }
      return remoteMesse;
    } else {
      log(response.statusCode.toString());
      throw ServerException();
    }
  }
}
