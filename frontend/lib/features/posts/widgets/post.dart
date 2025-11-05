import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

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

  List<String> _parseImages(String fotosString) {
    if (fotosString.isEmpty || fotosString == 'sin fotos') {
      return [];
    }

    try {
      String cleanedString = fotosString.trim();

      // Caso 1: Si es un JSON válido con escapes
      if (cleanedString.startsWith(r'{\"') || cleanedString.startsWith('{\"')) {
        cleanedString =
            cleanedString.replaceAll(r'\"', '"').replaceAll('\\"', '"');
      }

      // Caso 2: Si tiene comillas dobles externas
      if (cleanedString.startsWith('{"') && cleanedString.endsWith('"}')) {
        cleanedString = cleanedString.substring(1, cleanedString.length - 1);
      }

      // Limpieza final
      cleanedString = cleanedString.replaceAll('"', '');

      return cleanedString
          .split(',')
          .map((url) => url.trim())
          .where((url) => url.startsWith('http'))
          .toList();
    } catch (e) {
      print('Error parsing images: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Parseamos las imágenes
    final List<String> imagenes = _parseImages(item['fotos'] ?? '');
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
            item['titulo'] ?? 'Sin título',
            style: TextStyle(
              color: AppColors.blue,
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
              color: AppColors.blue,
              fontFamily: 'GothamBook',
              fontSize: 10.sp,
            ),
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