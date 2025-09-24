class OnboardingPageData {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

List<OnboardingPageData> onboardPages = [
  OnboardingPageData(
    imagePath: 'assets/images/hero_0.png',
    title: 'Semua Kebutuhan Ada',
    description:
        'Selangkah menuju kemudahan, semua\n kebutuhan digital ada di satu aplikasi!',
  ),
  OnboardingPageData(
    imagePath: 'assets/images/hero_1.png',
    title: 'Peluang Tanpa Batas',
    description: 'Dipakai sendiri hemat, dipakai jualan\n makin cuan!',
  ),
  OnboardingPageData(
    imagePath: 'assets/images/hero_2.png',
    title: 'Hidup Jadi Lebih Mudah',
    description:
        'semua jadi lebih cepat tinggal klik,\n transaksi langsung beres!',
  ),
];
