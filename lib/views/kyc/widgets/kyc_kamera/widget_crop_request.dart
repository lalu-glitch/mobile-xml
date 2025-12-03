// Kelas data untuk dikirim ke Isolate
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_editor/image_editor.dart';

class CropRequest {
  final String originalPath;
  final int x, y, width, height;
  CropRequest({
    required this.originalPath,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}

// Fungsi statis murni untuk dijalankan di Isolate
Future<String> cropImageIsolate(CropRequest request) async {
  log("Isolate: Memulai proses crop...");

  // 1. Baca file gambar asli
  final File originalFile = File(request.originalPath);
  //log ukuran original file
  log("Isolate: Ukuran file asli: ${await originalFile.length()} bytes");

  if (!await originalFile.exists()) {
    throw Exception("Isolate: File asli tidak ditemukan.");
  }

  // 2. Konfigurasi editor dengan crop option
  final ImageEditorOption option = ImageEditorOption()
    ..addOption(
      ClipOption(
        x: request.x,
        y: request.y,
        width: request.width,
        height: request.height,
      ),
    )
    ..outputFormat = const OutputFormat.jpeg(
      95,
    ); // Quality 95 untuk JPEG (bisa diubah ke PNG jika perlu)

  // 3. Edit gambar (native processing: decode, crop, encode otomatis)
  final Uint8List? croppedBytes = await ImageEditor.editFileImage(
    file: originalFile,
    imageEditorOption: option,
  );

  if (croppedBytes == null) {
    throw Exception("Isolate: Gagal proses crop gambar.");
  }

  // 4. Simpan ke file baru
  final String newPath = request.originalPath.replaceFirst(
    '.jpg',
    '_cropped.jpg',
  );
  final File savedFile = await File(newPath).writeAsBytes(croppedBytes);

  log("Isolate: Selesai crop, disimpan di $newPath");
  //log ukuran file crop
  log("Isolate: Ukuran file crop: ${await savedFile.length()} bytes");
  return savedFile.path;
}
