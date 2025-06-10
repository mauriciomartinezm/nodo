import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class SubirFotoWidget extends StatefulWidget {
  final Function(List<String>) onUploadComplete;

  const SubirFotoWidget({super.key, required this.onUploadComplete});

  @override
  State<SubirFotoWidget> createState() => _SubirFotoWidgetState();
}

class _SubirFotoWidgetState extends State<SubirFotoWidget> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imagenes = [];
  List<String> _urls = [];
  bool _subiendo = false;

  Future<void> _seleccionarImagenes() async {
    final List<XFile> seleccionadas = await _picker.pickMultiImage();

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
      final ref = FirebaseStorage.instance.ref().child('publicaciones/$nombreArchivo');

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_subiendo) const CircularProgressIndicator(),
        if (_urls.isNotEmpty)
          Wrap(
            spacing: 10,
            children: _urls.map((url) => Image.network(url, width: 80, height: 80)).toList(),
          ),
        ElevatedButton(
          onPressed: _seleccionarImagenes,
          child: const Text("Seleccionar imágenes"),
        ),
      ],
    );
  }
}
