import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../viewmodels/layanan_vm.dart';
import '../../home/widgets/home_content_section.dart';
import '../widgets/shop_category_chips.dart';
import '../widgets/shop_app_bar_actions.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LayananViewModel>(context, listen: false).fetchLayanan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final layananVM = context.watch<LayananViewModel>();
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _isSearching
            ? TextField(
                autofocus: true,
                style: TextStyle(color: kWhite),
                decoration: InputDecoration(
                  hintText: 'Cari layanan',
                  hintStyle: TextStyle(color: kWhite.withAlpha(200)),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  // Untuk saat ini tidak melakukan apa-apa
                },
              )
            : Text('Layanan Toko', style: TextStyle(color: kWhite)),
        iconTheme: IconThemeData(color: kWhite),
        backgroundColor: kOrange,
        actions: [
          ShopsAppBarActions(
            isSearching: _isSearching,
            onSearchChanged: (isSearching) {
              setState(() {
                _isSearching = isSearching;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ShopsCategoryChips(),
          const Divider(color: kNeutral50, thickness: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: HomeContentSection(layananVM: layananVM),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
