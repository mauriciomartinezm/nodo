import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class PublicacionEmptyState extends StatelessWidget {
  final String title;
  final String description;

  const PublicacionEmptyState({
    super.key,
    required this.title,
    required this.description,
  });

  factory PublicacionEmptyState.initial() {
    return const PublicacionEmptyState(
      title: 'Aquí verás tus publicaciones',
      description: 'Cuando publiques una solicitud de servicio, aparecerá aquí para que hagas el seguimiento',
    );
  }

  factory PublicacionEmptyState.forFilter(String filter) {
    switch (filter) {
      case 'Activas':
        return const PublicacionEmptyState(
          title: 'Tus publicaciones activas',
          description: 'Aquí se mostrarán las solicitudes de servicio que hayas publicado y aún no tengan un trabajador asignado',
        );
      case 'En Proceso':
        return const PublicacionEmptyState(
          title: 'Tus publicaciones en proceso',
          description: 'Aquí aparecerán las solicitudes en las que hayas asignado un trabajador a una solicitud de servicio',
        );
      case 'Finalizadas':
        return const PublicacionEmptyState(
          title: 'Tus publicaciones finalizadas',
          description: 'Aquí aparecerán las solicitudes de servicio que han sido completadas',
        );
      default:
        return PublicacionEmptyState.initial();
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
              style: TextStyle(
                color: AppColors.orange.withOpacity(0.6),
                fontFamily: 'GothamMedium',
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              description,
              style: TextStyle(
                color: AppColors.blue.withOpacity(0.6),
                fontFamily: 'GothamBook',
                fontSize: 15.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}