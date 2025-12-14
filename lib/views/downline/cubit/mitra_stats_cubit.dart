import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/mitra/mitra_stats_model.dart';
import '../../../data/services/api_service.dart';

part 'mitra_stats_state.dart';

class MitraStatsCubit extends Cubit<MitraStatsState> {
  final ApiService apiService;
  MitraStatsCubit(this.apiService) : super(MitraStatsInitial());

  Future<void> loadMitraStats(String kodeReseller) async {
    emit(MitraStatsLoading());
    try {
      final response = await apiService.fetchMitraStats(kodeReseller);
      emit(MitraStatsLoaded(response));
    } catch (e) {
      emit(MitraStatsError(e.toString()));
    }
  }
}
