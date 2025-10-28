import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/speedcash/speedcash_topup_guide.dart';
import '../../../data/services/speedcash_api_service.dart';

part 'panduan_top_up_state.dart';

class PanduanTopUpCubit extends Cubit<PanduanTopUpState> {
  final SpeedcashApiService apiService;
  PanduanTopUpCubit(this.apiService) : super(PanduanTopUpInitial());

  Future<void> fetchPanduan(String kodeReseller, String bank) async {
    emit(PanduanTopUpLoading());
    try {
      final data = await apiService.topUpGuide(kodeReseller, bank);
      emit(PanduanTopUpLoaded(data));
    } catch (e) {
      emit(PanduanTopError(e.toString()));
    }
  }
}
