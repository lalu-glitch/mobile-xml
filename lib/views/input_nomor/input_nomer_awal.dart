import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/data/models/transaksi/transaksi_helper_model.dart';

import '../../core/helper/dynamic_app_page.dart';
import '../../core/helper/flow_cubit.dart';
import 'transaksi_cubit.dart';

class InputNomorPage extends StatefulWidget {
  const InputNomorPage({super.key});

  @override
  State<InputNomorPage> createState() => _InputNomorPageState();
}

class _InputNomorPageState extends State<InputNomorPage> {
  final TextEditingController _nomorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // // Ambil arguments dari Navigator
    // final args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // final sequence = args['sequence'] as List<AppPage>;
    // final currentIndex = args['currentIndex'] as int;
    // final flow = args['flow'];

    final flowState = context.watch<FlowCubit>().state;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Input Nomor Tujuan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF6D00),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TransaksiCubit, TransaksiModel>(
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
                    suffixIcon: const Icon(Icons.contact_page),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6D00),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // cek kalau masih ada halaman berikutnya
                    if (flowState!.currentIndex + 1 <
                        flowState.sequence.length) {
                      final nextPage =
                          flowState.sequence[flowState.currentIndex + 1];

                      // update state FlowCubit (naik 1 index)
                      context.read<FlowCubit>().nextPage();

                      Navigator.pushNamed(context, pageRoutes[nextPage]!);
                    } else {
                      // sudah halaman terakhir -> lakukan action (misal submit)
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
}
