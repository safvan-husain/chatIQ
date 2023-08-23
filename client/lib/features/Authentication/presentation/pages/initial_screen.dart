import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/snack_bar.dart';
import '../../../../routes/router.gr.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../cubit/authentication_cubit.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  void tokenValidation(BuildContext context) async {
    context.read<AuthenticationCubit>().getCachedUser(() => context
        .read<HomeCubit>()
        .getChats(() => showSnackBar(context, "Failed to get recent chats!!")));
  }

  @override
  void initState() {
    tokenValidation(context);
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
        } else if (state.authState == AuthState.initial) {
          context.router.pushAndPopUntil(
            const GoogleSignInRoute(),
            predicate: (state) => false,
          );
        }
      },
      child: const Scaffold(
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chat',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                  ),
                  Text(
                    'IQ',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 50),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              CircularProgressIndicator()
            ],
          ),
        )),
      ),
    );
  }
}
