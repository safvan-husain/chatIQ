import 'package:client/constance/full_width_button.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:auto_route/auto_route.dart';

import '../../../data/repositories/google_auth_services.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({super.key});

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  GoogleSignInAccount? account;
  void googleSignIn(BuildContext context) async {
    await GoogleSignInApi.logout();
    account = await GoogleSignInApi.login();
    if (account?.email != null && context.mounted) {
      context.read<AuthenticationCubit>().loginWithGoogle(account!.email);
    }
  }

  void tokenValidation(BuildContext context) async {
    context.read<AuthenticationCubit>().getCachedUser();
  }

  @override
  void initState() {
    super.initState();
    tokenValidation(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state.authState == AuthState.authenticated) {
          context.router.pushAndPopUntil(
            const DefaultRoute(),
            predicate: (state) => false,
          );
        }
      },
      child: Scaffold(
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
              FullWidthButton(
                  text: "Use Form",
                  onPress: () => context.router.push(LoginFormRoute())),
              TextButton(
                onPressed: () {
                  context.router.push(const GoogleSignUpRoute());
                },
                child: const Text('Don\'t have an account? Sign Up'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
