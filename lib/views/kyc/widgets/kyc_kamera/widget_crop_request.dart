// Kelas data untuk dikirim ke Isolate
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img; // Import package image

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
  debugPrint("Isolate: Memulai proses crop...");

  // 1. Baca bytes gambar dari file
  final File originalFile = File(request.originalPath);
  final Uint8List bytes = await originalFile.readAsBytes();

  // 2. Decode gambar (package image menangani orientasi EXIF otomatis)
  img.Image? image = img.decodeImage(bytes);

  if (image == null) throw Exception("Isolate: Gagal decode gambar.");

  // 3. Lakukan Cropping
  // Gunakan copyCrop untuk performa lebih baik daripada crop langsung
  img.Image croppedImage = img.copyCrop(
    image,
    x: request.x,
    y: request.y,
    width: request.width,
    height: request.height,
  );

  // 4. Encode kembali ke JPEG (bisa juga PNG)
  // Kualitas 90 sudah cukup baik dan lebih kecil ukurannya
  final Uint8List croppedBytes = img.encodeJpg(croppedImage, quality: 90);

  // 5. Simpan ke file baru
  // Kita buat nama file baru dengan suffix _cropped
  final String newPath = request.originalPath.replaceFirst(
    '.jpg',
    '_cropped.jpg',
  );
  final File savedFile = await File(newPath).writeAsBytes(croppedBytes);

  debugPrint("Isolate: Selesai crop, disimpan di $newPath");
  return savedFile.path;
}
