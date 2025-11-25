enum AppPage {
  prefixFinal,
  inputBNEU,
  inputNomorAwal,
  inputNomorAkhir,
  inputNomorMid,
  pilihProduk,
  multiSubKategori,
  cekTransaksi,
}

/// Mapping ID ke sequence
Map<int, List<AppPage>> pageSequences = {
  1: [AppPage.prefixFinal, AppPage.inputBNEU],
  2: [AppPage.pilihProduk, AppPage.inputNomorAkhir],
  3: [AppPage.pilihProduk, AppPage.inputNomorMid, AppPage.cekTransaksi],
  4: [AppPage.pilihProduk, AppPage.inputNomorAkhir],
  5: [AppPage.inputNomorAwal, AppPage.pilihProduk],
  6: [AppPage.multiSubKategori, AppPage.inputNomorMid, AppPage.pilihProduk],
  7: [AppPage.multiSubKategori, AppPage.pilihProduk, AppPage.inputNomorAkhir],
  8: [AppPage.inputNomorAwal, AppPage.multiSubKategori, AppPage.pilihProduk],
  9: [AppPage.inputNomorAwal, AppPage.pilihProduk], //khusus omni
};

Map<AppPage, String> pageRoutes = {
  AppPage.prefixFinal: '/detailPrefix',
  AppPage.pilihProduk: '/detailNoPrefix',
  AppPage.inputNomorAwal: '/inputNomorFirst',
  AppPage.inputNomorMid: '/inputNomorMid',
  AppPage.inputNomorAkhir: '/inputNomorTujuan',
  AppPage.inputBNEU: '/inputBNEU',
  AppPage.multiSubKategori: '/multiSubKategori',
  AppPage.cekTransaksi: '/cekTransaksi',
};
