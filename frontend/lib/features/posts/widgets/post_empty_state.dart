import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class PostEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const PostEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  factory PostEmptyState.initial() {
    return const PostEmptyState(
      icon: Icons.post_add_outlined,
      title: 'Crea tu primera publicación',
      description:
          'Usa el botón + para publicar una solicitud de servicio y empieza a recibir propuestas',
    );
  }

  factory PostEmptyState.forFilter(String filter) {
    switch (filter) {
      case 'Activas':
        return const PostEmptyState(
          icon: Icons.pending_actions_outlined,
          title: 'Sin publicaciones activas',
          description:
              'Aquí aparecerán las solicitudes pendientes de asignación',
        );
      case 'En Proceso':
        return const PostEmptyState(
          icon: Icons.construction_outlined,
          title: 'Ningún trabajo en proceso',
          description:
              'Cuando asignes un trabajador a una solicitud, aparecerá aquí',
        );
      case 'Finalizadas':
        return const PostEmptyState(
          icon: Icons.task_alt_outlined,
          title: 'Sin trabajos finalizados',
          description:
              'Los trabajos que hayas completado se mostrarán en esta sección',
        );
      default:
        return PostEmptyState.initial();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 52.r,
                color: AppColors.blue.withValues(alpha: 0.3),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              style: AppTypography.subtitle.copyWith(
                color: AppColors.blue.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              description,
              style: AppTypography.body.copyWith(
                color: AppColors.slateGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
