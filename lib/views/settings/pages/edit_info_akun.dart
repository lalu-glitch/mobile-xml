import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- Impor untuk InputFormatter
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../cubit/edit_info_akun/edit_info_akun_cubit.dart';

class EditInfoAkunScreen extends StatefulWidget {
  const EditInfoAkunScreen(this.label, this.value, {super.key});
  final String label;
  final String value;

  @override
  State<EditInfoAkunScreen> createState() => _EditInfoAkunScreenState();
}

class _EditInfoAkunScreenState extends State<EditInfoAkunScreen> {
  final _formKey = GlobalKey<FormState>();
  final _editCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editCtrl.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.label}'),
        backgroundColor: kOrange,
        foregroundColor: kWhite,
      ),
      body: BlocConsumer<EditInfoAkunCubit, EditInfoAkunState>(
        listener: (context, state) {
          if (state is EditInfoAkunSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.data.message)));
            Navigator.pop(context, true);
          } else if (state is EditInfoAkunError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is EditInfoAkunLoading;

          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
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
                  autofocus: true,
                  keyboardType: widget.label == 'Markup Referral'
                      ? TextInputType.number
                      : TextInputType.text,
                  inputFormatters: widget.label == 'Markup Referral'
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : [],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Info Akun tidak boleh kosong';
                    }
                    if (widget.label == 'Markup Referral' &&
                        int.tryParse(value) == null) {
                      return 'Markup harus berupa angka';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: kWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.label == 'Markup Referral') {
                              final value = int.parse(_editCtrl.text);
                              context
                                  .read<EditInfoAkunCubit>()
                                  .updateMarkupReferral(value);
                            } else {
                              // nanti untuk nama / kode referral
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Fitur ini belum tersedia untuk label ini.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _editCtrl.dispose();
    super.dispose();
  }
}
