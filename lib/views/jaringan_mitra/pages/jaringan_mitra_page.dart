import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/search_appbar_actions.dart';
import '../../poin_dan_komisi/pages/komisi/widgets/downline_widget_card.dart';
import '../widgets/mitra_status_card.dart';
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
