import 'package:flutter/material.dart';
//import 'package:nodo/features/trabajos/screens/trabajos6.dart';
import 'package:nodo/features/trabajos/logic/TrabajoService.dart';

class JobList extends StatelessWidget {
  final List publicaciones;
  final Map<String, String> nombresClientes;
  final void Function(dynamic, String) onVerDetalles;

  const JobList({
    required this.publicaciones,
    required this.nombresClientes,
    required this.onVerDetalles,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: publicaciones.length,
      itemBuilder: (context, index) {
        final publicacion = publicaciones[index];
        final nombreCliente =
            nombresClientes[publicacion['id_cliente']] ?? 'Cargando nombre...';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  TrabajoService.getIconForCategory(
                      publicacion['id_categoria']),
                  size: 35,
                  color: const Color(0xFF003366),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "${publicacion['titulo']}: ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: publicacion['descripcion_necesidad'],
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${publicacion['presupuesto']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      if (publicacion['estado_postulacion'] ==
                          'considerado') ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Esperando tu aceptación',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                      Text(
                        publicacion['ubicacion'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        "${TrabajoService.formatTimeAgo(publicacion['fecha_publicacion'])} · ${publicacion['estado']}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () => onVerDetalles(publicacion, nombreCliente),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade300,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Ver detalles"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
