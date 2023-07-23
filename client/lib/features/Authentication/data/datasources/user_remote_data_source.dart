import 'dart:convert';

import '../../../../constance/constant_variebles.dart';
import '../../../../core/error/exception.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class UserRemoteDataSource {
  http.Client httpClient;

  UserRemoteDataSource({required this.httpClient});

  ///calls the http://numberaoi.com/number endpoint
  ///
  ///throws a [serverException] for all error codes.
  Future<UserModel> getUser(
    String emailorUsername,
    String password,
  );

  ///calls the http://numberaoi.com/number endpoint
  ///
  ///throws a [serverException] for all error codes.
  Future<UserModel> getUserWithGoogle(String email);

  ///calls the http://numberaoi.com/number endpoint
  ///
  ///throws a [serverException] for all error codes.
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
  ) =>
      _getUserFromEmail(emailorUsername, password);

  @override
  Future<UserModel> registerUser(
    String email,
    String username,
    String password,
  ) =>
      _registerUser(email, username, password);

  Future<UserModel> _getUserFromEmail(
      String emailorUsername, String password) async {
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

  Future<UserModel> _registerUser(
    String email,
    String username,
    String password,
  ) async {
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
