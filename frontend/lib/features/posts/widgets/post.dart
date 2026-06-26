import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

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

  List<String> _parseImages(dynamic fotos) {
    if (fotos is List) {
      return fotos.map((url) => url.toString()).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    // Parseamos las imágenes
    final List<String> imagenes = _parseImages(item['photos']);
    final bool tieneImagenes = imagenes.isNotEmpty;
    final String? primeraImagen = tieneImagenes ? imagenes.first : null;

    return GestureDetector(
      onTap: onTap,
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
                      errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(),
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
            _formatDate(item['postDate']),
            style: AppTypography.caption.copyWith(color: AppColors.blue),
          ),
        ],
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}