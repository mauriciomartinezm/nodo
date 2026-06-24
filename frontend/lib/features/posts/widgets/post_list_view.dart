import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/publicaciones_controller.dart';
import 'post.dart';
import 'post_detail.dart';
import 'post_empty_state.dart';

class PostListView extends StatelessWidget {
  final int filter;

  const PostListView({
    super.key,
    required this.filter,
  });

  String _getEstadoForFilter(int filterIndex) {
    switch (filterIndex) {
      case 0:
        return 'pendiente';
      case 1:
        return 'en proceso';
      case 2:
        return 'finalizada';
      default:
        return 'pendiente';
    }
  }

  String _getFilterName(int filterIndex) {
    switch (filterIndex) {
      case 0:
        return 'Activas';
      case 1:
        return 'En Proceso';
      case 2:
        return 'Finalizadas';
      default:
        return 'Activas';
    }
  }

  Future<void> _showPublicationDetail(
    BuildContext context, dynamic item, PostsController controller) async {
  // Cerrar el teclado antes de abrir el modal
  FocusManager.instance.primaryFocus?.unfocus();
  
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    useRootNavigator: true,
    builder: (context) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: PostDetail(
          publicacion: item,
          postsController: controller,
          onDelete: () => _confirmDelete(context, item, controller),
        ),
      );
    },
  ).then((_) {
    // Cerrar el teclado después de cerrar el modal
    FocusManager.instance.primaryFocus?.unfocus();
  });
}

  Future<void> _confirmDelete(
      BuildContext context, dynamic item, PostsController controller) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Estás seguro?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final success = await controller.deletePost(item['id']);
                Navigator.of(context).pop(success);
              } catch (e) {
                Navigator.of(context).pop(false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publicación eliminada')),
      );
      await controller.loadPosts();
      Navigator.of(context).pop(); // Cierra el modal de detalle
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PostsController>(context);
    final estado = _getEstadoForFilter(filter);
    final items = controller.filterPosts(estado);

    if (items.isEmpty) {
      return PostEmptyState.forFilter(_getFilterName(filter));
    }

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 20.w,
        mainAxisSpacing: 10.h,
        children: items.map((item) {
          return PostCard(
            item: item,
            onTap: () => _showPublicationDetail(context, item, controller),
            onDelete: () => _confirmDelete(context, item, controller),
          );
        }).toList(),
      ),
    );
  }
}