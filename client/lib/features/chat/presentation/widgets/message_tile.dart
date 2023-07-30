import 'package:client/constance/app_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/entity/message.dart';

class MessageTile extends StatelessWidget {
  final Message onemsg;
  MessageTile({
    Key? key,
    required this.onemsg,
  }) : super(key: key);
  late AppConfig _config;
  @override
  Widget build(BuildContext context) {
    _config = AppConfig(context);
    return Card(
        margin: EdgeInsets.only(
          top: 10,
          left: onemsg.isme ? 20 : 0,
          right: onemsg.isme ? 0 : 20,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: onemsg.isme
            ? Theme.of(context).focusColor.withOpacity(1)
            : Theme.of(context).primaryColorLight,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    onemsg.content,
                    style: TextStyle(fontSize: _config.smallTextSize),
                  ),
                ),
              ),
              Text(DateFormat.jm().format(onemsg.time),
                  style: TextStyle(fontSize: _config.smallTextSize - 5)),
            ],
          ),
        ));
  }
}
