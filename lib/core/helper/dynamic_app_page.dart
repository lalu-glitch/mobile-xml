enum AppPage {
  prefixFinal,
  inputNomor,
  pilihProduk,
  subKategori,
  multiSubKategori,
  inputNomerAwal,
}

/// Mapping ID ke sequence
Map<int, List<AppPage>> pageSequences = {
  1: [AppPage.prefixFinal],
  2: [AppPage.pilihProduk, AppPage.inputNomor],
  3: [AppPage.subKategori, AppPage.inputNomor, AppPage.pilihProduk],
  4: [AppPage.subKategori, AppPage.pilihProduk, AppPage.inputNomor],
  5: [AppPage.inputNomor, AppPage.subKategori, AppPage.pilihProduk],
  6: [AppPage.multiSubKategori, AppPage.inputNomor, AppPage.pilihProduk],
  7: [AppPage.multiSubKategori, AppPage.pilihProduk, AppPage.inputNomor],
  8: [AppPage.inputNomor, AppPage.multiSubKategori, AppPage.pilihProduk],
};

Map<AppPage, String> pageRoutes = {
  AppPage.prefixFinal: '/detailPrefix',
  AppPage.inputNomor: '/inputNomorTujuan',
  AppPage.pilihProduk: '/detailNoPrefix',
  AppPage.subKategori: '/subKategori',
  AppPage.multiSubKategori: '/multiSubKategori',
};
