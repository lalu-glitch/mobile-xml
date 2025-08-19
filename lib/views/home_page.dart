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
      // backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text(balanceVM.userBalance?.namauser ?? '-'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([balanceVM.fetchBalance(), iconVM.fetchIcons()]);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceCard(balanceVM),
              const SizedBox(height: 20),
              _buildPromoSection(),
              const SizedBox(height: 20),
              iconVM.isLoading
                  ? _buildShimmerIcons()
                  : iconVM.error != null
                  ? Text('Error: Unable Get Icon')
                  : _buildIconCategories(iconVM),
              const SizedBox(height: 20),
              _buildTokenSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BalanceViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : vm.error != null
          ? Text('Error: Unable Get Data')
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSaldo(vm.userBalance?.saldo ?? 0),
                    _buildPoin(vm.userBalance?.poin ?? 0),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Deposit Saldo'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('History Transaksi'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSaldo(int saldo) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Saldo Anda', style: TextStyle(fontSize: 16)),
      Text(
        _formatCurrency(saldo),
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ],
  );

  Widget _buildPoin(int poin) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text('Poin', style: TextStyle(fontSize: 14)),
      Text(
        poin.toString(),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ],
  );

  Widget _buildPromoSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'PASTI PROMO',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, i) => Container(
            width: 160,
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.orangeAccent, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/images/promo${i + 1}.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "Promo Murah Merdeka ${i + 1}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
            const SizedBox(height: 10),

            // 👉 GridView kamu taruh di sini
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: entry.value.length,
              itemBuilder: (context, i) {
                final iconItem = entry.value[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: iconItem, // 👈 lempar object langsung
                    );
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.orangeAccent,
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              iconItem.url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.image_not_supported,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            iconItem.filename,
                            style: const TextStyle(fontSize: 12),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTokenSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Token Listrik, PDAM, dan Tagihan Lainnya',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: 8,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Icon(Icons.flash_on)),
        ),
      ),
    ],
  );

  Widget _buildShimmerIcons() => GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
    ),
    itemCount: 8,
    itemBuilder: (_, __) => Column(
      children: [
        Expanded(
          child: ShimmerBox(width: double.infinity, height: 60, radius: 10),
        ),
        const SizedBox(height: 4),
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
