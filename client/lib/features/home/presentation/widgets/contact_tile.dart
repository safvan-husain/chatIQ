import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/contact.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    Key? key,
    required this.index,
    required this.contact,
  }) : super(key: key);

  final int index;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: (index == 0)
                  ? BorderSide(color: Theme.of(context).dividerColor)
                  : BorderSide.none,
              bottom: BorderSide(color: Theme.of(context).dividerColor))),
      child: InkWell(
        onTap: () {
          context.router.push(ChatRoute(userame: contact.username));
          // context.navigateNamedTo('/chat:${contact.username}');
        },
        child: ListTile(
          leading: const CircleAvatar(),
          title: Text(contact.username),
        ),
      ),
    );
  }
}
