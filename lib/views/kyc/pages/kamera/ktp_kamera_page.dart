import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../utils/cubit/kyc_helper_cubit.dart';
import '../../utils/ktp_capture_processor.dart';
import '../../widgets/kyc_kamera/widget_overlay_painter.dart';
import '../foto_ktp/verify_ktp_page.dart';

class KTPCameraPage extends StatefulWidget {
  const KTPCameraPage({super.key});

  @override
  State<KTPCameraPage> createState() => _KTPCameraPageState();
}

class _KTPCameraPageState extends State<KTPCameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isFlashOn = false;
  bool _isCapturing = false; // Untuk loading state saat proses crop

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _initializeControllerFuture = _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  // Fungsi untuk menghitung Frame Rect (digunakan di Painter dan saat Capture)
  Rect _calculateFrameRect(Size screenSize) {
    final double frameWidth = screenSize.width * 0.85;
    final double frameHeight = frameWidth / 1.58;
    final double frameLeft = (screenSize.width - frameWidth) / 2;
    final double frameTop = (screenSize.height - frameHeight) / 2;
    return Rect.fromLTWH(frameLeft, frameTop, frameWidth, frameHeight);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    // Kita hitung area frame di sini agar konsisten antara UI dan logic crop
    final Rect frameRectUI = _calculateFrameRect(screenSize);

    return Scaffold(
      backgroundColor: kBlack,
      body: Stack(
        children: [
          // 1. CAMERA PREVIEW
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  _controller != null &&
                  _controller!.value.isInitialized) {
                // Trik BoxFit.cover untuk memenuhi layar
                // PENTING: Ini menyebabkan sebagian area sensor terpotong secara visual.
                return SizedBox(
                  width: screenSize.width,
                  height: screenSize.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!
                          .value
                          .previewSize!
                          .height, // Tukar W/H karena orientasi portrait
                      height: _controller!.value.previewSize!.width,
                      child: CameraPreview(_controller!),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
            },
          ),

          // 2. OVERLAY FRAME (Menggunakan rect yang sudah dihitung)
          Positioned.fill(
            child: CustomPaint(
              painter: KTPOverlayPainter(frameRect: frameRectUI),
            ),
          ),

          // 3. UI CONTROLS & LOADING
          SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Foto Kartu Identitas",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: .w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        "Pastikan bahwa foto E-KTP kamu jelas dan berada pada batas foto yang disediakan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Bottom Buttons
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 40.0,
                        left: 24,
                        right: 24,
                      ),
                      child: Row(
                        mainAxisAlignment: .spaceEvenly,
                        children: [
                          const SizedBox(width: 48), // Spacer
                          // --- SHUTTER BUTTON DENGAN LOGIC CROP ---
                          GestureDetector(
                            onTap: _isCapturing
                                ? null
                                : () async {
                                    await handleCaptureProcess(
                                      screenSize,
                                      frameRectUI,
                                    );
                                  },
                            child: Opacity(
                              opacity: _isCapturing ? 0.5 : 1.0,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: .circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: .circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Flash Button
                          SizedBox(
                            width: 48,
                            child: IconButton(
                              onPressed: () async {
                                setState(() => _isFlashOn = !_isFlashOn);
                                await _controller?.setFlashMode(
                                  _isFlashOn ? FlashMode.torch : FlashMode.off,
                                );
                              },
                              icon: Icon(
                                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                                color: _isFlashOn
                                    ? Colors.orange
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Loading Indicator saat proses crop
                if (_isCapturing)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.orange),
                          SizedBox(height: 16),
                          Text(
                            "Memproses gambar...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CORE LOGIC: CAPTURE & CALCULATE CROP ---
  Future<void> handleCaptureProcess(Size screenSize, Rect frameRectUI) async {
    setState(() => _isCapturing = true);

    try {
      final croppedImagePath = await KTPCaptureProcessor.processCapture(
        controller: _controller!,
        initializeControllerFuture: _initializeControllerFuture!,
        isFlashOn: _isFlashOn,
        screenSize: screenSize,
        frameRectUI: frameRectUI,
        onFlashOff: () {
          if (mounted) setState(() => _isFlashOn = false);
        },
      );

      if (!mounted) return;

      setState(() => _isCapturing = false);

      //setter
      context.read<KYCHelperCubit>().setFotoKTP(croppedImagePath);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => KTPVerifyPage(imagePath: croppedImagePath),
        ),
      );
    } catch (e) {
      debugPrint("Error during capture/crop: $e");

      if (!mounted) return;

      setState(() => _isCapturing = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memproses gambar: $e")));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
