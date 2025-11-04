import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodo/core/theme/app_theme.dart';

class SubirFotoWidget extends StatefulWidget {
  final Function(List<File>) onImagesSelected;
  final List<File> initialImages;

  const SubirFotoWidget({
    super.key,
    required this.onImagesSelected,
    this.initialImages = const [],
  });

  @override
  State<SubirFotoWidget> createState() => _SubirFotoWidgetState();
}

class _SubirFotoWidgetState extends State<SubirFotoWidget> {
  final ImagePicker _picker = ImagePicker();
  List<File> _imagenes = [];

  @override
  void initState() {
    super.initState();
    _imagenes = widget.initialImages;
  }

  Future<void> _seleccionarImagenes() async {
    final seleccionadas = await _picker.pickMultiImage();
    if (seleccionadas.isNotEmpty) {
      final nuevas = seleccionadas.map((x) => File(x.path)).toList();
      setState(() => _imagenes = [..._imagenes, ...nuevas]);
      widget.onImagesSelected(_imagenes);
    }
  }

  void _eliminarImagen(int index) {
    setState(() {
      _imagenes.removeAt(index);
      widget.onImagesSelected(_imagenes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _seleccionarImagenes,
          child: Container(
            height: 100.h,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.whiteT, width: 2.r),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _imagenes.isEmpty
                ? Center(
                    child: Text(
                      'Seleccionar imágenes',
                      style: AppTypography.body
                          .copyWith(color: AppColors.whiteT),
                    ),
                  )
                : Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _imagenes.asMap().entries.map((entry) {
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
                              onTap: () => _eliminarImagen(index),
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
