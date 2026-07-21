import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodo/core/theme/app_theme.dart';

class UploadPhotoWidget extends StatefulWidget {
  final Function(List<File>) onImagesSelected;
  final List<File> initialImages;

  const UploadPhotoWidget({
    super.key,
    required this.onImagesSelected,
    this.initialImages = const [],
  });

  @override
  State<UploadPhotoWidget> createState() => _UploadPhotoWidgetState();
}

class _UploadPhotoWidgetState extends State<UploadPhotoWidget> {
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _images = widget.initialImages;
  }

  Future<void> _selectImages() async {
    final selected = await _picker.pickMultiImage();
    if (selected.isNotEmpty) {
      final newImages = selected.map((x) => File(x.path)).toList();
      setState(() => _images = [..._images, ...newImages]);
      widget.onImagesSelected(_images);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      widget.onImagesSelected(_images);
    });
  }

  Widget _buildThumbnail(File imagen, int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 72.w,
          height: 72.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.blue.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: kIsWeb
                ? Image.network(
                    imagen.path,
                    width: 72.w,
                    height: 72.h,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    imagen,
                    width: 72.w,
                    height: 72.h,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.5),
              ),
              padding: const EdgeInsets.all(3),
              child: Icon(
                Icons.close,
                size: 13.r,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            ..._images
                .asMap()
                .entries
                .map((entry) => _buildThumbnail(entry.value, entry.key)),
            GestureDetector(
              onTap: _selectImages,
              child: Container(
                width: 72.w,
                height: 72.h,
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.blue.withValues(alpha: 0.4),
                    width: 1.4,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined,
                        size: 22.r, color: AppColors.blue),
                    SizedBox(height: 4.h),
                    Text(
                      'Agregar',
                      style:
                          AppTypography.caption.copyWith(color: AppColors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
