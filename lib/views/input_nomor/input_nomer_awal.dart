import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helper/constant_finals.dart';
import '../../core/helper/dynamic_app_page.dart';
import '../../data/models/transaksi/transaksi_helper.dart';
import '../layanan/cubit/flow_cubit.dart';
import '../../core/utils/dialog.dart';
import 'contact_handler.dart';
import 'transaksi_cubit.dart';

class InputNomorPage extends StatefulWidget {
  const InputNomorPage({super.key});

  @override
  State<InputNomorPage> createState() => _InputNomorPageState();
}

class _InputNomorPageState extends State<InputNomorPage> {
  final TextEditingController _nomorController = TextEditingController();

  late final ContactFlowHandler handler;

  @override
  void initState() {
    super.initState();
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
    final flowState = context.watch<FlowCubit>().state;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Input Nomor Tujuan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TransaksiCubit, TransaksiHelperModel>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (flowState!.currentIndex + 1 <
                        flowState.sequence.length) {
                      if (_nomorController.text.isEmpty) {
                        showErrorDialog(
                          context,
                          "Nomor tujuan tidak boleh kosong",
                        );
                        return;
                      }
                      final nextPage =
                          flowState.sequence[flowState.currentIndex + 1];
                      context.read<FlowCubit>().nextPage();

                      Navigator.pushNamed(context, pageRoutes[nextPage]!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Flow selesai")),
                      );
                    }
                  },
                  child: const Text(
                    "Selanjutnya",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomorController.dispose();
    super.dispose();
  }
}
