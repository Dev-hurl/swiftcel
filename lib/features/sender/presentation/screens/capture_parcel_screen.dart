import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';
import 'package:swiftcel/features/sender/presentation/screens/parcel_measurement_sheet.dart';

class CaptureParcelScreen extends StatefulWidget {
  const CaptureParcelScreen({super.key});

  @override
  State<CaptureParcelScreen> createState() => _CaptureParcelScreenState();
}

class _CaptureParcelScreenState extends State<CaptureParcelScreen> {
  bool _flashOn = false;

  Future<void> _capture() async {
    // TODO: wire up camera package (camera / image_picker) for real photo capture.
    // Currently opens the mock measurement sheet regardless of any real image.
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ParcelMeasurementSheet(),
    );

    if (result == true && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 16),
        centerTitle: true,
        backgroundColor: colorScheme.onSurfaceVariant,
        leading: BackButton(color: colorScheme.surfaceBright,),
        title: Text(
          'Capture Parcel',
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.surfaceBright,
          ),
        ),
        actions: [
          _CircleIconButton(
            icon: _flashOn ? Icons.flash_on : Icons.flash_off,
            onTap: () => setState(() => _flashOn = !_flashOn),
          ),
        ],
      ),
      body: Stack(
        children: [
          // TODO: replace with real CameraPreview widget once camera package is wired
          Container(
            color: colorScheme.onSurface,
            child: Center(
              child: Icon(
                Icons.camera_alt_outlined,
                size: 48,
                color: colorScheme.surfaceBright,
              ),
            ),
          ),

          

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: Size(260, 260),
                  painter: _CornerFramePainter(),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: colorScheme.surfaceBright,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Center the parcel in the frame',
                        style: AppFonts.labelSmall.copyWith(
                          color: colorScheme.surfaceBright,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleIconButton(
                      icon: Icons.inventory_2_outlined,
                      onTap: () {
                        // TODO: manual entry fallback — skip capture, go straight to form fields
                      },
                    ),
                    GestureDetector(
                      onTap: _capture,
                      child: Container(
                        height: 72,
                        width: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surfaceBright,
                            width: 4,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _CircleIconButton(
                      icon: Icons.auto_awesome_outlined,
                      onTap: () {
                        // TODO: toggle assist/guide overlay, if ever built
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: colorScheme.surfaceBright, size: 18),
      ),
    );
  }
}

class _CornerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.orangeSecondary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 28.0;
    final w = size.width;
    final h = size.height;

    // Top-left
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint);
    // Top-right
    canvas.drawLine(Offset(w, 0), Offset(w - cornerLength, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, cornerLength), paint);
    // Bottom-left
    canvas.drawLine(Offset(0, h), Offset(cornerLength, h), paint);
    canvas.drawLine(Offset(0, h), Offset(0, h - cornerLength), paint);
    // Bottom-right
    canvas.drawLine(Offset(w, h), Offset(w - cornerLength, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
