import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/posts_controller.dart';
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
        return 'pending';
      case 1:
        return 'in_progress';
      case 2:
        return 'finished';
      default:
        return 'pending';
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
    // Cerrar el teclado antes de abrir el detalle
    FocusManager.instance.primaryFocus?.unfocus();

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => PostDetail(
          publicacion: item,
          postsController: controller,
          onDelete: () => _confirmDelete(context, item, controller),
        ),
      ),
    );

    FocusManager.instance.primaryFocus?.unfocus();
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
                if (!context.mounted) return;
                Navigator.of(context).pop(success);
              } catch (e) {
                if (!context.mounted) return;
                Navigator.of(context).pop(false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
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
        const SnackBar(content: Text('Publicación eliminada'), backgroundColor: AppColors.success),
      );
      await controller.loadPosts();
      if (!context.mounted) return;
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

    final rowCount = (items.length / 2).ceil();

    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: rowCount,
      itemBuilder: (context, rowIndex) {
        final leftItem = items[rowIndex * 2];
        final rightItem =
            rowIndex * 2 + 1 < items.length ? items[rowIndex * 2 + 1] : null;

        Widget buildCard(dynamic item) {
          final isHighlighted = controller.highlightedPostId == item['id'];
          return PostCard(
            item: item,
            isHighlighted: isHighlighted,
            onHighlightEnd: isHighlighted ? controller.clearHighlight : null,
            onTap: () => _showPublicationDetail(context, item, controller),
            onDelete: () => _confirmDelete(context, item, controller),
          );
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: buildCard(leftItem)),
                SizedBox(width: 10.w),
                if (rightItem != null)
                  Expanded(child: buildCard(rightItem))
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
        );
      },
    );
  }
}