import 'package:client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'message_tile.dart';

class ChatViewArea extends StatefulWidget {
  const ChatViewArea({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatViewArea> createState() => _ChatViewAreaState();
}

class _ChatViewAreaState extends State<ChatViewArea> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    return BlocConsumer<ChatBloc, ChatState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(15),
          child: ListView(
            controller: _scrollController,
            dragStartBehavior: DragStartBehavior.down,
            children: state.messages
                .map((i) => Align(
                      alignment:
                          i.isme ? Alignment.bottomRight : Alignment.topLeft,
                      child: MessageTile(onemsg: i),
                    ))
                .toList(),
          ),
        );
      },
      listener: (context, state) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        setState(() {});
      },
    );
  }
}
