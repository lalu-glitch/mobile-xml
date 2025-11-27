class TransaksiOmniState {
  final String? kode;
  final String? msisdn;

  const TransaksiOmniState({this.kode, this.msisdn});

  TransaksiOmniState copyWith({String? kode, String? msisdn}) {
    return TransaksiOmniState(
      kode: kode ?? this.kode,
      msisdn: msisdn ?? this.msisdn,
    );
  }
}
