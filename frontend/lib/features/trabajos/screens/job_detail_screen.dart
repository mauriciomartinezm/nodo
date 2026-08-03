import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/chat/screens/chat_1.dart';
import 'package:nodo/features/trabajos/logic/job_service.dart';
import 'package:nodo/features/trabajos/screens/report_screen.dart';
import 'package:nodo/shared/providers/user_provider.dart';
import 'package:provider/provider.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  final ScrollController scrollController;
  final bool desdePostulaciones;
  final Map<String, dynamic>? postulacion;
  final VoidCallback? onPostulacionCambiada;

  const JobDetailScreen({
    super.key,
    required this.job,
    this.postulacion,
    required this.scrollController,
    this.desdePostulaciones = false,
    this.onPostulacionCambiada,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  int currentPage = 0;
  bool _workerHasConfirmed = false;
  bool _clientHasConfirmed = false;

  @override
  void initState() {
    super.initState();
    final service = widget.postulacion?['service'] as Map<String, dynamic>?;
    _workerHasConfirmed = service?['workerCompletionRequest'] as bool? ?? false;
    _clientHasConfirmed = service?['clientCompletionRequest'] as bool? ?? false;
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
        widget.postulacion?['status']?.toString() ?? '';

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
                color: AppColors.slateGrey,
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
                            setState(() => currentPage = index);
                          },
                          itemBuilder: (context, index) {
                            return Image.network(
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
                                  builder: (context) =>
                                      ReportScreen(jobId: jobId),
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
                            textStyle: AppTypography.label,
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
                                  ? AppColors.blue
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
                        Text(titulo, style: AppTypography.title),
                        const SizedBox(height: 8),
                        Text(
                          descripcion,
                          style: AppTypography.body.copyWith(height: 1.4),
                        ),
                        const SizedBox(height: 8),
                        Text(ubicacion,
                            style: AppTypography.body
                                .copyWith(color: Colors.grey[700])),
                        Text(
                          fechaLimite,
                          style: AppTypography.label
                              .copyWith(color: Colors.redAccent),
                        ),
                        const SizedBox(height: 8),
                        Text(presupuesto, style: AppTypography.title),
                        const Divider(height: 32),
                        Text(
                          "Información del cliente",
                          style: AppTypography.body,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Image(
                                  image: AssetImage(
                                      'assets/icons/iconNodoBlue.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              clienteNombre,
                              style: AppTypography.body,
                            ),
                          ],
                        ),
                        // Completion status panel for accepted jobs
                        if (estadoPostulacion == 'accepted') ...[
                          const SizedBox(height: 16),
                          _buildCompletionStatusPanel(nombreSolo),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _buildBottomButtons(
                  estadoPostulacion, nombreSolo),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionStatusPanel(String clienteName) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blue.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado de finalización',
            style: AppTypography.label.copyWith(color: AppColors.blue),
          ),
          const SizedBox(height: 10),
          _buildConfirmationRow(
            icon: Icons.construction_outlined,
            label: 'Tú',
            confirmed: _workerHasConfirmed,
          ),
          const SizedBox(height: 6),
          _buildConfirmationRow(
            icon: Icons.person_outline,
            label: clienteName,
            confirmed: _clientHasConfirmed,
          ),
          if (_workerHasConfirmed && !_clientHasConfirmed) ...[
            const SizedBox(height: 10),
            Text(
              'Esperando confirmación del cliente…',
              style: AppTypography.caption.copyWith(color: AppColors.slateGrey),
            ),
          ],
          if (!_workerHasConfirmed && _clientHasConfirmed) ...[
            const SizedBox(height: 10),
            Text(
              'El cliente ya confirmó. Confirma tu parte para cerrar el trabajo.',
              style: AppTypography.caption.copyWith(color: AppColors.orange),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConfirmationRow({
    required IconData icon,
    required String label,
    required bool confirmed,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.blue.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(color: AppColors.blue),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(
          confirmed ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 18,
          color: confirmed ? AppColors.success : AppColors.slateGrey,
        ),
        const SizedBox(width: 4),
        Text(
          confirmed ? 'Confirmado' : 'Pendiente',
          style: AppTypography.caption.copyWith(
            color: confirmed ? AppColors.success : AppColors.slateGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(String estadoPostulacion, String nombreSolo) {
    final buttons = <Widget>[];

    // Apply button (only when not from postulaciones and job not finished)
    if (!widget.desdePostulaciones && estadoPostulacion != 'finished') {
      buttons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              try {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Debes iniciar sesión para postularte')),
                  );
                  return;
                }
                final trabajadorId = userProvider.user!.id;
                final publicacionId = widget.job['id'];
                await JobService.apply(publicacionId, trabajadorId);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Postulación enviada correctamente')),
                );
                Navigator.of(context).pop();
                widget.onPostulacionCambiada?.call();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Error al postularse: ${e.toString()}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
            ),
            child: const Text("Postularme"),
          ),
        ),
      );
      buttons.add(const SizedBox(width: 8));
    }

    // Chat button — shown when there's a relationship (from postulaciones)
    if (widget.desdePostulaciones && estadoPostulacion != 'finished') {
      buttons.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: Text(
              "Hablar con $nombreSolo",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
            ),
          ),
        ),
      );
    } else if (!widget.desdePostulaciones && estadoPostulacion != 'finished') {
      // Chat button for non-applied workers viewing the job
      buttons.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: Text(
              "Hablar con $nombreSolo",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
            ),
          ),
        ),
      );
    }

    // Accept job button (pending application)
    if (widget.desdePostulaciones && estadoPostulacion == 'pending') {
      if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));
      buttons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              try {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Debes iniciar sesión para aceptar la propuesta')),
                  );
                  return;
                }
                await JobService.acceptApplication(
                    widget.postulacion?['id'], 'accepted');
                if (!mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('¡Has aceptado el trabajo exitosamente!')),
                );
                widget.onPostulacionCambiada?.call();
              } catch (e) {
                if (!mounted) return;
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
      );
    }

    // Accepted job actions
    if (widget.desdePostulaciones && estadoPostulacion == 'accepted') {
      if (buttons.isNotEmpty) buttons.add(const SizedBox(width: 8));

      if (!_workerHasConfirmed) {
        buttons.add(
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final result = await JobService.markAsFinished(
                      widget.postulacion?['id']);
                  if (!mounted) return;

                  final completed = result['completed'] as bool? ?? false;

                  if (completed) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              '¡Trabajo finalizado con éxito! Ambos confirmaron.')),
                    );
                    widget.onPostulacionCambiada?.call();
                  } else {
                    setState(() => _workerHasConfirmed = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Confirmación enviada. Esperando que el cliente confirme también.')),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Error al confirmar: ${e.toString()}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text("Trabajo terminado"),
            ),
          ),
        );
      }

      buttons.add(const SizedBox(width: 8));
      buttons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              await JobService.cancelJob(widget.postulacion?['id']);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trabajo cancelado')),
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
      );
    }

    // Delete application (for rejected/withdrawn states)
    if (widget.desdePostulaciones &&
        estadoPostulacion != 'accepted' &&
        estadoPostulacion != 'finished' &&
        estadoPostulacion != 'pending') {
      buttons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              await JobService.deleteApplication(
                  widget.postulacion?['id']);
              if (!mounted) return;
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Postulación eliminada correctamente')),
              );
              widget.onPostulacionCambiada?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
            ),
            child: const Text("Eliminar Postulacion"),
          ),
        ),
      );
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Row(children: buttons);
  }
}
