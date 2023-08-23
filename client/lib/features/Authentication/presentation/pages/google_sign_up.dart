import 'package:auto_route/auto_route.dart';
import 'package:client/common/widgets/snack_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../common/widgets/custom_text_form_field.dart';
import '../../../../constance/full_width_button.dart';
import '../../../../routes/router.gr.dart';
import '../../data/repositories/google_auth_services.dart';
import '../cubit/authentication_cubit.dart';

class GoogleSignUpPage extends StatefulWidget {
  const GoogleSignUpPage({super.key});

  @override
  State<GoogleSignUpPage> createState() => _GoogleSignUpPageState();
}

class _GoogleSignUpPageState extends State<GoogleSignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  GoogleSignInAccount? account;

  void googleSignIn(BuildContext context) async {
    await GoogleSignInApi.logout();
    account = await GoogleSignInApi.login();
    if (account?.email != null) {
      _emailController.text = account!.email;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state.authState == AuthState.authenticated) {
          context.router.pushAndPopUntil(
            const HomeRoute(),
            predicate: (route) => false,
          );
          if (state.authState == AuthState.unauthenticated) {
            showSnackBar(context, 'Failed to authenticate');
          }
        }
      },
      child: Scaffold(
          body: SafeArea(
        child: _builtForm(context),
      )),
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
              "Create an Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              labelText: "Email",
              controller: _emailController,
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              labelText: "Username",
              controller: _userNameController,
            ),
            const SizedBox(height: 16.0),
            CustomTextFormField(
              labelText: "Password",
              controller: _passwordController,
            ),
            const Spacer(),
            FullWidthButton(
              text: 'Sign Up',
              onPress: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthenticationCubit>().registerUser(
                        _emailController.text,
                        _userNameController.text,
                        _passwordController.text,
                      );
                }
              },
              color: Colors.black,
            ),
            if (_emailController.text == "")
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
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  backgroundColor: Colors.black,
                ),
              ),
            TextButton(
              onPressed: () {
                context.router.push(const GoogleSignInRoute());
              },
              child: const Text(
                'Have an account? Sign In',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
