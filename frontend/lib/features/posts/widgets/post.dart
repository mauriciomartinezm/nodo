import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/posts/utils/post_format_utils.dart';

class PostCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PostCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> imagenes = parsePostImages(item['photos']);
    final bool tieneImagenes = imagenes.isNotEmpty;
    final String? primeraImagen = tieneImagenes ? imagenes.first : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.slateGrey.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 100.sp, // Altura fija para mantener consistencia
              decoration: BoxDecoration(
                color: tieneImagenes
                    ? Colors.transparent
                    : AppColors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: tieneImagenes
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        primeraImagen!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultIcon(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    )
                  : _buildDefaultIcon(),
            ),
            SizedBox(height: 8.h),
            Text(
              item['title'] ?? 'Sin título',
              style: AppTypography.caption.copyWith(color: AppColors.blue),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              formatPostDate(item['postDate']),
              style: AppTypography.caption.copyWith(color: AppColors.blue),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para el icono por defecto
  Widget _buildDefaultIcon() {
    return Center(
      child: Icon(
        Icons.work_outline,
        color: AppColors.blue,
        size: 50.sp, // Tamaño más pequeño para que no domine
      ),
    );
  }
}