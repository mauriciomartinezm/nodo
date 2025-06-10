import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:path/path.dart';

class SubirFotoWidget extends StatefulWidget {
  final Function(List<String>) onUploadComplete;
  final List<String> initialUrls;
  const SubirFotoWidget({
    super.key,
    required this.onUploadComplete,
    this.initialUrls = const [],
  });

  @override
  State<SubirFotoWidget> createState() => _SubirFotoWidgetState();
}

class _SubirFotoWidgetState extends State<SubirFotoWidget> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imagenes = [];
  List<String> _urls = [];
  bool _subiendo = false;

  Future<void> _seleccionarImagenes() async {
    final List<XFile>? seleccionadas = await _picker.pickMultiImage();

    if (seleccionadas != null && seleccionadas.isNotEmpty) {
      setState(() => _imagenes = seleccionadas);
      await _subirImagenes();
    }
  }

  Future<void> _subirImagenes() async {
    setState(() => _subiendo = true);

    List<String> urls = [];

    for (final imagen in _imagenes) {
      final nombreArchivo = basename(imagen.path);
      final ref =
          FirebaseStorage.instance.ref().child('publicaciones/$nombreArchivo');

      final uploadTask = ref.putFile(File(imagen.path));
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      urls.add(url);
    }

    setState(() {
      _urls = urls;
      _subiendo = false;
    });

    widget.onUploadComplete(urls); // Pasar URLs al padre
  }

  @override
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _seleccionarImagenes,
          child: Container(
            height: 80.h,
            width: double
                .infinity, // <- esto hace que tome todo el ancho disponible
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.whiteT, width: 2.r),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _urls.isEmpty
                ? Center(
                    child: Text(
                    'Seleccionar imágenes',
                    style: AppTypography.body.copyWith(color: AppColors.whiteT),
                  ))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _urls.asMap().entries.map((entry) {
                      final index = entry.key;
                      final url = entry.value;

                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              url,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _urls.removeAt(index);
                                  widget.onUploadComplete(_urls);
                                });
                              },
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
        const SizedBox(height: 10),
        if (_subiendo) const CircularProgressIndicator(),
      ],
    );
  }
}
