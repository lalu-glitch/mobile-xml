import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../utils/cubit/kyc_helper_cubit.dart';
import '../selfie_ktp/verify_selfie_page.dart';

class KTPCameraSelfiePage extends StatefulWidget {
  const KTPCameraSelfiePage({super.key});

  @override
  State<KTPCameraSelfiePage> createState() => _KTPCameraSelfiePageState();
}

class _KTPCameraSelfiePageState extends State<KTPCameraSelfiePage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      // Mengambil kamera depan
      final firstCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _initializeControllerFuture = _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. CAMERA PREVIEW (FULL SCREEN IMMERSIVE)
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  _controller != null &&
                  _controller!.value.isInitialized) {
                // Trik agar CameraPreview memenuhi layar (Cover)
                // Ini mungkin memotong sedikit bagian preview secara visual agar full screen,
                // tapi hasil foto capture tetap utuh sesuai sensor kamera.
                return SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.previewSize!.height,
                      height: _controller!.value.previewSize!.width,
                      child: CameraPreview(_controller!),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: kWhite),
                );
              }
            },
          ),

          // 2. UI CONTROLS (Tanpa Overlay Painter)
          SafeArea(
            child: Column(
              children: [
                // Header (Back Button & Title)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: kWhite),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Foto Selfie",
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Instruksi Sederhana
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    "Pastikan wajahmu terlihat jelas dan pencahayaan cukup",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Shutter Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: GestureDetector(
                    onTap: _isCapturing ? null : _takePicture,
                    child: Opacity(
                      opacity: _isCapturing ? 0.5 : 1.0,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kWhite, width: 5),
                          color: kWhite.withAlpha(50), // Semi-transparent fill
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Loading Indicator saat Capture
          if (_isCapturing)
            Container(
              color: kBlack,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _takePicture() async {
    setState(() => _isCapturing = true);
    try {
      await _initializeControllerFuture;
      // Ambil gambar
      final XFile image = await _controller!.takePicture();
      if (!mounted) return;

      setState(() => _isCapturing = false);
      //setter
      context.read<KYCHelperCubit>().setFotoSelfie(image.path);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => KTPSelfieVerifyPage(imagePath: image.path),
        ),
      );
    } catch (e) {
      debugPrint("Error taking picture: $e");
      if (mounted) {
        setState(() => _isCapturing = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal mengambil foto: $e")));
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
