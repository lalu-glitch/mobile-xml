import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant_finals.dart';

Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

void showCSBottomSheet(BuildContext context, String title) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // CS WA
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: const Icon(Icons.phone, color: Colors.green),
                ),
                title: const Text(
                  "WhatsApp CS 1",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text("+62 823 2929 9971"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _launchUrl("https://wa.me/6282329299971"),
              ),
            ),

            const SizedBox(height: 8),

            // CS Telegram
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: const Icon(Icons.telegram, color: Colors.blue),
                ),
                title: const Text(
                  "Telegram CS 2",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text("@cs2_XMLtronik"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _launchUrl("https://t.me/cs2_XMLtronik"),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}

void showUnbindBottomSheet(BuildContext context, VoidCallback onUnbindPressed) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24), // Tambah padding menyeluruh
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // Pastikan anak-anak mengambil lebar penuh
          children: [
            Icon(
              Icons.warning_rounded, // Tambah ikon untuk visualisasi peringatan
              color: kRed,
              size: Screen.kSize48,
            ),
            const SizedBox(height: 16),
            Text(
              'Unbind Akun SpeedCash',
              style: Styles.kNunitoSemiBold.copyWith(
                color: Colors.black,
                fontSize: Screen.kSize20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Apakah Anda yakin ingin melepas akun SpeedCash Anda?',
              style: Styles.kNunitoMedium.copyWith(
                color: Colors.grey,
                fontSize: Screen.kSize16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                onUnbindPressed();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kRed, // Warna tombol merah yang lebih tegas
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Ya, Unbind',
                style: Styles.kNunitoMedium.copyWith(
                  color: kWhite,
                  fontSize: Screen.kSize16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Batal',
                style: Styles.kNunitoMedium.copyWith(
                  color: Colors.grey,
                  fontSize: Screen.kSize16,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void verifyLogOut(BuildContext context, VoidCallback onConfirm) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24), // Tambah padding menyeluruh
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // Pastikan anak-anak mengambil lebar penuh
          children: [
            Icon(
              Icons.do_disturb_on_rounded,
              color: kRed,
              size: Screen.kSize48,
            ),
            const SizedBox(height: 16),
            Text(
              'Keluar',
              style: Styles.kNunitoSemiBold.copyWith(
                color: Colors.black,
                fontSize: Screen.kSize20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Apakah Anda yakin ingin Keluar dari aplikasi?',
              style: Styles.kNunitoMedium.copyWith(
                color: Colors.grey,
                fontSize: Screen.kSize16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Ya, Keluar',
                style: Styles.kNunitoMedium.copyWith(
                  color: kWhite,
                  fontSize: Screen.kSize16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Batal',
                style: Styles.kNunitoMedium.copyWith(
                  color: Colors.grey,
                  fontSize: Screen.kSize16,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
