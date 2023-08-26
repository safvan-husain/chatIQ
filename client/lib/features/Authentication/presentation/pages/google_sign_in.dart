import 'package:client/common/widgets/custom_text_form_field.dart';
import 'package:client/common/widgets/full_width_button.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:auto_route/auto_route.dart';

import '../../../../common/widgets/snack_bar.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../../data/repositories/google_auth_services.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({super.key});

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GoogleSignInAccount? account;

  void googleSignIn(BuildContext context) async {
    await GoogleSignInApi.logout();
    account = await GoogleSignInApi.login();
    if (account?.email != null && context.mounted) {
      context.read<AuthenticationCubit>().loginWithGoogle(account!.email);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state.authState == AuthState.authenticated) {
          context.router.pushAndPopUntil(
            const HomeRoute(),
            predicate: (state) => false,
          );
        } else if (state.authState == AuthState.unauthenticated) {
          showSnackBar(context, 'Authentication Failed!');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: _builtForm(context)),
      ),
    );
  }

  _builtForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const Text(
              "Welcome Back you've been missed!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              labelText: "Email or Username",
              controller: _emailController,
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              labelText: "Passsword",
              controller: _passwordController,
            ),
            const Spacer(),
            FullWidthButton(
              text: 'Sign In',
              onPress: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthenticationCubit>().getUser(
                        _emailController.text,
                        _passwordController.text,
                        () => context.read<HomeCubit>().getChats(() =>
                            showSnackBar(
                                context, "Failed to get recent chats!!")),
                      );
                }
              },
              color: Colors.black,
            ),
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
              label: const FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'continue with Google',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                backgroundColor: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {
                context.router.push(GoogleSignUpRoute());
              },
              child: const Text(
                'Don\'t have an account? Sign Up',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
