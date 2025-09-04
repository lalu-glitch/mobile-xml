// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/cs_bottom_sheet.dart';
import '../utils/shimmer.dart';
import '../viewmodels/balance_viewmodel.dart';
import '../viewmodels/icon_viewmodel.dart';
import '../utils/currency.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final balanceVM = Provider.of<BalanceViewModel>(context, listen: false);
      final iconVM = Provider.of<IconsViewModel>(context, listen: false);
      balanceVM.fetchBalance();
      iconVM.fetchIcons();
      // buat promo
      Future.delayed(const Duration(seconds: 1), () {
        PromoPopup.show(context, "assets/images/promo.jpg");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final balanceVM = Provider.of<BalanceViewModel>(context);
    final iconVM = Provider.of<IconsViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background orange
          Container(color: Colors.orangeAccent[700]),
          // Background image di pojok kiri atas
          Positioned(
            top: 35,
            left: 0,
            child: Image.asset(
              'assets/images/bg-header.png',
              width: 300, // sesuaikan ukuran
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          // Konten utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),

              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.wait([
                    balanceVM.fetchBalance(),
                    iconVM.fetchIcons(),
                  ]);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // === Header ===
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildHeader(balanceVM),
                          ),

                          const SizedBox(
                            height: 100,
                          ), // kasih space supaya card muat di overlay
                          // === Bagian bawah (container putih) ===
                          Container(
                            decoration: BoxDecoration(color: Colors.grey[100]),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 120),
                                _buildPromoSection(),
                                const SizedBox(height: 24),
                                iconVM.isLoading
                                    ? _buildShimmerIcons()
                                    : iconVM.error != null
                                    ? const Center(
                                        child: Text('Gagal memuat icon'),
                                      )
                                    : _buildIconCategories(iconVM),
                                iconVM.isLoading
                                    ? _buildShimmerIcons()
                                    : iconVM.error != null
                                    ? const Center(
                                        child: Text('Gagal memuat icon'),
                                      )
                                    : _buildIconCategories(iconVM),
                                const SizedBox(height: 24),
                                _buildPromoSectionMiddle(),
                                const SizedBox(height: 24),
                                _buildTokenSection(),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // === Overlay Card ===
                      Positioned(
                        top:
                            80, // atur biar card nempel di antara header & container
                        left: 16,
                        right: 16,
                        child: _buildHeaderCard(balanceVM),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BalanceViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Halo, Nama User
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Halo, ",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.normal, // normal untuk 'Halo,'
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    vm.userBalance?.namauser ?? '-',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold, // bold untuk nama user
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_none, color: Colors.white),
                    onPressed: () {
                      // aksi notifikasi
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.headset_mic, color: Colors.white),
                    onPressed: () {
                      // aksi notifikasi
                      showCSBottomSheet(context, "Hubungi CS");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Card
        const SizedBox(height: 50),
      ],
    );
  }

  // Modern header with Halo outside and Poin at top-right
  Widget _buildHeaderCard(BalanceViewModel vm) {
    return Column(
      children: [
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: vm.isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 20,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // <-- radius 8
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // <-- radius 12
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(3, (index) {
                            return Container(
                              width: 80,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ), // <-- radius 10
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: Saldo speedcash
                      _buildWallet(vm),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons
                                    .account_balance_wallet, // ikon uang dompet
                                color: Colors.orangeAccent[700],
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stok XML",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    CurrencyUtil.formatCurrency(
                                      vm.userBalance?.saldo ?? 0,
                                    ),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/webView',
                                arguments: {
                                  'url': 'https://youtube.com',
                                  'title': 'Registrasi Speedcash',
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                            ),
                            icon: Icon(
                              Icons.add_box,
                              size: 24,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Isi Stok",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize.min, // biar ukurannya pas
                              children: [
                                const Icon(
                                  Icons.attach_money,
                                  color: Colors.green,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 4),
                                    Text(
                                      "${vm.userBalance?.poin ?? 0} ",
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                    Text(
                                      "Komisi",
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize.min, // biar ukurannya pas
                              children: [
                                const Icon(Icons.star, color: Colors.orange),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 4),
                                    Text(
                                      "${vm.userBalance?.poin ?? 0} ",
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                    Text(
                                      "Poin",
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/riwayatTransaksi',
                                );
                              },
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // biar ada efek ripple bulat
                              child: Row(
                                children: [
                                  Icon(Icons.history, color: Colors.orange),
                                  Text(
                                    " Riwayat",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent[700],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.report,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                            const Text(
                              " Jangan biarin saldo kamu kosong! Yuk, topup sekarang!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.bold, // bold untuk nama user
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildWallet(vm) {
    final hasSpeedcash = vm.userBalance?.ewallet.isNotEmpty ?? false;

    ///ngetes doank
    // final hasSpeedcash = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Bagian kiri (ikon + saldo)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_balance_wallet,
              color: Colors.blue,
              size: 28,
            ),
            const SizedBox(width: 8),

            // Informasi saldo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Saldo Speedcash",
                  style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                ),
                if (hasSpeedcash)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: vm.userBalance!.Speedcash.map<Widget>((ew) {
                      return Text(
                        CurrencyUtil.formatCurrency(ew.saldoSpeedcash),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  )
                else
                  Text(
                    "Tidak terhubung",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),

        // Tombol kanan
        ElevatedButton.icon(
          onPressed: () {
            if (hasSpeedcash) {
              // kalau sudah ada Speedcash → ke halaman deposit
              Navigator.pushNamed(context, '/speedcashDepositPage');
            } else {
              // kalau belum ada Speedcash → ke halaman aktifkan Speedcash
              Navigator.pushNamed(context, '/speedcashBindingPage');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
          icon: Icon(
            hasSpeedcash ? Icons.add_box : Icons.link_rounded,
            size: 20,
            color: Colors.white,
          ),
          label: Text(
            hasSpeedcash ? "Deposit" : "Hubungkan",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoSection() {
    return SizedBox(
      height: 280, // total tinggi section
      child: Stack(
        children: [
          // 👉 Background gradient besar
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.only(
                right: 40,
              ), // lebih lebar dari slider
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomLeft,
                  radius: 1.2,
                  colors: [Colors.orangeAccent, Colors.grey.shade100],
                  stops: const [0.0, 1.0],
                ),

                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),

              // 👉 tambahin child di atas background
              child: Align(
                alignment: Alignment
                    .bottomLeft, // atau Alignment.centerLeft kalau mau di kiri
                child: Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/images/bg-promo.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ),

          // 👉 Konten ditaruh center
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // biar tinggi ikut isi
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        // SLIDE PERTAMA -> teks promosi
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "PASTI PROMO\n",
                              //   style: TextStyle(
                              //     fontSize: 20.sp,
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              // Text(
                              //   "Cuma ada di sini,\nBuruan cek promo nya!",
                              //   style: TextStyle(
                              //     fontSize: 12.sp,
                              //     color: Colors.white,
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      }

                      // SLIDE PROMO BERGAMBAR
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/promo$i.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Promo Murah Merdeka Merdeka Merdeka $i",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14.sp),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSectionMiddle() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'PASTI PROMO 2',
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 160, // lebih rendah biar landscape
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, i) => Container(
            width: 260, // lebih lebar dari sebelumnya
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/promo_bwh${i + 1}.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Promo Murah Murah Murah Murah Murah Murah Merdeka ${i + 1}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp),
                    maxLines: 1, // batas baris
                    overflow: TextOverflow.ellipsis, // kasih ...
                    softWrap: false, // biar ga pindah baris
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildIconCategories(IconsViewModel iconVM) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: iconVM.iconsByCategory.entries.map((entry) {
        final doubledList = [...entry.value, ...entry.value];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key.toUpperCase(),
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // background putih 1 blok
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),

              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                // itemCount: entry.value.length,
                ///test icon banyakan
                itemCount: doubledList.length,

                itemBuilder: (context, i) {
                  // final iconItem = entry.value[i];
                  ///test icon banyakan
                  final iconItem = doubledList[i];

                  return GestureDetector(
                    onTap: () {
                      ///sementara di hardcode dulu kali yaaa
                      final routeName = (i == 0 || i == 1 || i == 3)
                          ? '/detailNoPrefix'
                          : '/detailPrefix';

                      Navigator.pushNamed(
                        context,
                        routeName,
                        arguments: iconItem,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orange.shade200,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              iconItem.url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.apps,
                                color: Colors.orange.shade200,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            iconItem.filename,
                            style: TextStyle(fontSize: 12.sp),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTokenSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Tagihan Lainnya',
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.flash_on, color: Colors.orange),
          ),
        ),
      ),
    ],
  );

  Widget _buildShimmerIcons() => GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
    ),
    itemCount: 8,
    itemBuilder: (_, __) => Column(
      children: [
        Expanded(
          child: ShimmerBox(width: double.infinity, height: 60, radius: 12),
        ),
        const SizedBox(height: 6),
        ShimmerBox(width: 40, height: 10, radius: 4),
      ],
    ),
  );
}

class PromoPopup {
  static void show(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true, // tap luar untuk close
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
              // Tombol close di pojok kanan atas
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
