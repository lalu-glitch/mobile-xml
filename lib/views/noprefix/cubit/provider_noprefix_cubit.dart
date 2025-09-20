import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/provider_kartu.dart';
import '../../../data/services/api_service.dart';

part 'provider_noprefix_state.dart';

class ProviderNoPrefixCubit extends Cubit<ProviderState> {
  final ApiService apiService;

  ProviderNoPrefixCubit(this.apiService) : super(ProviderInitial());

  Future<void> fetchProviders(String category, String tujuan) async {
    emit(ProviderNoPrefixLoading());
    try {
      final providers = await apiService.fetchProviders(category, tujuan);
      emit(ProviderNoPrefixSuccess(providers));
    } catch (e) {
      emit(ProviderNoPrefixError(e.toString()));
    }
  }
}
