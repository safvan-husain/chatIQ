import 'package:auto_route/auto_route.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../routes/router.gr.dart';

class GoogleSignUpSetupPage extends StatelessWidget {
  final GoogleSignInAccount account;
  GoogleSignUpSetupPage({required this.account, super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ConfirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state.authState == AuthState.authenticated) {
          context.router.pushAndPopUntil(
            const DefaultRoute(),
            predicate: (route) => false,
          );
          if (state.authState == AuthState.unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unauthenticated.'),
              ),
            );
          }
        }
      },
      child: Scaffold(
          body: Center(
        child: _buildForm(context),
      )),
    );
  }

  Form _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a Username';
              }
              if (value.contains(RegExp(r'[^a-z_]'))) {
                return 'username must be lowercase ans underscore';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'password must be at least 8 characters';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _ConfirmPasswordController,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'password must be at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthenticationCubit>().registerUser(
                      account.email,
                      _usernameController.text,
                      _passwordController.text,
                    );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
