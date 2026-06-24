import 'package:flutter/material.dart';
import 'package:nodo/features/trabajos/screens/trabajos7.dart';
import 'package:nodo/features/trabajos/screens/trabajos8.dart';
import 'package:nodo/features/trabajos/screens/trabajos9.dart';
import 'package:nodo/features/trabajos/screens/trabajos10.dart';
import 'package:nodo/features/trabajos/screens/trabajos11.dart';


class CategoryFilterScreen extends StatelessWidget {
  const CategoryFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ListView(
            controller: scrollController,
            children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Filtrar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF003366),
                    ),
                  ),
                  Text(
                    'Restablecer',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Lista de filtros
              const _FilterItem(
                icon: Icons.grid_view_rounded,
                label: 'Categoría',
              ),
              const _FilterItem(
                icon: Icons.location_on_outlined,
                label: 'Ubicación',
              ),
              const _FilterItem(
                icon: Icons.attach_money,
                label: 'Rango de Precio',
              ),
              const _FilterItem(
                icon: Icons.access_time,
                label: 'Tiempo de Publicación',
              ),
              const _FilterItem(
                icon: Icons.calendar_today,
                label: 'Fecha de Inicio',
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
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
      },
    );
  }
}
class _FilterItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FilterItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 16,
      leading: Icon(icon, color: Color(0xFF003366)),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Color(0xFF003366)),
      ),
      onTap: () async {
        if (label == 'Categoría') {
          final resultado = await showModalBottomSheet<List<String>>(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) => const CategoryFilterDetailScreen(),
          );

          if (resultado != null) {
            print('Categorías seleccionadas: $resultado');
          }
        } else if (label == 'Ubicación') {
          final resultado = await showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const FiltroUbicacionScreen(),
          );

          if (resultado != null) {
            print('Ubicación seleccionada: $resultado');
          }
        }else if (label == 'Rango de Precio') {
          final resultado = await showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const FiltroPrecio(),
          );

          if (resultado != null) {
            print('Precio mínimo: ${resultado['min']}, máximo: ${resultado['max']}');
          }
        }else if (label == 'Tiempo de Publicación') {
          final resultado = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const PostTimeFilter(),
          );

          if (resultado != null) {
            print('Tiempo seleccionado: $resultado');
          }
        }else if (label == 'Fecha de Inicio') {
          final resultado = await showModalBottomSheet<DateTimeRange>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const FiltroFechaInicio(),
          );

          if (resultado != null) {
            print('Rango seleccionado: ${resultado.start} hasta ${resultado.end}');
          }
        }
      },
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF003366)),
    );
  }
}