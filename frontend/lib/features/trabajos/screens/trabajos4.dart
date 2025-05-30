import 'package:flutter/material.dart';
import 'package:nodo/features/trabajos/screens/trabajos5.dart';

class ReportarScreen extends StatefulWidget {
  const ReportarScreen({Key? key}) : super(key: key);

  @override
  State<ReportarScreen> createState() => _ReportarScreenState();
}

class _ReportarScreenState extends State<ReportarScreen> {
  String? selectedOption;

  final List<Map<String, String>> motivos = [
    {
      'titulo': 'Contenido inapropiado',
      'descripcion':
          'Contiene lenguaje ofensivo, violencia, discriminación o imágenes no adecuadas.'
    },
    {
      'titulo': 'Información falsa o engañosa',
      'descripcion':
          'Los datos proporcionados no son correctos o pueden confundir a los usuarios.'
    },
    {
      'titulo': 'Spam o publicidad',
      'descripcion':
          'Esta publicación parece ser un anuncio o promociona algo o no parece requerir un servicio real'
    },
    {
      'titulo': 'Producto o servicio ilegal',
      'descripcion':
          'Se vende o promociona algo que no está permitido en la plataforma'
    },
    {
      'titulo': 'Estafa o fraude',
      'descripcion':
          'Sospecha de engaño, cobro indebido o intento de estafa.'
    },
    {
      'titulo': 'Derechos de autor',
      'descripcion':
          'Utiliza contenido (imágenes, textos, marcas) sin autorización del propietario.'
    },
    {
      'titulo': 'Otro (especificar)',
      'descripcion': 'Explica el motivo en el campo de comentarios.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Reportar',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20, 
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF003366),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Por qué quieres reportar esta publicación?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ayúdanos a mantener la plataforma segura eligiendo el motivo del reporte.',
              style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 16, 57, 98)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: motivos.length,
                itemBuilder: (context, index) {
                  final titulo = motivos[index]['titulo']!;
                  final descripcion = motivos[index]['descripcion']!;
                  return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.orange,
                    title: Text(
                      titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF003366), // Azul oscuro
                      ),
                    ),
                  subtitle: Text(
                    descripcion,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade600, // Gris claro
                    ),
                  ),
                    value: selectedOption == titulo,
                    onChanged: (_) {
                      setState(() {
                        selectedOption = titulo;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: selectedOption != null
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GraciasScreen()),
                  );
                }
              : null,

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedOption != null ? Colors.orange[300] : Colors.grey[300],
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                'Reportar',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'Boton solo se habilita cuando se selecciona una opción',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
