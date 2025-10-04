import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helper/constant_finals.dart';
import '../../core/helper/currency.dart';
import '../../core/helper/dynamic_app_page.dart';
import '../../core/utils/navigation_handler.dart';
import '../layanan/cubit/flow_cubit.dart';
import '../../core/utils/dialog.dart';
import 'contact_handler.dart';
import 'transaksi_cubit.dart';

class InputNomorTujuanPage extends StatefulWidget {
  const InputNomorTujuanPage({super.key});

  @override
  State<InputNomorTujuanPage> createState() => _InputNomorTujuanPageState();
}

class _InputNomorTujuanPageState extends State<InputNomorTujuanPage> {
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _bebasNominalController = TextEditingController();

  late final NavigationHandler navigationHandler;
  late final ContactFlowHandler handler;

  @override
  void initState() {
    super.initState();
    navigationHandler = NavigationHandler(context);
    handler = ContactFlowHandler(
      context: context,
      nomorController: _nomorController,
      setStateCallback: (fn) {
        if (mounted) {
          setState(fn);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaksi = context.read<TransaksiCubit>().getData();
    final sendTransaksi = context.read<TransaksiCubit>();
    final flowState = context.watch<FlowCubit>().state!;
    final int currentIndex = flowState.currentIndex;
    final List<AppPage> sequence = flowState.sequence;
    final bool isLastPage = currentIndex == sequence.length - 1;

    return WillPopScope(
      onWillPop: () async {
        if (flowState.currentIndex > 0) {
          navigationHandler.handleBackNavigation();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            "Input Nomor Tujuan",
            style: TextStyle(color: kWhite),
          ),
          leading: BackButton(
            onPressed: () {
              final flowCubit = context.read<FlowCubit>();
              if (flowCubit.state!.currentIndex > 0) {
                flowCubit.previousPage();
              }
              Navigator.pop(context);
            },
          ),
          backgroundColor: kOrange,
          iconTheme: const IconThemeData(color: kWhite),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _infoRow("Nama Produk", transaksi.namaProduk ?? ''),
                      const Divider(height: 24),
                      _infoRow(
                        "Total Pembayaran",
                        CurrencyUtil.formatCurrency(transaksi.total),
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Masukkan Nomor Tujuan"),
              const SizedBox(height: 8),

              TextField(
                controller: _nomorController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: "Input Nomor Tujuan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: kOrange),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: kOrange),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.contact_page),
                    onPressed: handler.pickContact,
                  ),
                ),
              ),

              SizedBox(height: Screen.kSize14),
              Visibility(
                visible: transaksi.bebasNominal == 1,
                child: const Text("Masukkan Bebas Nominal"),
              ),
              Visibility(
                visible: transaksi.bebasNominal == 1,
                child: SizedBox(height: Screen.kSize8),
              ),
              Visibility(
                visible: transaksi.bebasNominal == 1,
                child: TextField(
                  controller: _bebasNominalController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: "Input Bebas Nominal",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: kOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: kOrange),
                    ),
                    suffixIcon: const Icon(Icons.contact_page),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrange,
                  foregroundColor: kWhite,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_nomorController.text.isEmpty) {
                    showErrorDialog(context, "Nomor tujuan tidak boleh kosong");
                    return;
                  }
                  if (transaksi.bebasNominal == 1 &&
                      _bebasNominalController.text.isEmpty) {
                    showErrorDialog(
                      context,
                      "Bebas nominal tidak boleh kosong",
                    );
                    return;
                  }

                  //update data cubit
                  sendTransaksi.setTujuan(_nomorController.text);

                  if (!isLastPage) {
                    final nextPage =
                        flowState.sequence[flowState.currentIndex + 1];

                    context.read<FlowCubit>().nextPage();
                    Navigator.pushNamed(context, pageRoutes[nextPage]!);
                  } else {
                    Navigator.pushNamed(context, '/konfirmasiPembayaran');
                  }
                },
                child: const Text(
                  "Selanjutnya",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isTotal = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.right,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? Screen.kSize16 : Screen.kSize14,
              color: isTotal ? kOrange : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nomorController.dispose();
    _bebasNominalController.dispose();
    super.dispose();
  }
}
