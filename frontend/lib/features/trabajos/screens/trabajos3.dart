import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/chat/screens/Chat1.dart';
import 'package:nodo/features/trabajos/logic/TrabajoService.dart';
import 'package:nodo/features/trabajos/screens/trabajos4.dart';
import 'package:nodo/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DetalleTrabajoScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  final ScrollController scrollController;
  final bool desdePostulaciones;
  final Map<String, dynamic>? postulacion;
  final VoidCallback? onPostulacionCambiada;

  const DetalleTrabajoScreen({
    super.key,
    required this.job,
    this.postulacion,
    required this.scrollController,
    this.desdePostulaciones = false,
    this.onPostulacionCambiada,
  });

  @override
  State<DetalleTrabajoScreen> createState() => _DetalleTrabajoScreenState();
}

class _DetalleTrabajoScreenState extends State<DetalleTrabajoScreen> {
  String selectedAction = 'postularme';
  int currentPage = 0;

  //@override
  @override
  void initState() {
    super.initState();
    print("DEBUG JOB => ${widget.job}");
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.job["images"] is List
        ? List<String>.from(widget.job["images"])
        : [widget.job["images"]?.toString() ?? ''];

    final String clienteNombre =
        widget.job["user"]?.toString() ?? "Cliente desconocido";
    final String nombreSolo = clienteNombre.contains(":")
        ? clienteNombre.split(":").last.trim()
        : clienteNombre;

    final String titulo = widget.job["title"] ?? "Sin título";
    final String descripcion = widget.job["description"] ?? "Sin descripción";
    final String ubicacion = widget.job["location"] ?? "Sin ubicación";
    final String presupuesto = widget.job["price"] ?? "0";
    final String fechaLimite = widget.job["time"] ?? "";
    final String estadoPostulacion =
        widget.postulacion?['estado'].toString() ?? '';
    print("Estado de la postulacion: ");
    print(estadoPostulacion);
    // final int? jobId = widget.job["id"];
    //   if (jobId == null) {
    //     return const Center(child: Text('Error: Trabajo sin ID'));
    //   }
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(top: 12, bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.whiteT,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: ListView(
                controller: widget.scrollController,
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (index) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Image.network(
                              // Cambia a Image.network
                              images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/diomedes_joven.jpg',
                                fit: BoxFit.cover,
                              ),
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final jobId = widget.job["id"];
                            if (jobId != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //builder: (context) => ReportarScreen(jobId: int.parse(jobId)),
                                  builder: (context) =>
                                      ReportarScreen(jobId: jobId),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("No se puede reportar: ID nulo.")),
                              );
                            }
                          },
                          icon: const Icon(Icons.flag, size: 16),
                          label: const Text("Reportar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            textStyle: const TextStyle(fontSize: 13),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (images.length > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentPage == index
                                  ? const Color(0xFF003366)
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          descripcion,
                          style: const TextStyle(fontSize: 15, height: 1.4),
                        ),
                        const SizedBox(height: 8),
                        Text(ubicacion,
                            style: TextStyle(color: Colors.grey[700])),
                        Text(
                          fechaLimite,
                          style: const TextStyle(
                              color: Colors.redAccent, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          presupuesto,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 32),
                        const Text(
                          "Información del cliente",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/icons/iconNodoBlue.png'),
                              radius: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              clienteNombre,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (!widget.desdePostulaciones)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            // Verificamos que el usuario esté logueado
                            if (userProvider.user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Debes iniciar sesión para postularte')),
                              );
                              return;
                            }
                            // Asumiendo que tienes el ID del trabajador disponible (podría ser de tu sistema de autenticación)
                            final trabajadorId = userProvider.user!.id;
                            final publicacionId = widget.job['id'];

                            await TrabajoService.postularse(
                                publicacionId, trabajadorId);

                            // Opcional: Mostrar un mensaje de éxito
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Postulación enviada correctamente')),
                            );
                            // ✅ Cierra el modal
                            Navigator.of(context).pop();
                            // ✅ Notifica al padre para recargar
                            widget.onPostulacionCambiada?.call();
                            // Opcional: Actualizar el estado si es necesario
                            setState(() {});
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Error al postularse: ${e.toString()}')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedAction == 'postularme'
                              ? const Color(0xFF003366)
                              : Colors.grey[300],
                          foregroundColor: selectedAction == 'postularme'
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: const Text("Postularme"),
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (estadoPostulacion != 'finalizada')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => selectedAction = 'hablar');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedAction == 'hablar'
                              ? const Color(0xFF003366)
                              : Colors.grey[300],
                          foregroundColor: selectedAction == 'hablar'
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: Text(
                          "Hablar con $nombreSolo",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  if (widget.desdePostulaciones &&
                      estadoPostulacion == 'considerado')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            if (userProvider.user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Debes iniciar sesión para aceptar la propuesta')),
                              );
                              return;
                            }

                            await TrabajoService.aceptarPostulacion(
                                widget.postulacion?['id'], 'aceptado');

                            Navigator.of(context).pop(); // Cierra el modal
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      '¡Has aceptado el trabajo exitosamente!')),
                            );
                            widget.onPostulacionCambiada
                                ?.call(); // Refrescar datos
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Error al aceptar postulación: ${e.toString()}')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Aceptar trabajo"),
                      ),
                    ),
                  if (widget.desdePostulaciones)
                    if (estadoPostulacion == 'aceptado') ...[
                      //lo mismo que 'en proceso' de publicacion
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Aquí deberías llamar a un método que marque el trabajo como terminado
                            await TrabajoService.marcarComoTerminado(
                                widget.postulacion?['id']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Notificacion enviada al usuario')),
                            );
                            Navigator.of(context).pop();
                            widget.onPostulacionCambiada?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Trabajo terminado"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Aquí deberías llamar a un método que cancele el trabajo
                            await TrabajoService.cancelarTrabajo(
                                widget.postulacion?['id']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Trabajo cancelado')),
                            );
                            Navigator.of(context).pop();
                            widget.onPostulacionCambiada?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Cancelar trabajo"),
                        ),
                      ),
                    ] else if (estadoPostulacion != 'finalizada')
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await TrabajoService.deletePostulacion(
                                widget.postulacion?['id']);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Postulación eliminada correctamente')),
                            );
                            widget.onPostulacionCambiada?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedAction == 'Eliminar postulacion'
                                    ? const Color(0xFF003366)
                                    : Colors.grey[300],
                            foregroundColor:
                                selectedAction == 'Eliminar postulacion'
                                    ? Colors.white
                                    : Colors.black,
                          ),
                          child: const Text("Eliminar Postulacion"),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
