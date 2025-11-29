import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/user/user_balance_model.dart';
import '../../../data/services/api_service.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  final ApiService apiService;
  BalanceCubit(this.apiService) : super(BalanceInitial());

  Future<void> fetchUserBalance() async {
    emit(BalanceLoading());
    try {
      final userBalance = await apiService.fetchUserBalance();
      if (userBalance.isLogout == true) {
        emit(BalanceLogout('Sesi Habis'));
        return;
      }
      emit(BalanceLoaded(userBalance));
    } catch (e) {
      emit(BalanceError(e.toString()));
    }
  }

  void reset() {
    emit(BalanceInitial());
  }
}
