import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/data/services/api_service.dart';
import 'package:xmlapp/core/helper/auth_guard.dart';
import 'package:xmlapp/views/settings/cubit/info_akun/info_akun_cubit.dart';
import '../../../core/helper/constant_finals.dart';
import '../cubit/edit_info_akun/edit_info_akun_cubit.dart';
import '../pages/edit_info_akun.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isNavigate;

  DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isNavigate = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isNavigate
          ? () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => EditInfoAkunCubit(ApiService()),
                    child: AuthGuard(child: EditInfoAkunScreen(label, value)),
                  ),
                ),
              );

              if (result == true && context.mounted) {
                context.read<InfoAkunCubit>().getInfoAkun();
              }
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: kBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),

            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: kBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            isNavigate ? Icon(Icons.navigate_next_rounded) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
