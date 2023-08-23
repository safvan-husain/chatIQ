import 'package:bloc/bloc.dart';
import 'package:client/core/usecases/use_case.dart';
import 'package:client/features/settings/domain/usecases/delete_local_chats.dart';
import 'package:client/features/settings/domain/usecases/delete_remote_data.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../settings/domain/usecases/log_out.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final Logout logout;
  final DeleteLocalChats _deleteLocalChats;
  final DeleteRemoteData _deleteRemoteData;
  SettingsCubit(this.logout, this._deleteLocalChats, this._deleteRemoteData)
      : super(SettingsInitial());

  Future<void> logOut(void Function() onCacheCleared) async {
    Either<Failure, bool> result = await logout(NoParams());
    result.fold(
      (l) {},
      (r) {
        if (r) {
          onCacheCleared();
        }
      },
    );
  }

  Future<void> deleteLocalChats({
    required void Function() onCacheDeleted,
    required void Function() onCacheDeleteFailed,
  }) async {
    Either<Failure, void> result = await _deleteLocalChats.call(NoParams());
    result.fold(
      (l) {
        onCacheDeleteFailed();
      },
      (r) {
        onCacheDeleted();
      },
    );
  }

  Future<void> deleteRemoteData(String authToken) async {
    Either<Failure, void> result =
        await _deleteRemoteData(DeleteRemoteDataParams(authToken));
    result.fold(
      (l) {},
      (r) {},
    );
  }
}
