import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../constance/full_width_button.dart';
import '../../../../../routes/router.gr.dart';
import '../../../../../services/google_auth_services.dart';

class GoogleSignUpPage extends StatelessWidget {
  const GoogleSignUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await GoogleSignInApi.logout();
                  GoogleSignInAccount? account = await GoogleSignInApi.login();
                  if (account != null && context.mounted) {
                    context.router
                        .push(GoogleSignUpSetupRoute(account: account));
                  }
                },
                icon: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    'assets/google.png',
                    fit: BoxFit.contain,
                  ),
                ),
                label: const Text('Sign Up with Google'),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40)),
              ),
              FullWidthButton(
                text: "Use Form",
                onPress: () => context.router.push(SignupFormRoute()),
              ),
              TextButton(
                  onPressed: () {
                    context.router.push(const GoogleSignInRoute());
                  },
                  child: const Text('Have an account? Sign In'))
            ],
          ),
        ),
      ),
    );
  }
}
