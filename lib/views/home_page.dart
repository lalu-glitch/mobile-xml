import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/shimmer.dart';
import '../viewmodels/balance_viewmodel.dart';
import '../viewmodels/icon_viewmodel.dart';

class HomePage extends StatefulWidget {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final balanceVM = Provider.of<BalanceViewModel>(context);
    final iconVM = Provider.of<IconsViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0), // jarak atas tambahan
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                balanceVM.fetchBalance(),
                iconVM.fetchIcons(),
              ]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(balanceVM),
                  const SizedBox(height: 24),
                  _buildPromoSection(),
                  const SizedBox(height: 24),
                  iconVM.isLoading
                      ? _buildShimmerIcons()
                      : iconVM.error != null
                      ? Center(child: Text('Gagal memuat icon'))
                      : _buildIconCategories(iconVM),
                  const SizedBox(height: 24),
                  _buildTokenSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Modern header
  // Modern header with Halo outside and Poin at top-right
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
              Text(
                "Halo, ${vm.userBalance?.namauser ?? '-'}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.orange.shade400,
                ),
                onPressed: () {
                  // aksi notifikasi
                },
              ),
            ],
          ),
        ),

        // Card
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: vm.isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: Saldo & Poin kecil
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Saldo Anda",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Poin: ${vm.userBalance?.poin ?? 0}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Saldo besar
                      Text(
                        _formatCurrency(vm.userBalance?.saldo ?? 0),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Deposit Saldo'),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('History Transaksi'),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  // sisanya sama seperti versi elegant sebelumnya
  // _buildPromoSection, _buildIconCategories, _buildTokenSection, _buildShimmerIcons

  Widget _buildBalanceCard(BalanceViewModel vm) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: vm.isLoading
            ? Center(child: CircularProgressIndicator())
            : vm.error != null
            ? Center(child: Text('Error: Tidak dapat mengambil data'))
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSaldo(vm.userBalance?.saldo ?? 0),
                      _buildPoin(vm.userBalance?.poin ?? 0),
                    ],
                  ),
                  const Divider(height: 30, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Deposit Saldo'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('History Transaksi'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSaldo(int saldo) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Saldo Anda',
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      const SizedBox(height: 4),
      Text(
        _formatCurrency(saldo),
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    ],
  );

  Widget _buildPoin(int poin) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text('Poin', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      const SizedBox(height: 4),
      Text(
        poin.toString(),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ],
  );

  Widget _buildPromoSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'PASTI PROMO',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, i) => Container(
            width: 160,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/images/promo${i + 1}.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Promo Murah Merdeka ${i + 1}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: entry.value.length,
              itemBuilder: (context, i) {
                final iconItem = entry.value[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
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
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.apps, color: Colors.orange.shade200),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        iconItem.filename,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
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
      const Text(
        'Token Listrik, PDAM, dan Tagihan Lainnya',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: 8,
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

  String _formatCurrency(int n) {
    final s = n.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join()},-';
  }
}
