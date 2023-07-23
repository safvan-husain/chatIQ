import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:client/features/home/domain/entities/user.dart';
import 'package:client/features/home/domain/usecases/cache_message.dart';
import 'package:client/features/home/domain/usecases/get_local_chats.dart';
import 'package:client/features/home/domain/usecases/get_remote_chats.dart';
import 'package:client/features/home/domain/usecases/log_out.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';

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
  }) : super(const HomeStateImpl(chats: []));

  Future<void> getChats() async {
    Either<Failure, List<User>> result = await getLocalChats.call();
    result.fold(
      (l) {
        log('failed to get chats');
      },
      (r) {
        emit(HomeStateImpl(chats: r));
      },
    );
  }

  Future<void> getContacts(String token) async {
    Either<Failure, List<User>> result =
        await getRemoteChats.call(appToken: token);
    result.fold(
      (l) {
        log('failed to get chats');
      },
      (r) {
        emit(ContactStateImpl(contacts: r, chats: state.chats));
      },
    );
  }

  Future<void> logOut() async {
    Either<Failure, bool> result = await logout();
    result.fold(
      (l) {},
      (r) {
        emit(const HomeLogOut(chats: []));
      },
    );
  }

  Future<void> cachedMessage(String message, String from) async {
    var result = await cacheMessage
        .call(CacheMessageParams(message: message, from: from));
    result.fold((l) {}, (r) {
      emit(HomeLogOut(chats: state.chats));
    });
  }
}
