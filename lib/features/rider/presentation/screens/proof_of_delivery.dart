import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';

class ProofOfDeliveryScreen extends StatefulWidget {
  final String deliveryId;
  const ProofOfDeliveryScreen({super.key, required this.deliveryId});

  @override
  State<ProofOfDeliveryScreen> createState() => _ProofOfDeliveryScreenState();
}

class _ProofOfDeliveryScreenState extends State<ProofOfDeliveryScreen> {
  final _receiverNameController = TextEditingController();
  String? _capturedPhotoPath; // TODO: populate via image_picker
  List<Offset> _signaturePoints = []; // simplified — see note below

  // TODO: replace with real delivery data via widget.deliveryId
  final String orderId = 'VF-90210';
  final double weightKg = 12.4;

  @override
  void dispose() {
    _receiverNameController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    // TODO: wire up image_picker camera capture
  }

  void _clearSignature() {
    setState(() => _signaturePoints = []);
  }

  void _submitProof() {
    if (_capturedPhotoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo capture is required')),
      );
      return;
    }
    // TODO: upload photo + signature to Firebase Storage, write proofOfDelivery to Firestore,
    // set delivery status to 'delivered'
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Proof of Delivery', style: textTheme.headlineMedium),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Complete Delivery', style: AppFonts.headlineLarge),
          SizedBox(height: 2),
          Text('Order #$orderId • ${weightKg}kg', style: AppFonts.bodySmall),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Capture Photo', style: AppFonts.titleLarge),
              Text(
                'Required',
                style: textTheme.labelSmall?.copyWith(color: AppColors.error),
              ),
            ],
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: _capturePhoto,
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                image: _capturedPhotoPath != null
                    ? DecorationImage(
                        image: AssetImage(_capturedPhotoPath!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _capturedPhotoPath == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 32,
                            color: AppColors.onSurfaceVariant,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap to capture photo',
                            style: AppFonts.bodySmall,
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Ensure the parcel and house number are clearly visible.',
            style: AppFonts.labelSmall,
          ),
          SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Receiver Signature', style: AppFonts.titleLarge),
              GestureDetector(
                onTap: _clearSignature,
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 14, color: colorScheme.secondary),
                    SizedBox(width: 4),
                    Text(
                      'Clear',
                      style: AppFonts.labelSmall.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceVariant),
            ),
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(
                  () => _signaturePoints = [
                    ..._signaturePoints,
                    details.localPosition,
                  ],
                );
              },
              child: CustomPaint(
                painter: _SignaturePainter(_signaturePoints),
                child: _signaturePoints.isEmpty
                    ? Center(
                        child: Text(
                          'Sign on the line above',
                          style: AppFonts.labelSmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(height: 20),

          Text('Receiver Name', style: AppFonts.titleSmall),
          SizedBox(height: 8),
          TextField(
            controller: _receiverNameController,
            decoration: InputDecoration(
              hintText: 'e.g., Jonathan Doe',
              filled: true,
              fillColor: colorScheme.surfaceContainerLow,
            ),
          ),
          SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submitProof,
              icon: Icon(
                Icons.check_circle_outline,
                size: 18,
                color: colorScheme.surfaceBright,
              ),
              label: Text(
                'Submit Proof',
                style: AppFonts.labelLarge.copyWith(color: colorScheme.surfaceBright),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              'This action will finalize the delivery status.',
              style: AppFonts.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset> points;
  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.onSurface
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
