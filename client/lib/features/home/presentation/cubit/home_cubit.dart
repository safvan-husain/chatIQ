import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:client/common/entity/message.dart';
import 'package:client/core/usecases/use_case.dart';
import 'package:client/features/home/domain/entities/user.dart';
import 'package:client/features/home/domain/usecases/cache_message.dart';
import 'package:client/features/home/domain/usecases/get_local_chats.dart';
import 'package:client/features/home/domain/usecases/get_remote_chats.dart';
import 'package:client/features/home/domain/usecases/log_out.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/contact.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetRemoteChats getRemoteChats;
  final Logout logout;
  final GetLocalChats getLocalChats;
  final CacheMessage cacheMessage;
  HomeCubit({
    required this.getRemoteChats,
    required this.logout,
    required this.getLocalChats,
    required this.cacheMessage,
  }) : super(HomeStateImpl());

  Future<void> getChats() async {
    Either<Failure, List<NewMessages>> result =
        await getLocalChats.call(NoParams());
    result.fold(
      (l) {
        log('failed to get chats ge');
      },
      (r) {
        emit(HomeStateImpl(newMessages: r));
      },
    );
  }

  Future<void> newMessage(NewMessages newMessages) async {
    if (!state.newMessages.any((element) {
      if (element.user.id == newMessages.user.id) {
        element.messageCount = newMessages.messageCount;
        element.user = newMessages.user;
      }
      return element.user.id == newMessages.user.id;
    })) {
      state.newMessages.add(newMessages);
    }

    emit(NewMessageState(newMessages: state.newMessages));
  }

  Future<void> getContacts(String token) async {
    Either<Failure, List<Contact>> result =
        await getRemoteChats.call(appToken: token);
    result.fold(
      (l) {
        log('failed to get chats');
      },
      (r) {
        emit(ContactStateImpl(contacts: r, newMessages: state.newMessages));
      },
    );
  }

  Future<void> logOut() async {
    Either<Failure, bool> result = await logout();
    result.fold(
      (l) {},
      (r) {
        emit(HomeLogOut());
      },
    );
  }

  Future<void> cachedMessage(Message message, String from) async {
    var result = await cacheMessage
        .call(CacheMessageParams(message: message, from: from));
    result.fold(
      (l) {
        log('failure chache message home cubit');
      },
      (r) {
        if (!state.newMessages.any((element) {
          if (element.user.id == r.user.id) {
            element.messageCount = r.messageCount;
            element.user = r.user;
            emit(HomeStateImpl(newMessages: state.newMessages));
          }
          return element.user.id == r.user.id;
        })) {
          emit(HomeStateImpl(newMessages: [...state.newMessages, r]));
        }
        log(state.newMessages.length.toString());
      },
    );
  }
}
