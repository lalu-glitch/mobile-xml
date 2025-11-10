import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/layanan/layanan_model.dart';
import '../../../data/services/api_service.dart';

part 'layanan_state.dart';

class LayananCubit extends Cubit<LayananState> {
  final ApiService apiService;
  LayananCubit(this.apiService) : super(LayananInitial());

  Map<String, List<IconItem>> _layananByHeading = {};
  Map<String, List<IconItem>> get layananByHeading => _layananByHeading;

  Future<void> fetchLayanan() async {
    emit(LayananLoading());
    try {
      final response = await apiService.fetchIcons();
      final layananSection = response.data.firstWhere(
        (value) => value.section.toLowerCase() == 'layanan',
      );
      _layananByHeading = {
        for (var heading in layananSection.data) heading.heading: heading.list,
      };
      emit(LayananLoaded(response));
    } catch (e) {
      emit(LayananError('Ada yang salah: $e'));
    }
  }
}
