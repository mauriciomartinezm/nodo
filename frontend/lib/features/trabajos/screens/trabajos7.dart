import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nodo/core/constants/api_constants.dart';

class FiltroCategoriaDetalleScreen extends StatefulWidget {
  const FiltroCategoriaDetalleScreen({super.key});

  @override
  State<FiltroCategoriaDetalleScreen> createState() => _FiltroCategoriaDetalleScreenState();
}

class _FiltroCategoriaDetalleScreenState extends State<FiltroCategoriaDetalleScreen> {
  List<Map<String, dynamic>> categorias = [];// Lista para almacenar las categorías obtenidas
  // Usamos Map<String, dynamic> para manejar categorías con id y nombre_cat
  Set<String> categoriasSeleccionadas = {};// Conjunto para almacenar las categorías seleccionadas por su id
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCategorias();
  }

  Future<void> _fetchCategorias() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getCategorias),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categorias = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error al cargar categorías: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error de conexión: $e';
      });
    }
  }

  bool get todoSeleccionado => categoriasSeleccionadas.length == categorias.length;

  void toggleTodo(bool? val) {
    setState(() {
      if (val == true) {
        categoriasSeleccionadas = Set.from(categorias.map((cat) => cat['id'] as String));
      } else {
        categoriasSeleccionadas.clear();
      }
    });
  }

  void toggleCategoria(String categoriaId, bool? val) {
    setState(() {
      if (val == true) {
        categoriasSeleccionadas.add(categoriaId);
      } else {
        categoriasSeleccionadas.remove(categoriaId);
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
              
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage.isNotEmpty)
                Center(child: Text(_errorMessage))
              else ...[
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
                        title: Text(cat['nombre_cat'], style: const TextStyle(color: Color(0xFF003366))),
                        value: categoriasSeleccionadas.contains(cat['id']),
                        onChanged: (val) => toggleCategoria(cat['id'], val),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Selecciona las categorías que deseas filtrar',
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
            ],
          ),
        );
      },
    );
  }
}