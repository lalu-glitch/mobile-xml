import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/custom_textfield.dart';
import '../../../core/utils/dialog.dart';
import '../../../data/services/speedcash_api_service.dart';
import '../../../data/services/auth_service.dart';
import '../../settings/cubit/info_akun/info_akun_cubit.dart';
import '../cubit/speedcash_register_cubit.dart';

class SpeedcashRegisterPage extends StatefulWidget {
  const SpeedcashRegisterPage({super.key});

  @override
  State<SpeedcashRegisterPage> createState() => _SpeedcashRegisterPageState();
}

class _SpeedcashRegisterPageState extends State<SpeedcashRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;

  late final FocusNode _namaNode;
  late final FocusNode _phoneNode;
  late final FocusNode _emailNode;

  @override
  void initState() {
    super.initState();
    _namaCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _emailCtrl = TextEditingController();

    _namaNode = FocusNode();
    _phoneNode = FocusNode();
    _emailNode = FocusNode();
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _namaNode.dispose();
    _phoneNode.dispose();
    _emailNode.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    // Ambil data dari Cubit lain
    final infoAkunState = context.read<InfoAkunCubit>().state;
    final kodeReseller = switch (infoAkunState) {
      InfoAkunLoaded s => s.data.data.kodeReseller,
      _ => '',
    };

    FocusScope.of(context).unfocus();

    context.read<SpeedcashRegisterCubit>().speedcashRegister(
      nama: _namaCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      kodeReseller: kodeReseller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpeedcashRegisterCubit(
        SpeedcashApiService(authService: context.read<AuthService>()),
      ),
      child: BlocListener<SpeedcashRegisterCubit, SpeedcashRegisterState>(
        listener: (context, state) {
          if (state is SpeedcashRegisterError) {
            showErrorDialog(context, state.message);
          }
          if (state is SpeedcashRegisterSuccess) {
            final data = state.data;
            if (!context.mounted) return;
            Navigator.pushNamed(
              context,
              '/webviewSpeedcash',
              arguments: {
                'url': data.redirectUrl,
                'title': 'Registrasi Speedcash',
              },
            );
          }
        },
        child: Scaffold(
          backgroundColor: kOrange,
          appBar: AppBar(
            backgroundColor: kOrange,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: kWhite,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Buat Akun Baru',
              style: TextStyle(
                color: kWhite,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 30),
              // --- FORM SHEET ---
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Data Diri",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kBlack,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // INPUTS (Sama seperti sebelumnya)
                          FintechInputField(
                            controller: _namaCtrl,
                            focusNode: _namaNode,
                            label: "Nama Lengkap",
                            hint: "Sesuai KTP",
                            icon: Icons.person_outline_rounded,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).requestFocus(_phoneNode),
                            validator: (v) =>
                                (v?.isEmpty ?? true) ? "Wajib diisi" : null,
                          ),
                          const SizedBox(height: 20),

                          FintechInputField(
                            controller: _phoneCtrl,
                            focusNode: _phoneNode,
                            label: "Nomor Handphone",
                            hint: "0812xxxx",
                            icon: Icons.phone_iphone_rounded,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).requestFocus(_emailNode),
                            validator: (v) =>
                                (v?.isEmpty ?? true) ? "Wajib diisi" : null,
                          ),
                          const SizedBox(height: 20),

                          FintechInputField(
                            controller: _emailCtrl,
                            focusNode: _emailNode,
                            label: "Email",
                            hint: "nama@email.com",
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onSubmit(context),
                            validator: (v) => (v != null && v.contains('@'))
                                ? null
                                : "Email tidak valid",
                          ),

                          const SizedBox(height: 32),

                          // BUTTON
                          BlocBuilder<
                            SpeedcashRegisterCubit,
                            SpeedcashRegisterState
                          >(
                            builder: (context, state) {
                              final isLoading =
                                  state is SpeedcashRegisterLoading;
                              return SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => _onSubmit(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kOrange,
                                    foregroundColor: kWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: kWhite,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Text(
                                          "Daftar Sekarang",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
