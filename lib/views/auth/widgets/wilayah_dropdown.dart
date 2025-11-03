import 'package:flutter/material.dart';
import '../../../core/helper/constant_finals.dart';
import '../../../data/models/user/region.dart';

class WilayahDropdowns extends StatelessWidget {
  final List<Region> provinsi;
  final List<Region> kabupaten;
  final List<Region> kecamatan;

  final String? selectedProvinsi;
  final String? selectedKabupaten;
  final String? selectedKecamatan;

  final ValueChanged<String?> onProvinsiChanged;
  final ValueChanged<String?> onKabupatenChanged;
  final ValueChanged<String?> onKecamatanChanged;

  const WilayahDropdowns({
    super.key,
    required this.provinsi,
    required this.kabupaten,
    required this.kecamatan,
    required this.selectedProvinsi,
    required this.selectedKabupaten,
    required this.selectedKecamatan,
    required this.onProvinsiChanged,
    required this.onKabupatenChanged,
    required this.onKecamatanChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _dropdownField(
          label: 'Provinsi',
          value: selectedProvinsi,
          items: provinsi,
          onChanged: onProvinsiChanged,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _dropdownField(
                label: 'Kabupaten',
                value: selectedKabupaten,
                items: kabupaten,
                onChanged: onKabupatenChanged,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _dropdownField(
                label: 'Kecamatan',
                value: selectedKecamatan,
                items: kecamatan,
                onChanged: onKecamatanChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dropdownField({
    required String label,
    required String? value,
    required List<Region> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: kNeutral80),
        floatingLabelStyle: TextStyle(color: kOrange),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: kOrangeAccent500),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: kOrangeAccent500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: kOrangeAccent500, width: 2),
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
              value: e.kode,
              child: Text(
                e.nama,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
