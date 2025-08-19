import 'package:flutter/material.dart';
import '../models/icon_data.dart';
import '../viewmodels/icon_viewmodel.dart';

import '../services/auth_guard.dart';
import 'konfirmasi_page.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String selectedNomor = "085643085743";
  String? selectedPulsaId;
  double selectedPrice = 0;

  final List<Map<String, dynamic>> pulsaList = [
    {"id": "H05", "label": "INDOSAT REGULER 5K", "price": 6500},
    {"id": "H10", "label": "INDOSAT REGULER 10K", "price": 10500},
    {"id": "H12", "label": "INDOSAT REGULER 12K", "price": 12200},
    {"id": "H20", "label": "INDOSAT REGULER 20K", "price": 20600},
    {"id": "H25", "label": "INDOSAT REGULER 25K", "price": 25300},
    {"id": "H40", "label": "INDOSAT REGULER 40K", "price": 40400},
    {"id": "H50", "label": "INDOSAT REGULER 50K", "price": 50100},
    {"id": "H100", "label": "INDOSAT REGULER 100K", "price": 100500},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconItem = ModalRoute.of(context)!.settings.arguments as IconItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(iconItem.filename),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Input Nomor
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nomor Tujuan"),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: selectedNomor),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: const Icon(Icons.contact_page),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("CEK NOMOR"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tabbar
          TabBar(
            controller: _tabController,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: const [
              Tab(text: "PULSA"),
              Tab(text: "PAKET DATA"),
            ],
          ),

          // Isi Tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab Pulsa
                ListView.builder(
                  itemCount: pulsaList.length,
                  itemBuilder: (context, index) {
                    final pulsa = pulsaList[index];
                    final bool isSelected = selectedPulsaId == pulsa["id"];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPulsaId = pulsa["id"];
                          selectedPrice = pulsa["price"].toDouble();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected ? Colors.orange : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? Colors.orange
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pulsa["label"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              pulsa["price"].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Tab Paket Data (kosong dulu)
                const Center(child: Text("Paket Data belum tersedia")),
              ],
            ),
          ),
        ],
      ),

      // Bottom Total
      bottomNavigationBar: selectedPulsaId != null
          ? Container(
              color: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Rp ${selectedPrice.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final selectedPulsa = pulsaList.firstWhere(
                        (p) => p["id"] == selectedPulsaId,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KonfirmasiPembayaranPage(
                            nomorTujuan: selectedNomor,
                            kodeProduk: selectedPulsa["id"],
                            namaProduk: selectedPulsa["label"],
                            total: selectedPulsa["price"].toDouble(),
                            saldo: 100000000,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      pulsaList.firstWhere(
                        (p) => p["id"] == selectedPulsaId,
                      )["label"],
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
