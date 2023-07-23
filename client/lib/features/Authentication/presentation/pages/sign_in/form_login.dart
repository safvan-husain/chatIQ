import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../models/user_model.dart';
import '../../../../../provider/user_provider.dart';

class LoginFormPage extends StatelessWidget {
  LoginFormPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state.authState == AuthState.authenticated) {
              Provider.of<UserProvider>(context, listen: false).setUser(User(
                id: state.user!.email,
                username: state.user!.username,
                email: state.user!.email,
                isOnline: true,
              ));
              context.router.pushAndPopUntil(
                const HomeRoute(),
                predicate: (route) => false,
              );
              log('uth');
            }
            if (state.authState == AuthState.unauthenticated) {
              log('unauth');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Unauthenticated.'),
                ),
              );
            }
          },
          child: _buildForm(context),
        ),
      ),
    );
  }

  Form _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email address';
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
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthenticationCubit>().getUser(
                      _emailController.text,
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
