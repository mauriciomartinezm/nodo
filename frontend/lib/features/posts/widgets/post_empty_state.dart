import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class PostEmptyState extends StatelessWidget {
  final String title;
  final String description;

  const PostEmptyState({
    super.key,
    required this.title,
    required this.description,
  });

  factory PostEmptyState.initial() {
    return const PostEmptyState(
      title: 'Aquí verás tus publicaciones',
      description: 'Cuando publiques una solicitud de servicio, aparecerá aquí para que hagas el seguimiento',
    );
  }

  factory PostEmptyState.forFilter(String filter) {
    switch (filter) {
      case 'Activas':
        return const PostEmptyState(
          title: 'Tus publicaciones activas',
          description: 'Aquí se mostrarán las solicitudes de servicio que hayas publicado y aún no tengan un trabajador asignado',
        );
      case 'En Proceso':
        return const PostEmptyState(
          title: 'Tus publicaciones en proceso',
          description: 'Aquí aparecerán las solicitudes en las que hayas asignado un trabajador a una solicitud de servicio',
        );
      case 'Finalizadas':
        return const PostEmptyState(
          title: 'Tus publicaciones finalizadas',
          description: 'Aquí aparecerán las solicitudes de servicio que han sido completadas',
        );
      default:
        return PostEmptyState.initial();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTypography.title
                  .copyWith(color: AppColors.orange.withValues(alpha: 0.6)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              description,
              style: AppTypography.body
                  .copyWith(color: AppColors.blue.withValues(alpha: 0.6)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}