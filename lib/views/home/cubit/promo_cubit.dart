import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/layanan/layanan_model.dart';
import '../../../data/services/api_service.dart';

part 'promo_state.dart';

class PromoCubit extends Cubit<PromoState> {
  final ApiService apiService;
  PromoCubit(this.apiService) : super(PromoInitial());

  bool hasShownPopUp = false;
  List<IconItem> _promoList = [];
  List<IconItem> get promoList => _promoList;

  Future<void> fetchPromo() async {
    emit(PromoLoading());
    try {
      final response = await apiService.fetchIcons();
      final promoSection = response.data.firstWhere(
        (value) => value.section.toLowerCase() == 'promo',
      );
      _promoList = promoSection.data.first.list;
      emit(PromoLoaded(response));
    } catch (e) {
      emit(PromoError('Ada yang salah: $e'));
    }
  }
}
