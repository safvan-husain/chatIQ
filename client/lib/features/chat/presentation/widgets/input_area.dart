import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/entity/message.dart';
import '../../../../constance/app_config.dart';
import '../pages/chat_view.dart';

class InputArea extends StatelessWidget {
  InputArea({
    super.key,
    required this.widget,
  });

  final ChatPage widget;
  late AppConfig _config;
  final TextEditingController msgtext = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _config = AppConfig(context);
    return Container(
      margin: const EdgeInsets.all(10),
      height: _config.rH(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 15),
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: msgtext,
              decoration: InputDecoration(
                hintText: "Enter your Message",
                hintStyle: TextStyle(fontSize: _config.rW(3)),
                border: InputBorder.none,
              ),
            ),
          )),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                context.read<ChatBloc>().add(
                      SendMessageEvent(
                        message: Message(
                          content: msgtext.text,
                          chatId: null,
                          time: DateTime.now(),
                          isme: true,
                        ),
                        myid: context
                            .read<AuthenticationCubit>()
                            .state
                            .user!
                            .username,
                        to: widget.userame,
                      ),
                    );
                msgtext.text = "";
              },
            ),
          )
        ],
      ),
    );
  }
}
