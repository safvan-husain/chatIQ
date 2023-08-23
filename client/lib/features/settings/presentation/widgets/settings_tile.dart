import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subtitle;
  final void Function() onConfirmBtnTap;

  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onConfirmBtnTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (subtitle != null) {
      return InkWell(
        onTap: () => CoolAlert.show(
          context: context,
          type: CoolAlertType.confirm,
          title: "Do you want to $title?",
          confirmBtnText: "Yes",
          cancelBtnText: "No",
          onConfirmBtnTap: onConfirmBtnTap,
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle!),
        ),
      );
    }
    return InkWell(
      onTap: () => CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        title: "Do you want to $title?",
        confirmBtnText: "Yes",
        cancelBtnText: "No",
        onConfirmBtnTap: onConfirmBtnTap,
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }
}
