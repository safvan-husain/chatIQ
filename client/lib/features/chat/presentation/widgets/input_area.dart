import 'package:client/features/Authentication/presentation/cubit/authentication_cubit.dart';
import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/chat_view.dart';

class InputArea extends StatelessWidget {
  InputArea({
    super.key,
    required this.widget,
  });

  final ChatPage widget;
  final TextEditingController msgtext = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      height: 70,
      child: Row(
        children: [
          Expanded(
              child: Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: msgtext,
              decoration: const InputDecoration(hintText: "Enter your Message"),
            ),
          )),
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: const Icon(Icons.send),
              onPressed: () {
                context.read<ChatBloc>().add(
                      SendMessageEvent(
                        message: msgtext.text,
                        myid: context
                            .read<AuthenticationCubit>()
                            .state
                            .user!
                            .username,
                        to: widget.user,
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
