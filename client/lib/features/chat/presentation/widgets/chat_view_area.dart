import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'message_tile.dart';

class ChatViewArea extends StatelessWidget {
  const ChatViewArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: state.messages.map((onemsg) {
                return MessageTile(onemsg: onemsg);
              }).toList(),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
