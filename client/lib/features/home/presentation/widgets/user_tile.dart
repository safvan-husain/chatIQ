// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:client/utils/show_avatar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:provider/provider.dart';

import '../../../../provider/unread_messages.dart';
import '../../../../pages/profile/avatar/svg_rapper.dart';
import '../../domain/entities/user.dart';

class UserTile extends StatefulWidget {
  final User user;
  const UserTile({
    Key? key,
    required this.user,
  }) : super(key: key);
  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  DrawableRoot? svgRoot;
  _generateSvg(String? svgCode) async {
    svgCode ??= multiavatar(widget.user.username);
    return SvgWrapper(svgCode).generateLogo().then((value) {
      setState(() {
        svgRoot = value!;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _generateSvg(widget.user.avatar);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          svgRoot == null ? const CircleAvatar() : showAvatar(svgRoot!, 50),
      title: Text(widget.user.username),
      trailing: Provider.of<Unread>(context)
                  .numberOfUnreadMessOf(widget.user.username) ==
              0
          ? const SizedBox()
          : CircleAvatar(
              radius: 10.0,
              backgroundColor: Colors.green,
              child: Text(
                Provider.of<Unread>(context)
                    .numberOfUnreadMessOf(widget.user.username)
                    .toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
