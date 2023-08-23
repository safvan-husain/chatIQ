import 'package:client/common/widgets/snack_bar.dart';
import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/home/domain/entities/contact.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:custom_search_bar/custom_search_bar.dart';

import '../../widgets/contact_tile.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var token = context.read<AuthenticationCubit>().state.user!.token;
    context.read<HomeCubit>().getContacts(
        token, () => showSnackBar(context, 'Failed to get contacts!!'));
        
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => current is ContactStateImpl,
      builder: (context, state) {
        if (state.contacts == null || state.contacts!.isEmpty) {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }

        return Scaffold(
          appBar: _builtAppBar(context, state.contacts!),
          body: SafeArea(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return ContactTile(
                index: index,
                contact: state.contacts!.elementAt(index),
              );
            },
            itemCount: state.contacts!.length,
          )),
        );
      },
    );
  }
}

PreferredSizeWidget _builtAppBar(BuildContext context, List<Contact> contacts) {
  return PreferredSize(
    preferredSize: const Size(double.infinity, 50.0),
    child: AppBar(
      elevation: 0.0,
      title: const Text('New friends'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: const Hero(tag: 'icon', child: Icon(Icons.search)),
            onTap: () => showSearchForCustomiseSearchDelegate<Contact>(
              context: context,
              delegate: SearchScreen<Contact>(
                itemStartsWith: true,
                items: contacts,
                filter: (t) => [t.username],
                failure: const Center(
                  child: Text('No Possible result found'),
                ),
                itemBuilder: (t) => ContactTile(index: 1, contact: t),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
