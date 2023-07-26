import 'dart:developer';

import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:client/features/home/presentation/widgets/user_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var token = context.read<AuthenticationCubit>().state.user!.token;
    context.read<HomeCubit>().getContacts(token);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is ContactStateImpl) {
          log('its ');
        }
      },
      buildWhen: (previous, current) => current is ContactStateImpl,
      builder: (context, state) {
        if (state.contacts!.isEmpty) {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }
        return Scaffold(
          body: SafeArea(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return UserWrapper(
                index: index,
                user: state.contacts!.elementAt(index),
                newMessageCount: 0,
              );
            },
            itemCount: state.contacts!.length,
          )),
        );
      },
    );
  }
}
