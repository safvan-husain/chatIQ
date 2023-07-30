// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:client/features/chat/domain/usecases/update_last_visit.dart';
import 'package:client/features/home/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

import 'package:client/features/chat/domain/usecases/send_message.dart';
import 'package:client/features/chat/domain/usecases/show_message.dart';

import '../../../../common/entity/message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage sendMessage;
  final ShowMessage showMessage;
  final UpdateLastVisit updateLastVisit;
  // final CacheMessage cacheMessage;
  ChatBloc(
    this.sendMessage,
    this.showMessage,
    this.updateLastVisit,
    // this.cacheMessage,
  ) : super(const ChatStateImpl(messages: [])) {
    on<ShowChatEvent>((event, emit) async {
      var result = await showMessage.call(ShowMessageParams(event.chatId));
      result.fold(
        (l) {
          emit(const ChatFailure());
        },
        (r) {
          emit(ChatStateImpl(messages: r));
        },
      );
    });
    on<SendMessageEvent>(
      (event, emit) async {
        var result = await sendMessage.call(SendMessageParams(
          event.message,
          event.myid,
          event.to,
        ));
        result.fold((l) {
          emit(const ChatFailure());
        }, (r) {
          emit(ChatStateImpl(messages: [...state.messages, r]));
        });
      },
    );
    on<UpdateLastVisitEvent>(
      (event, emit) async {
        var result = await updateLastVisit.call(event.userName);
        result.fold((l) {
          emit(const ChatFailure());
        }, (r) {
          emit(ChatStateImpl(messages: state.messages));
        });
      },
    );
    //   on<CacheMessageEvent>(
    //     (event, emit) async {
    //       var result = await cacheMessage
    //           .call(CacheMessageParams(message: event.message, to: event.to));
    //       result.fold((l) {
    //         emit(const ChatFailure());
    //       }, (r) {
    //         emit(ChatStateImpl(messages: [...state.messages, r]));
    //       });
    //     },
    //   );
  }
}
