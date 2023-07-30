import 'dart:developer';

import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/home/domain/entities/contact.dart';
import 'package:client/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_page/search_page.dart';

import '../../../../../common/widgets/second_coustom.dart';
import '../../widgets/contact_tile.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var token = context.read<AuthenticationCubit>().state.user!.token;
    context.read<HomeCubit>().getContacts(token);
    log('contaa');
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is ContactStateImpl) {
          log('its ');
        }
      },
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
        InkWell(
          child: const Icon(Icons.search),
          onTap: () => showSearchForCustomiseSearchDelegate<Contact>(
              context: context,
              delegate: SearchScreen<Contact>(
                itemStartsWith: true,
                items: contacts,
                filter: (t) => [t.username],
                failure: const Center(
                  child: Text('No Possible result found'),
                ),
                builder: (t) => ContactTile(index: 1, contact: t),
                appBarBuilder: (controller, onSubmitted, textInputAction, p3) {
                  return PreferredSize(
                    preferredSize: const Size(double.infinity, 50.0),
                    child: SafeArea(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                focusNode: p3,
                                controller: controller,
                                textInputAction: textInputAction,
                                keyboardType: TextInputType.text,
                                onSubmitted: onSubmitted,
                                decoration: const InputDecoration(
                                  hintText: '',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1.5),
                                  ),
                                ),
                              ),
                            ),
                            const Text('go')
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
        )
      ],
    ),
  );
}
