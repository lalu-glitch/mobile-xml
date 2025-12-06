import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/date_picker.dart';
import '../../../../core/utils/dialog.dart';
import '../../../settings/cubit/info_akun/info_akun_cubit.dart';
import '../../utils/cubit/kyc_helper_cubit.dart';
import '../../widgets/kyc_data_diri/widget__confirm_image_section.dart';
import '../../widgets/kyc_data_diri/widget_kyc_textfield.dart';
import '../../widgets/kyc_data_diri/widget_static_data.dart';
import '../../widgets/widget_header_step.dart';
import '../../widgets/widget_kyc_action_button.dart';
import '../../widgets/widget_secure_footer.dart';
import '../foto_ktp/foto_ktp_onboarding_page.dart';
import '../konfirmasi/confirm_kyc_page.dart';

class IsiDataDiriPage extends StatefulWidget {
  final bool isConfirm;
  final String? ktpImagePath;
  final String? selfieImagePath;

  const IsiDataDiriPage({
    super.key,
    this.isConfirm = false,
    this.ktpImagePath,
    this.selfieImagePath,
  });

  @override
  State<IsiDataDiriPage> createState() => _IsiDataDiriPageState();
}

class _IsiDataDiriPageState extends State<IsiDataDiriPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _nikController;

  DateTime? _selectedDate;
  String _kodeReseller = ''; // Cache kode reseller

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nikController = TextEditingController();

    if (widget.isConfirm) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final kyc = context.read<KYCHelperCubit>().state;
        _nameController.text = kyc.name ?? '';
        _nikController.text = kyc.nik ?? '';
        setState(() {
          _selectedDate = kyc.birthDate;
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final infoAkunState = context.read<InfoAkunCubit>().state;
    _kodeReseller = switch (infoAkunState) {
      InfoAkunLoaded s => s.data.data.kodeReseller,
      _ => '',
    };
  }

  bool _validateFormBeforeNavigate() {
    if (_nameController.text.isEmpty) {
      showErrorDialog(context, "Nama tidak boleh kosong");
      return false;
    }
    if (_nikController.text.length != 16) {
      showErrorDialog(context, "NIK harus terdiri dari 16 angka");
      return false;
    }
    if (_selectedDate == null) {
      showErrorDialog(context, "Tanggal lahir harus dipilih");
      return false;
    }
    return true;
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1915),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // Menggunakan Theme yang sudah ada, menghindari pembuatan object Theme berlebih
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kOrange,
              onPrimary: kWhite,
              onSurface: kBlack,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: kOrange),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kBlack),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const .symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  KYCHeader(
                    step: widget.isConfirm ? "4 dari 4" : "1 dari 4",
                    title: widget.isConfirm
                        ? "Cek Kembali Data Dirimu"
                        : "Informasi Data Diri Pengguna",
                  ),

                  const SizedBox(height: 32),

                  KYCReadOnlyField(label: "Merchant ID", value: _kodeReseller),

                  const SizedBox(height: 24),

                  KYCTextField(
                    label: "Nama Lengkap",
                    hint: "Nama Lengkapmu",
                    controller: _nameController,
                    inputType: TextInputType.name,
                  ),

                  const SizedBox(height: 24),

                  KYCTextField(
                    label: "Nomor Induk Kependudukan (NIK)",
                    hint: "xxxx xxxx xxxx xxxx",
                    controller: _nikController,
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                    ],
                  ),

                  const SizedBox(height: 24),

                  DatePicker(
                    label: "Tanggal Lahir",
                    hint: "Pilih",
                    selectedDate: _selectedDate,
                    onTap: _pickDate,
                  ),

                  const SizedBox(height: 40),

                  if (widget.isConfirm)
                    ConfirmImageSection(
                      ktpPath: context.read<KYCHelperCubit>().state.ktpPath,
                      selfiePath: context
                          .read<KYCHelperCubit>()
                          .state
                          .selfiePath,
                    ),

                  const SizedBox(height: 120),
                  const SecureFooter(),
                  const SizedBox(height: 50),
                  SafeArea(
                    child: KYCActionButton(
                      title: widget.isConfirm ? 'Kirim Data' : 'Selanjutnya',
                      onPressed: _onNextPressed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onNextPressed() {
    if (widget.isConfirm) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KonfirmasiKYCPage()),
      );
    } else {
      if (_validateFormBeforeNavigate()) {
        context.read<KYCHelperCubit>().setDataDiri(
          nama: _nameController.text,
          nik: _nikController.text,
          tanggalLahir: _selectedDate!,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FotoKTPOnboardingPage(),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    super.dispose();
  }
}
