import 'package:flutter/material.dart';
import 'package:swiftcel/core/constants/app_colors.dart';
import 'package:swiftcel/core/constants/app_fonts.dart';

enum VerificationStatus { pendingReview, verified, actionNeeded }

enum VehicleType { sedanHatchback, motorcycle, bicycle, van }

class DocumentVerification extends StatefulWidget {
  const DocumentVerification({super.key});

  @override
  State<DocumentVerification> createState() => _DocumentVerificationState();
}

class _DocumentVerificationState extends State<DocumentVerification> {
  final VerificationStatus _status = VerificationStatus.pendingReview;
  VehicleType _selectedVehicle = VehicleType.sedanHatchback;
  final _licensePlateController = TextEditingController();

  String? _frontIdPath; // TODO: populate via image_picker
  String? _backIdPath;
  String? _insuranceDocPath;

  @override
  void dispose() {
    _licensePlateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(void Function(String) onPicked) async {
    // TODO: wire up image_picker — pick from camera or gallery, call onPicked(pickedFile.path)
  }

  Future<void> _pickDocument() async {
    // TODO: wire up file_picker for insurance PDF/image, enforce 5MB max size client-side before upload
  }

  void _updateDocuments() {
    // TODO: upload files to Firebase Storage, write metadata to Firestore rider doc,
    // set verificationStatus back to 'pendingReview', notify user of 24-48hr window
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification & Vehicle', style: AppFonts.headlineMedium),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 10),
          _StatusChip(status: _status),
          SizedBox(height: 20),

          Row(
            children: [
              Icon(
                Icons.badge_outlined,
                color: AppColors.orangeSecondary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text('Identity Verification', style: AppFonts.titleLarge),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Upload a clear photo of your government-issued ID card (front and back).',
            style: AppFonts.bodySmall,
          ),
          SizedBox(height: 16),
          _UploadBox(
            label: 'Front of ID',
            filePath: _frontIdPath,
            onTap: () =>
                _pickImage((path) => setState(() => _frontIdPath = path)),
          ),
          const SizedBox(height: 12),
          _UploadBox(
            label: 'Back of ID',
            filePath: _backIdPath,
            onTap: () =>
                _pickImage((path) => setState(() => _backIdPath = path)),
          ),
          SizedBox(height: 24),

          Row(
            children: [
              const Icon(
                Icons.electric_moped_outlined,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('Vehicle Info', style: AppFonts.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vehicle Type', style: AppFonts.labelMedium),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greyBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<VehicleType>(
                      value: _selectedVehicle,
                      isExpanded: true,
                      style: AppFonts.bodyMedium,
                      items: [
                        DropdownMenuItem(
                          value: VehicleType.sedanHatchback,
                          child: Text('Sedan / Hatchback'),
                        ),
                        DropdownMenuItem(
                          value: VehicleType.motorcycle,
                          child: Text('Motorcycle'),
                        ),
                        DropdownMenuItem(
                          value: VehicleType.bicycle,
                          child: Text('Bicycle'),
                        ),
                        DropdownMenuItem(
                          value: VehicleType.van,
                          child: Text('Van'),
                        ),
                      ],
                      onChanged: (v) => setState(
                        () => _selectedVehicle = v ?? _selectedVehicle,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('License Plate', style: AppFonts.labelMedium),
                SizedBox(height: 8),
                TextField(
                  controller: _licensePlateController,
                  style: AppFonts.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'e.g. ABC-1234',
                    hintStyle: AppFonts.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    filled: true,
                    fillColor: AppColors.greyBg,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Insurance Doc', style: AppFonts.labelMedium),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickDocument,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.greyBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.picture_as_pdf_outlined,
                          color: AppColors.orangeSecondary,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _insuranceDocPath == null
                                    ? 'Click to upload insurance'
                                    : 'Document selected',
                                style: AppFonts.bodySmall,
                              ),
                              Text(
                                'PDF/Image, Max size 5MB',
                                style: AppFonts.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _updateDocuments,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangePrimary,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_outlined, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Update Documents',
                    style: AppFonts.labelLarge.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Updating documents will trigger a re-verification\nprocess which typically takes 24-48 hours.',
            textAlign: TextAlign.center,
            style: AppFonts.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final VerificationStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      VerificationStatus.pendingReview => (
        'Status: Pending Review',
        AppColors.warning,
      ),
      VerificationStatus.verified => ('Status: Verified', AppColors.success),
      VerificationStatus.actionNeeded => (
        'Status: Action Needed',
        AppColors.error,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppFonts.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  final String label;
  final String? filePath;
  final VoidCallback onTap;

  const _UploadBox({
    required this.label,
    required this.filePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.orangePrimary.withValues(alpha: 0.4),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                filePath == null
                    ? Icons.add_a_photo_outlined
                    : Icons.check_circle_outline,
                color: filePath == null
                    ? AppColors.onSurfaceVariant
                    : AppColors.success,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              filePath == null ? label : '$label uploaded',
              style: AppFonts.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
