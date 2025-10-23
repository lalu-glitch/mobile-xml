import 'package:flutter/material.dart';
import 'package:xmlapp/core/helper/constant_finals.dart';
import 'package:xmlapp/core/utils/dialog.dart';

class EditInfoAkunScreen extends StatefulWidget {
  const EditInfoAkunScreen({super.key});

  @override
  State<EditInfoAkunScreen> createState() => _EditInfoAkunScreenState();
}

class _EditInfoAkunScreenState extends State<EditInfoAkunScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _editCtrl = TextEditingController();

  String _appBarTitle = 'Edit Info Akun';
  String _initialValue = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Ambil arguments setelah frame pertama selesai dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        setState(() {
          _appBarTitle = 'Edit ${args['label']}';
          _initialValue = args['value'] ?? '';
          _editCtrl.text = _initialValue;
        });

        print(_appBarTitle);
        print(_initialValue);
      }
    });
  }

  @override
  void dispose() {
    _editCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveInfo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // --- Simulasi Panggilan API ---
    await Future.delayed(const Duration(seconds: 2));
    final newValue = _editCtrl.text;
    // --- Akhir Simulasi ---

    // Penting: Cek 'mounted' sebelum berinteraksi dengan context
    // setelah operasi async
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    showAppToast(context, 'Info Akun berhasil diperbarui!', ToastType.success);
    Navigator.of(context).pop(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
        backgroundColor: kOrange,
        foregroundColor: kWhite,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _editCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan info baru',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: kOrange, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Info Akun tidak boleh kosong';
                    }
                    return null; // Valid
                  },
                  autofocus: true,
                ),
              ],
            ),
          ),

          // 2. Beri jarak antara form dan tombol
          const SizedBox(height: 32),

          // 3. Tombol Simpan sebagai ElevatedButton
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kOrange, // Warna primer
                foregroundColor: kWhite, // Warna teks
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // 4. Nonaktifkan tombol saat loading
              onPressed: _isLoading ? null : _saveInfo,
              child: _isLoading
                  // 5. Tampilkan loading indicator di dalam tombol
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: kWhite,
                        strokeWidth: 2,
                      ),
                    )
                  // 6. Teks tombol
                  : const Text(
                      'SIMPAN PERUBAHAN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
