import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:client/common/entity/message.dart';
import 'package:client/core/usecases/use_case.dart';
import 'package:client/features/home/domain/entities/user.dart';
import 'package:client/features/home/domain/usecases/cache_message.dart';
import 'package:client/features/home/domain/usecases/get_local_chats.dart';
import 'package:client/features/home/domain/usecases/get_remote_chats.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/contact.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetRemoteChats getRemoteChats;
  final GetLocalChats getLocalChats;
  final CacheMessage cacheMessage;
  HomeCubit({
    required this.getRemoteChats,
    required this.getLocalChats,
    required this.cacheMessage,
  }) : super(HomeStateImpl());

  Future<void> getChats(void Function() showSnackBar) async {
    Either<Failure, List<NewMessages>> result =
        await getLocalChats.call(NoParams());
    result.fold(
      (l) {
        showSnackBar();
      },
      (r) {
        var list = _sortListByTime(r);
        emit(HomeStateImpl(newMessages: list));
      },
    );
  }

  Future<void> getContacts(String token,void Function() showSnackBar) async {
    Either<Failure, List<Contact>> result =
        await getRemoteChats.call(appToken: token);
    result.fold(
      (l) {
        showSnackBar();
      },
      (r) {
        emit(ContactStateImpl(contacts: r, newMessages: state.newMessages));
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
            emit(
                HomeStateImpl(newMessages: _sortListByTime(state.newMessages)));
          }
          return element.user.id == r.user.id;
        })) {
          emit(HomeStateImpl(
              newMessages: _sortListByTime([...state.newMessages, r])));
        }
        log(state.newMessages.length.toString());
      },
    );
  }
}


List<NewMessages> _sortListByTime(List<NewMessages> userModels) {
  List<NewMessages> sortedUsers = List.from(userModels);

  sortedUsers.sort((a, b) {
    if (a.user.lastMessage == null && b.user.lastMessage == null) {
      return 0; // If both have no lastMessage, their order doesn't matter
    } else if (a.user.lastMessage == null) {
      return 1; // Place users with null lastMessage at the end
    } else if (b.user.lastMessage == null) {
      return -1; // Place users with null lastMessage at the end
    } else {
      return b.user.lastMessage!.time.compareTo(a.user.lastMessage!.time);
    }
  });
  return sortedUsers;
}