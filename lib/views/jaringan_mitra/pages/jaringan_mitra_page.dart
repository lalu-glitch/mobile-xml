import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/search_appbar_actions.dart';
import '../../poin_dan_komisi/pages/komisi/widgets/downline_widget_card.dart';
import '../widgets/sum_data_and_filter.dart';

class JaringanMitraPage extends StatefulWidget {
  const JaringanMitraPage({super.key});

  @override
  State<JaringanMitraPage> createState() => _JaringanMitraPageState();
}

class _JaringanMitraPageState extends State<JaringanMitraPage> {
  final searchController = TextEditingController();
  bool isSearching = false;
  String _currentSort = 'Terbaru';

  void onClearText() {
    setState(() {
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isSearching ? false : true,
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: TextStyle(color: kWhite),
                decoration: InputDecoration(
                  hintText: 'Cari mitra',
                  hintStyle: TextStyle(color: kWhite.withAlpha(200)),
                  border: InputBorder.none,
                ),
              )
            : Text('List Jaringan Mitra', style: TextStyle(color: kWhite)),
        backgroundColor: kOrange,
        iconTheme: IconThemeData(color: kWhite),
        actions: [
          SearchAppBar(
            isSearching: isSearching,
            onSearchChanged: (value) => setState(() => isSearching = value),
            onClear: onClearText,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(color: kOrange),
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 100),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: kBackground),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          DataListHeader(
                            totalData: 48,
                            selectedSortOption: _currentSort,
                            onSortChanged: (newValue) {
                              setState(() {
                                _currentSort = newValue!;
                              });
                            },
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              return DownlineCard();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const MitraStatusCard(activeCount: 43, blockedCount: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Kartu yang Menampilkan Status Jaringan Mitra
class MitraStatusCard extends StatelessWidget {
  final int activeCount;
  final int blockedCount;

  const MitraStatusCard({
    super.key,
    required this.activeCount,
    required this.blockedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 0,
      right: 0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kSize16),

        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kSize16 / 2),
          ),
          margin: EdgeInsets.zero,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: kSize16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatusItem(
                    title: 'Jaringan Mitra Aktif',
                    count: activeCount,
                    backgroundColor: kGreen.withAlpha(64),
                    textColor: kGreen, // Text hijau gelap
                  ),
                ),

                Container(height: 84, width: 2, color: kNeutral50),

                Expanded(
                  child: _buildStatusItem(
                    title: 'Jaringan Mitra Terblokir',
                    count: blockedCount,
                    backgroundColor: kRed.withAlpha(64),
                    textColor: kRed, // Text merah gelap
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method untuk membangun setiap item status
  Widget _buildStatusItem({
    required String title,
    required int count,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: kBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
