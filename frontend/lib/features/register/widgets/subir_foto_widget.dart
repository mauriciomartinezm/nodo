/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodo/core/theme/app_theme.dart';


class SubirFotoWidget extends StatefulWidget {
  const SubirFotoWidget({super.key});

  @override
  _SubirFotoWidgetState createState() => _SubirFotoWidgetState();
}

class _SubirFotoWidgetState extends State<SubirFotoWidget> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _fotos = [];

  Future<void> _seleccionarFotos() async {
    final List<XFile> fotosSeleccionadas = await _picker.pickMultiImage();

    if (fotosSeleccionadas != null && fotosSeleccionadas.isNotEmpty) {
      setState(() {
        _fotos.addAll(fotosSeleccionadas);
        if (_fotos.length > 10) {
          _fotos = _fotos.sublist(0, 10); // Limitar a máximo 10
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Fotos (Máximo 10)",
          style: TextStyle(fontSize: 10.sp, color: AppColors.slateGrey),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _seleccionarFotos,
          child: Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              border: Border.all(width: 2.r, color: AppColors.slateGrey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _fotos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.image, size: 40.r, color: Colors.orangeAccent),
                        //SizedBox(height: 8.h),
                        //Text(
                        //  "Subir foto",
                        //  style: TextStyle(
                        //    color: Colors.black87,
                        //    fontSize: 10.sp,
                        //    fontWeight: FontWeight.bold,
                        //  ),
                        //),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: _fotos.length,
                    itemBuilder: (context, index) {
                      return Image.file(
                        File(_fotos[index].path),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
*/