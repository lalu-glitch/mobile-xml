import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/speedcash/speedcash_list_bank.dart';
import '../../../data/services/speedcash_api_service.dart';

part 'list_bank_state.dart';

class SpeedcashBankCubit extends Cubit<SpeedcashBankState> {
  final SpeedcashApiService apiService;
  SpeedcashBankCubit(this.apiService) : super(SpeedcashBankInitial());

  Future<void> fetchBanks(String kodeReseller) async {
    emit(SpeedcashBankLoading());
    try {
      final dataBank = await apiService.listOfBanks(kodeReseller);
      emit(SpeedcashBankLoaded(dataBank));
    } catch (e) {
      emit(SpeedcashBankError(e.toString()));
    }
  }
}
