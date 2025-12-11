import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../poin_dan_komisi/pages/komisi/widgets/downline_widget_card.dart';
import '../widgets/widget_sum_data_and_filter.dart';

class JaringanMitraPage extends StatefulWidget {
  const JaringanMitraPage({super.key});

  @override
  State<JaringanMitraPage> createState() => _JaringanMitraPageState();
}

class _JaringanMitraPageState extends State<JaringanMitraPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isSearching = false;
  String _currentSort = 'Terbaru';

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),

          SliverToBoxAdapter(
            child: MitraStatsHeader(activeCount: 43, blockedCount: 5),
          ),

          SliverToBoxAdapter(
            child: FilterSection(
              totalData: 48,
              currentSort: _currentSort,
              onSortChanged: (val) => setState(() => _currentSort = val!),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return const DownlineCard();
              }, childCount: 15),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: kOrange,
      pinned: true,
      floating: true,
      elevation: 0,
      leading: _isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: kWhite),
              onPressed: _toggleSearch,
            )
          : const BackButton(color: kWhite),
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: kWhite, fontSize: 16),
              cursorColor: kWhite,
              decoration: InputDecoration(
                hintText: 'Cari nama mitra...',
                hintStyle: TextStyle(color: kWhite.withAlpha(180)),
                border: InputBorder.none,
                isDense: true,
              ),
            )
          : const Text(
              'Jaringan Mitra',
              style: TextStyle(
                color: kWhite,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
      actions: [
        if (!_isSearching)
          IconButton(
            icon: const Icon(Icons.search, color: kWhite),
            onPressed: _toggleSearch,
            tooltip: 'Cari Mitra',
          ),
        if (_isSearching)
          IconButton(
            icon: const Icon(Icons.close, color: kWhite),
            onPressed: () => _searchController.clear(),
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
