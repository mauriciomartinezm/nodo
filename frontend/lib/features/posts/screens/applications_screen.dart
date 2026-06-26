import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/chat/screens/Chat1.dart';
import 'package:nodo/features/posts/logic/applications_controller.dart';
import 'package:nodo/features/posts/logic/applications_service.dart';
import 'package:nodo/features/posts/models/job_application.dart';

class ApplicationsScreen extends StatelessWidget {
  final String postId;
  const ApplicationsScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ApplicationsController(ApplicationsService(), postId),
      child: const _ApplicationsView(),
    );
  }
}

class _ApplicationsView extends StatelessWidget {
  const _ApplicationsView();

  void _goToChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }

  void _showInfoDialog(BuildContext context, JobApplication application) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(application.workerName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Correo: ${application.workerEmail}'),
            const SizedBox(height: 8),
            Text('Ubicación: ${application.workerLocation}'),
            const SizedBox(height: 8),
            Text('Categoría: ${application.workerCategory}'),
            const SizedBox(height: 8),
            const Text('Descripción:'),
            Text(application.workerDescription ?? 'Sin descripción'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    ApplicationsController controller,
    String value,
    JobApplication application,
  ) async {
    switch (value) {
      case 'info':
        _showInfoDialog(context, application);
        return;
      case 'chat':
        _goToChat(context);
        return;
      case 'aceptar':
      case 'rechazar':
        final success = value == 'aceptar'
            ? await controller.acceptApplication(application.id)
            : await controller.rejectApplication(application.id);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Estado actualizado correctamente'
                : 'Error al actualizar la postulación'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ApplicationsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Postulaciones',
          style: AppTypography.title.copyWith(color: AppColors.orange),
        ),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.applications.isEmpty
              ? Center(
                  child: Text(
                    'Aún no hay postulaciones para esta publicación',
                    style: AppTypography.body.copyWith(color: AppColors.blue),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.applications.length,
                  itemBuilder: (context, index) {
                    final application = controller.applications[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.slateGrey.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.blue.withValues(alpha: 0.1),
                          backgroundImage: (application.workerPhoto != null &&
                                  application.workerPhoto!.isNotEmpty)
                              ? NetworkImage(application.workerPhoto!)
                              : null,
                          child: (application.workerPhoto == null ||
                                  application.workerPhoto!.isEmpty)
                              ? Icon(Icons.person, color: AppColors.blue)
                              : null,
                        ),
                        title: Text(
                          application.workerName,
                          style: AppTypography.label
                              .copyWith(color: AppColors.blue),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(application.workerEmail,
                                style: AppTypography.caption),
                            Text('Estado: ${application.status}',
                                style: AppTypography.caption),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) =>
                              _handleAction(context, controller, value, application),
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                                value: 'info', child: Text('Ver info')),
                            PopupMenuItem(
                              value: 'aceptar',
                              enabled: application.status == 'pending' &&
                                  !controller.hasAcceptedApplication,
                              child: const Text('Aceptar'),
                            ),
                            PopupMenuItem(
                              value: 'rechazar',
                              enabled: application.status == 'pending',
                              child: const Text('Rechazar'),
                            ),
                            const PopupMenuItem(
                                value: 'chat', child: Text('Chatear')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
