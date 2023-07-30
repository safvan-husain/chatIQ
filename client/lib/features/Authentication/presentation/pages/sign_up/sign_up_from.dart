import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupFormPage extends StatelessWidget {
  SignupFormPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state.authState == AuthState.authenticated) {
              context.router.pushAndPopUntil(
                const DefaultRoute(),
                predicate: (route) => false,
              );
              log('uth');
              if (state.authState == AuthState.unauthenticated) {
                log('unauth');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Unauthenticated.'),
                  ),
                );
              }
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
          TextFormField(
            controller: _confirmPasswordController,
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
                      _emailController.text,
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
