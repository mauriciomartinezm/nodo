import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

/// Fuente única de verdad para traducir y colorear el estado de una
/// publicación ('pending', 'in_progress', 'finished', 'cancelled').

String translatePostStatus(String status) {
  switch (status) {
    case 'pending':
      return 'Activa';
    case 'in_progress':
      return 'En Proceso';
    case 'finished':
      return 'Finalizada';
    case 'cancelled':
      return 'Cancelada';
    default:
      return status;
  }
}

Color postStatusColor(String status) {
  switch (status) {
    case 'pending':
      return AppColors.orange;
    case 'in_progress':
      return AppColors.blue;
    case 'finished':
      return AppColors.success;
    case 'cancelled':
      return AppColors.error;
    default:
      return AppColors.grey;
  }
}
