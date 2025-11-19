import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'speedcash_connection_state.dart';

class SpeedcashConnectionCubit extends Cubit<SpeedcashConnectionState> {
  SpeedcashConnectionCubit() : super(SpeedcashConnectionInitial());
}
