import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

class PublicacionCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PublicacionCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.work_outline,
              color: AppColors.primaryColor,
              size: 100.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            item['titulo'] ?? 'Sin título',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontFamily: 'GothamMedium',
              fontSize: 10.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            _formatDate(item['fecha_publicacion']),
            style: TextStyle(
              color: AppColors.primaryColor,
              fontFamily: 'GothamBook',
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}