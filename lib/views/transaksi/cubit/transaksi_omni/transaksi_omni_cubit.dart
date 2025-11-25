import 'package:flutter_bloc/flutter_bloc.dart';

import 'transaksi_omni_state.dart';

class TransaksiOmniCubit extends Cubit<TransaksiOmniState> {
  TransaksiOmniCubit() : super(const TransaksiOmniState());

  void setResult({required String kode, required String? msisdn}) {
    emit(state.copyWith(kode: kode, msisdn: msisdn));
  }

  void reset() {
    emit(const TransaksiOmniState());
  }
}
