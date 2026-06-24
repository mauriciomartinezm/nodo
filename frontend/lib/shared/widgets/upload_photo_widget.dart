import 'dart:io';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _selectImages,
          child: Container(
            height: 100.h,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.slateGrey, width: 2.r),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _images.isEmpty
                ? Center(
                    child: Text(
                      'Seleccionar imágenes',
                      style: AppTypography.body
                          .copyWith(color: AppColors.slateGrey),
                    ),
                  )
                : Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _images.asMap().entries.map((entry) {
                      final index = entry.key;
                      final imagen = entry.value;
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              imagen,
                              width: 60.w,
                              height: 60.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: Icon(
                                  Icons.close,
                                  size: 14.r,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
          ),
        ),
      ],
    );
  }
}
