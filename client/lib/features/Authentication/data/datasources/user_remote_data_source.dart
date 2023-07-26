import 'dart:convert';

import '../../../../constance/constant_variebles.dart';
import '../../../../core/error/exception.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

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
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  UserRemoteDataSourceImpl({required super.httpClient});
  @override
  Future<UserModel> getUser(
    String emailorUsername,
    String password,
  ) async {
    final http.Response response = await httpClient.post(
      Uri.parse('$uri/auth/sign-in'),
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-auth-token': '',
      },
      body: jsonEncode({
        'emailorUsername': emailorUsername,
        'password': password,
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
      }),
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getUserWithGoogle(String email) async {
    final http.Response response = await httpClient.post(
      Uri.parse('$uri/auth/google-in'),
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8',
        'x-auth-token': '',
      },
      body: jsonEncode({
        'email': email,
      }),
    );
    if (response.statusCode == 200) {
      return UserModel.fromApiJson(response.body);
    } else {
      throw ServerException();
    }
  }
}
