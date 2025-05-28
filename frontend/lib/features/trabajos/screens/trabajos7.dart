import 'package:flutter/material.dart';

class FiltroCategoriaDetalleScreen extends StatefulWidget {
  const FiltroCategoriaDetalleScreen({Key? key}) : super(key: key);

  @override
  State<FiltroCategoriaDetalleScreen> createState() => _FiltroCategoriaDetalleScreenState();
}

class _FiltroCategoriaDetalleScreenState extends State<FiltroCategoriaDetalleScreen> {
  List<String> categorias = [
    "Diseño Gráfico",
    "Plomería",
    "Electricidad",
    "Reparaciones",
  ];

  Set<String> categoriasSeleccionadas = {};

  bool get todoSeleccionado => categoriasSeleccionadas.length == categorias.length;

  void toggleTodo(bool? val) {
    setState(() {
      if (val == true) {
        categoriasSeleccionadas = categorias.toSet();
      } else {
        categoriasSeleccionadas.clear();
      }
    });
  }

  void toggleCategoria(String categoria, bool? val) {
    setState(() {
      if (val == true) {
        categoriasSeleccionadas.add(categoria);
      } else {
        categoriasSeleccionadas.remove(categoria);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.8,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handler visual
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003366),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const Text('Categoría', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Todo', style: TextStyle(color: Color(0xFF003366))),
                value: todoSeleccionado,
                onChanged: toggleTodo,
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: categorias.length,
                  itemBuilder: (_, i) {
                    final cat = categorias[i];
                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(cat, style: const TextStyle(color: Color(0xFF003366))),
                      value: categoriasSeleccionadas.contains(cat),
                      onChanged: (val) => toggleCategoria(cat, val),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Recuerda que, si deseas filtrar por más categorías, primero debes actualizarlas.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, categoriasSeleccionadas.toList());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
