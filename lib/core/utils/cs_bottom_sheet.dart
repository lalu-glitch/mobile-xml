import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
