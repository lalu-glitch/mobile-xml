import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart'; // Import Package Baru
import 'package:path_provider/path_provider.dart';
import 'dart:math' as math;

class KTPCaptureProcessor {
  static Future<String> processCapture({
    required CameraController controller,
    required Future<void> initializeControllerFuture,
    required bool isFlashOn,
    required Size screenSize,
    required Rect frameRectUI,
    required void Function() onFlashOff,
  }) async {
    await initializeControllerFuture;

    // 1. AMBIL GAMBAR RAW (File JPG)
    final XFile rawImage = await controller.takePicture();

    if (isFlashOn) {
      onFlashOff();
      await controller.setFlashMode(FlashMode.off);
    }

    final File imageFile = File(rawImage.path);
    final Uint8List imageBytes = await imageFile.readAsBytes();

    // 2. DAPATKAN UKURAN GAMBAR (Tanpa Decode Full Bitmap ke Dart Heap)
    // Kita gunakan instantiateImageCodec dari dart:ui yang berjalan di Engine C++
    // Ini jauh lebih ringan daripada package:image
    final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    final double imgW = frameInfo.image.width.toDouble();
    final double imgH = frameInfo.image.height.toDouble();

    // Dispose frame agar memori segera lepas
    frameInfo.image.dispose();
    codec.dispose();

    // 3. HITUNG KOORDINAT CROP (Logic Matematika)
    // Logic ini sama persis dengan sebelumnya
    double scale;
    double offsetX = 0;
    double offsetY = 0;

    final screenRatio = screenSize.width / screenSize.height;
    final imgRatio = imgW / imgH;

    if (screenRatio > imgRatio) {
      scale = imgW / screenSize.width;
      final visualH = imgH / scale;
      offsetY = (visualH - screenSize.height) / 2 * scale;
    } else {
      scale = imgH / screenSize.height;
      final visualW = imgW / scale;
      offsetX = (visualW - screenSize.width) / 2 * scale;
    }

    final cropX = ((frameRectUI.left * scale) + offsetX).toInt();
    final cropY = ((frameRectUI.top * scale) + offsetY).toInt();
    final cropW = (frameRectUI.width * scale).toInt();
    final cropH = (frameRectUI.height * scale).toInt();

    // Clamping agar tidak error out of bounds
    final clampX = math.max(0, cropX);
    final clampY = math.max(0, cropY);
    final clampW = math.min(imgW.toInt() - clampX, cropW);
    final clampH = math.min(imgH.toInt() - clampY, cropH);

    // 4. LAKUKAN CROP SECARA NATIVE (Menggunakan image_editor)
    // Kita menyusun "Perintah" (Option) untuk dikirim ke Native
    final ImageEditorOption option = ImageEditorOption();

    // Tambahkan perintah Crop
    option.addOption(
      ClipOption(x: clampX, y: clampY, width: clampW, height: clampH),
    );

    // Eksekusi di Native (Output berupa bytes gambar baru)
    final Uint8List? result = await ImageEditor.editImage(
      image: imageBytes,
      imageEditorOption: option,
    );

    if (result == null) {
      throw Exception("Gagal melakukan cropping native");
    }

    // 5. SIMPAN HASIL KE FILE BARU
    final tempDir = await getTemporaryDirectory();
    final String newPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_cropped.jpg';
    final File resultFile = File(newPath);
    await resultFile.writeAsBytes(result);

    // Hapus file raw asli untuk hemat storage
    try {
      await imageFile.delete();
    } catch (_) {}

    return resultFile.path;
  }
}
