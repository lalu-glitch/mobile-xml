import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/provider_kartu.dart';
import '../../../data/services/api_service.dart';

part 'provider_prefix_state.dart';

class ProviderPrefixCubit extends Cubit<ProviderPrefixState> {
  final ApiService apiService;

  ProviderPrefixCubit(this.apiService) : super(ProviderPrefixInitial());

  //kalo error ganti ke map
  Future<void> fetchProvidersPrefix(String category, String tujuan) async {
    emit(ProviderPrefixLoading());
    try {
      final providers = await apiService.fetchProvidersPrefix(category, tujuan);
      emit(ProviderPrefixSuccess(providers));
    } catch (e) {
      emit(ProviderPrefixError(e.toString()));
    }
  }

  void clear() {
    emit(ProviderPrefixInitial());
  }
}
