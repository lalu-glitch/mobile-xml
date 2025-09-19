enum AppPage {
  prefixFinal,
  inputNomorAwal,
  inputNomorAkhir,
  inputNomorMid,
  pilihProduk,
  subKategori,
  multiSubKategori,
}

/// Mapping ID ke sequence
Map<int, List<AppPage>> pageSequences = {
  1: [AppPage.prefixFinal],
  2: [AppPage.pilihProduk, AppPage.inputNomorAkhir],
  3: [AppPage.pilihProduk, AppPage.inputNomorMid, AppPage.pilihProduk],
  4: [AppPage.pilihProduk, AppPage.inputNomorAkhir],
  5: [AppPage.inputNomorAwal, AppPage.pilihProduk],
  6: [AppPage.multiSubKategori, AppPage.inputNomorMid, AppPage.pilihProduk],
  7: [AppPage.multiSubKategori, AppPage.pilihProduk, AppPage.inputNomorAkhir],
  8: [AppPage.inputNomorAwal, AppPage.multiSubKategori, AppPage.pilihProduk],
};

Map<AppPage, String> pageRoutes = {
  AppPage.prefixFinal: '/detailPrefix',
  AppPage.inputNomorAwal: '/inputNomorFirst',
  AppPage.inputNomorMid: '/inputNomorMid',
  AppPage.inputNomorAkhir: '/inputNomorTujuan',
  AppPage.pilihProduk: '/detailNoPrefix',
  AppPage.subKategori: '/subKategori',
  AppPage.multiSubKategori: '/multiSubKategori',
};
