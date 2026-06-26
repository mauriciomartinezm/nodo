import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class LocationFilterScreen extends StatefulWidget {
  const LocationFilterScreen({super.key});

  @override
  State<LocationFilterScreen> createState() => _LocationFilterScreenState();
}

class _LocationFilterScreenState extends State<LocationFilterScreen> {
  bool soloCercaDeMi = false;
  String? ciudadSeleccionada;

  final List<String> ciudades = [
    "Chigorodó",
    "Apartadó",
    "Carepa",
    "Turbo",
    "Necoclí",
  ];

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
              Text('Ubicación', style: AppTypography.title.copyWith(color: const Color(0xFF003366))),
              SwitchListTile(
                title: const Text("Solo mostrar trabajos cerca de mí", style: TextStyle(color: Color(0xFF003366))),
                value: soloCercaDeMi,
                onChanged: (val) {
                  setState(() {
                    soloCercaDeMi = val;
                  });
                },
              ),
              const SizedBox(height: 12),
              const Text("Seleccionar ciudad o zona manualmente", style: TextStyle(color: Color(0xFF003366))),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: ciudadSeleccionada,
                hint: const Text("Selecciona una ciudad"),
                isExpanded: true,
                items: ciudades.map((ciudad) {
                  return DropdownMenuItem(
                    value: ciudad,
                    child: Text(ciudad),
                  );
                }).toList(),
                onChanged: soloCercaDeMi
                    ? null
                    : (val) {
                        setState(() {
                          ciudadSeleccionada = val;
                        });
                      },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      "soloCercaDeMi": soloCercaDeMi,
                      "ciudad": ciudadSeleccionada,
                    });
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