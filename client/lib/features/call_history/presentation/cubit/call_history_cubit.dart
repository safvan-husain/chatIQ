import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'call_history_state.dart';

class CallHistoryCubit extends Cubit<CallHistoryState> {
  CallHistoryCubit() : super(CallHistoryInitial());
}
