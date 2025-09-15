enum AppPage { inputNomor, pilihProduk, subKategori, multiSubKategori }

/// Mapping ID ke sequence
Map<int, List<AppPage>> pageSequences = {
  1: [AppPage.inputNomor],
  2: [AppPage.pilihProduk, AppPage.inputNomor],
  3: [AppPage.subKategori, AppPage.inputNomor, AppPage.pilihProduk],
  4: [AppPage.subKategori, AppPage.pilihProduk, AppPage.inputNomor],
  5: [AppPage.inputNomor, AppPage.subKategori, AppPage.pilihProduk],
  6: [AppPage.multiSubKategori, AppPage.inputNomor, AppPage.pilihProduk],
  7: [AppPage.multiSubKategori, AppPage.pilihProduk, AppPage.inputNomor],
  8: [AppPage.inputNomor, AppPage.multiSubKategori, AppPage.pilihProduk],
};

/// Helper untuk map AppPage ke widget page actual
  // Widget _getPageWidget(AppPage page) {
  //   switch (page) {
  //     case AppPage.inputNomor:
  //       return InputNomorPage();
  //     case AppPage.pilihProduk:
  //       return PilihProdukPage();
  //     case AppPage.subKategori:
  //       return SubKategoriPage();
  //     case AppPage.multiSubKategori:
  //       return MultiSubKategoriPage();
  //   }
  // }
