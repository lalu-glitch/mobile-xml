import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/error_handler.dart';
import '../../poin_dan_komisi/pages/komisi/widgets/downline_widget_card.dart';
import '../../settings/cubit/info_akun/info_akun_cubit.dart';
import '../cubit/list_mitra_cubit.dart';
import '../cubit/mitra_stats_cubit.dart';
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
  String _kodeReseller = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final infoAkunState = context.read<InfoAkunCubit>().state;
    _kodeReseller = switch (infoAkunState) {
      InfoAkunLoaded s => s.data.data.kodeReseller,
      _ => '',
    };
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) _searchController.clear();
    });
  }

  void _fetchDataListMitra() {
    context.read<ListMitraCubit>().fetchMitraList(_kodeReseller);
  }

  void _fetchDataStatsMitra() {
    context.read<MitraStatsCubit>().loadMitraStats(_kodeReseller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),

          BlocBuilder<MitraStatsCubit, MitraStatsState>(
            builder: (context, state) {
              if (state is MitraStatsInitial) {
                _fetchDataStatsMitra();
              }
              if (state is MitraStatsLoading) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: kOrange,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                );
              }
              if (state is MitraStatsLoaded) {
                return SliverToBoxAdapter(
                  child: MitraStatsHeader(
                    activeCount: state.stats.downlineAktif,
                    blockedCount: state.stats.downlineSuspend,
                  ),
                );
              }
              if (state is MitraStatsError) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ErrorHandler(
                      message: "Ada yang salah!",
                      onRetry: _fetchDataStatsMitra,
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),

          BlocBuilder<ListMitraCubit, ListMitraState>(
            builder: (context, state) {
              if (state is ListMitraInitial) {
                _fetchDataListMitra();
              }
              if (state is ListMitraLoading) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: kOrange,
                      strokeWidth: 3,
                    ),
                  ),
                );
              }
              if (state is ListMitraLoaded) {
                return SliverMainAxisGroup(
                  slivers: [
                    SliverToBoxAdapter(
                      child: FilterSection(
                        totalData: state.mitraList.length,
                        currentSort: _currentSort,
                        onSortChanged: (val) =>
                            setState(() => _currentSort = val!),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return DownlineCard(mitra: state.mitraList[index]);
                        }, childCount: state.mitraList.length),
                      ),
                    ),
                  ],
                );
              }
              if (state is ListMitraError) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: SizedBox(
                      child: ErrorHandler(
                        message: "Ada yang salah!",
                        onRetry: _fetchDataListMitra,
                      ),
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
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

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
