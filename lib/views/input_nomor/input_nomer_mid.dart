import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helper/dynamic_app_page.dart';
import '../layanan/cubit/flow_cubit.dart';
import '../../core/utils/error_dialog.dart';

class InputNomorMidPage extends StatefulWidget {
  const InputNomorMidPage({super.key});

  @override
  State<InputNomorMidPage> createState() => _InputNomorPageState();
}

class _InputNomorPageState extends State<InputNomorMidPage> {
  final TextEditingController _nomorController = TextEditingController();

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
        backgroundColor: const Color(0xFFFF6D00),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                if (flowState!.currentIndex + 1 < flowState.sequence.length) {
                  if (_nomorController.text.isEmpty) {
                    showErrorDialog(context, "Nomor tujuan tidak boleh kosong");
                    return;
                  }
                  final nextPage =
                      flowState.sequence[flowState.currentIndex + 1];

                  context.read<FlowCubit>().nextPage();

                  Navigator.pushNamed(context, pageRoutes[nextPage]!);
                } else {
                  // sudah halaman terakhir -> lakukan action (misal submit)
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Flow selesai")));
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
    );
  }
}
