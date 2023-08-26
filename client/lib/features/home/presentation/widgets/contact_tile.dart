import 'package:auto_route/auto_route.dart';
import 'package:client/routes/router.gr.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/avatar.dart';
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
    Future<Widget>? avatar = showAvatar(40, username: contact.username);
    return InkWell(
      onTap: () {
        context.router.push(ChatRoute(userame: contact.username));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          elevation: 0,
          child: ListTile(
            leading: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data ?? const CircleAvatar();
                }
                return const CircleAvatar();
              },
              future: avatar,
            ),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                contact.username,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
