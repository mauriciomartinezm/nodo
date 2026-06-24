import 'package:flutter/material.dart';

class PostTimeFilter extends StatelessWidget {
  const PostTimeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.8,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) {
        return PostTimeScreen(scrollController: scrollController);
      },
    );
  }
}

class PostTimeScreen extends StatefulWidget {
  final ScrollController scrollController;

  const PostTimeScreen({super.key, required this.scrollController});

  @override
  State<PostTimeScreen> createState() => _PostTimeScreenState();
}

class _PostTimeScreenState extends State<PostTimeScreen> {
  String? _seleccion;

  final List<String> opciones = [
    'Última Hora',
    'Hoy',
    'Esta semana',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Barra superior
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // Contenido desplazable
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              children: [
                const Text(
                  'Tiempo de publicación',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
                const Divider(),

                ...opciones.map((opcion) {
                  return ListTile(
                    title: Text(
                      opcion,
                      style: const TextStyle(color: Color(0xFF003366)),
                    ),
                    trailing: _seleccion == opcion
                        ? const Icon(Icons.check, color: Color(0xFF003366))
                        : null,
                    onTap: () {
                      setState(() {
                        _seleccion = opcion;
                      });
                    },
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Botón aceptar
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _seleccion);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}