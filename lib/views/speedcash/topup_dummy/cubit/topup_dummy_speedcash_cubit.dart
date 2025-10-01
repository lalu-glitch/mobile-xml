import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../topup_dummy_model.dart';
import '../topup_repository.dart';

part 'topup_dummy_speedcash_state.dart';

class TopupDummySpeedcashCubit extends Cubit<TopupDummySpeedcashState> {
  final TopupRepository repository;

  TopupDummySpeedcashCubit(this.repository)
    : super(TopupDummySpeedcashInitial());

  Future<void> fetchTopup() async {
    emit(TopupDummySpeedcashLoading());
    try {
      final data = await repository.getTopup();
      emit(TopupDummySpeedcashLoaded(data));
    } catch (e, st) {
      debugPrint('fetchTopup error: $e\n$st');
      emit(TopupDummySpeedcashError(e.toString()));
    }
  }
}
