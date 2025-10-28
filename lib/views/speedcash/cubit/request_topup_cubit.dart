import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/speedcash/speedcash_request_topup.dart';
import '../../../data/services/speedcash_api_service.dart';

part 'request_topup_state.dart';

class RequestTopUpCubit extends Cubit<RequestTopUpState> {
  final SpeedcashApiService apiService;
  RequestTopUpCubit(this.apiService) : super(RequestTopUpInitial());

  Future<void> requestTopUp(
    String kodeReseller,
    int nominal,
    String bank,
  ) async {
    emit(RequestTopUpLoading());
    try {
      final data = await apiService.requestTopUp(kodeReseller, nominal, bank);
      emit(RequestTopUpSuccess(data));
    } catch (e) {
      emit(RequestTopUpError(e.toString()));
    }
  }
}
