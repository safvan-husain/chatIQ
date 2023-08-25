import 'package:client/features/settings/presentation/widgets/pop_up/hero_dialog_route.dart';
import 'package:flutter/material.dart';

import 'pop_up/pop_up_card.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  final void Function() onConfirmBtnTap;

  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onConfirmBtnTap,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) {
              return AddTodoPopupCard(
                heroTag: title,
                subtitile: subtitle,
                onConfirm: onConfirmBtnTap,
              );
            },
            settings: const RouteSettings(),
          ),
        );
      },
      child: Hero(
        tag: title,
        child: Card(
          elevation: 0,
          child: ListTile(
            leading: Icon(icon),
            title: Text(title),
          ),
        ),
      ),
    );
  }
}
