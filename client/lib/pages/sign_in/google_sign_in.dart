import 'dart:convert';
import 'dart:developer';

import 'package:client/constance/full_width_button.dart';
import 'package:client/pages/sign_in/sign_in_view_model.dart';
import 'package:client/routes/router.gr.dart';
import 'package:client/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../../local_database/message_schema.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../provider/unread_messages.dart';
import '../../provider/user_provider.dart';
import '../../services/google_auth_services.dart';
import 'package:http/http.dart' as http;

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({super.key});

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  AuthServices services = AuthServices(httpClient: http.Client());
  GoogleSignInAccount? account;
  void googleSignIn(BuildContext context) async {
    await GoogleSignInApi.logout();
    account = await GoogleSignInApi.login();
    if (account?.email != null) {
      // ignore: use_build_context_synchronously
      services.loginWithGoogle(
        context: context,
        email: account!.id,
      );
    }
  }

  void onSuccess(response) async {
    var decodedJson = jsonDecode(response.body);
    List<dynamic> messages = decodedJson['messages'];
    late AppDatabase database =
        Provider.of<AppDatabase>(context, listen: false);
    var user = User.fromJson(response.body);
    Provider.of<UserProvider>(context, listen: false).setUser(user);
    for (var message in messages) {
      MessageModel msgData = MessageModel(
          sender: message['senderId'],
          isread: message['isRead'],
          time: DateTime.parse(message['createdAt']),
          isme: false,
          msgtext: message['msgText']);
      Provider.of<Unread>(context, listen: false).addMessages(msgData);
      await database.into(database.messages).insert(MessagesCompanion.insert(
            senderId: msgData.sender,
            receiverId: user.username,
            content: msgData.msgtext,
            isRead: msgData.isread,
            time: msgData.time,
          ));
    }

    context.router.pushAndPopUntil(
      const HomeRoute(),
      predicate: (route) => false,
    );
  }

  void tokenValidation() async {
    var response = await services.authenticationByToken();
    switch (response.statusCode) {
      case 200:
        onSuccess(response);
        break;
      case 401:
        log(response.body);
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    tokenValidation();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => SignInViewModel(),
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(181, 1, 178, 181),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    key: const Key('googleSignIn'),
                    onPressed: () => googleSignIn(context),
                    icon: SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset(
                        'assets/google.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    label: const Text(
                      'continue with Google',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40)),
                  ),
                  FullWidthButton(text: "Use Form", onPress: () {}),
                  TextButton(
                    onPressed: () {
                      context.router.push(GoogleSignUpRoute());
                    },
                    child: const Text('Don\'t have an account? Sign Up'),
                  )
                ],
              ),
            ),
          );
        });
  }
}
