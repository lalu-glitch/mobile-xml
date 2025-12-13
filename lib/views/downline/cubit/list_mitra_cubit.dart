import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/mitra/mitra_model.dart';
import '../../../data/services/api_service.dart';

part 'list_mitra_state.dart';

class ListMitraCubit extends Cubit<ListMitraState> {
  final ApiService apiService;
  ListMitraCubit(this.apiService) : super(ListMitraInitial());

  Future<void> fetchMitraList(String kodeReseller) async {
    emit(ListMitraLoading());
    try {
      final data = await apiService.fetchMitra(kodeReseller);
      if (data.data.isEmpty) {
        emit(ListMitraEmpty('List jaringan kosong'));
      } else {
        emit(ListMitraLoaded(data.data));
      }
    } catch (e) {
      emit(ListMitraError(e.toString()));
    }
  }
}
