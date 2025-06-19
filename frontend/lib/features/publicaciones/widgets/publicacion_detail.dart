import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nodo/features/publicaciones/screens/postulaciones_screen.dart';
import '../../../core/theme/app_theme.dart';
import 'package:nodo/features/publicaciones/logic/publicaciones_controller.dart';

class PublicacionDetail extends StatefulWidget {
  final dynamic publicacion;
  final VoidCallback onDelete;
  final PublicacionesController publicacionesController;

  const PublicacionDetail({
    super.key,
    required this.publicacion,
    required this.onDelete,
    required this.publicacionesController, // 👈
  });

  @override
  State<PublicacionDetail> createState() => _PublicacionDetailState();
}

class _PublicacionDetailState extends State<PublicacionDetail> {
  int _currentIndex = 0;
  late List<String> imageList;

  @override
  void initState() {
    super.initState();
    // Parsear las imágenes de la publicación
    imageList = _parseImages(widget.publicacion['fotos']);
    if (imageList.isEmpty) {
      print("awdadwawd");
      // Si no hay imágenes, puedes mostrar una imagen por defecto
      imageList = ['assets/images/diomedes_joven.jpg'];
    }
  }

  List<String> _parseImages(String fotosString) {
    // Caso cuando no hay fotos
    if (fotosString.isEmpty || fotosString == 'sin fotos') {
      print("NO HAY FOTOS");
      return [];
    }

    try {
      // Limpieza inicial del string
      String cleanedString = fotosString.trim();

      // Caso 1: Si es un JSON válido con escapes (menos común)
      if (cleanedString.startsWith(r'{\"') || cleanedString.startsWith('{"')) {
        cleanedString =
            cleanedString.replaceAll(r'\"', '"').replaceAll('\\"', '"');
      }

      // Caso 2: Si tiene comillas dobles externas (como en tu ejemplo)
      if (cleanedString.startsWith('{"') && cleanedString.endsWith('"}')) {
        cleanedString = cleanedString.substring(1, cleanedString.length - 1);
      }

      // Reemplazar comillas dobles restantes si las hay
      cleanedString = cleanedString.replaceAll('"', '');

      // Dividir por comas y limpiar cada URL
      List<String> urls = cleanedString
          .split(',')
          .map((url) => url.trim())
          .where((url) => url.startsWith('http'))
          .toList();

      return urls;
    } catch (e) {
      print('Error parsing images: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          _buildImageCarousel(),
          SizedBox(height: 8.h),
          _buildCarouselIndicators(),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.publicacion['titulo'] ?? 'Sin título',
                  style: AppTypography.h3.copyWith(color: AppColors.blue),
                ),
                SizedBox(height: 8.h),
                _buildDetailInfo(
                    widget.publicacion['descripcion_necesidad'] ??
                        'Sin descripción',
                    isDescription: true),
                _buildDetailInfo(
                    'Publicado: ${_formatDate(widget.publicacion['fecha_publicacion'])}'),
                _buildDetailInfo(
                    'Ubicación: ${widget.publicacion['ubicacion'] ?? 'Sin ubicación'}'),
                _buildDetailInfo(
                    'Fecha límite: ${_formatDate(widget.publicacion['fecha_limite'])}'),
                _buildDetailInfo(
                    'Presupuesto: \$${widget.publicacion['presupuesto']?.toString() ?? '0'}'),
                _buildStatusInfo(widget.publicacion['estado']),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    if (imageList.isEmpty) {
      return Container(
        height: 150.h,
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.r),
        child: Text(
          'No hay imágenes disponibles para esta publicación',
          textAlign: TextAlign.center,
          style: AppTypography.h2.copyWith(color: AppColors.blue),
        ),
      );
    }

    return CarouselSlider(
      items: imageList.map((imageUrl) {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            // Mostrar el mensaje directamente, sin imagen ni efecto de carrusel
            return Container(
              height: 150.h,
              alignment: Alignment.center,
              padding: EdgeInsets.all(16.r),
              child: Text(
                'No hay imágenes disponibles para esta publicación',
                textAlign: TextAlign.center,
                style: AppTypography.h2.copyWith(color: AppColors.blue),
              ),
            );
          },
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
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
        );
      }).toList(),
      options: CarouselOptions(
        height: 150.h,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        viewportFraction: 1.0,
        scrollPhysics: imageList.length > 1
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(), // <- desactiva movimiento si solo hay una imagen
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCarouselIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: imageList.asMap().entries.map((entry) {
        return Container(
          width: 8.w,
          height: 8.w,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _currentIndex == entry.key ? AppColors.orange : AppColors.blue,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailInfo(String texto, {bool isDescription = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: isDescription
          ? Text(
              texto,
              style: AppTypography.body.copyWith(color: AppColors.blue),
              softWrap: true,
              overflow: TextOverflow.visible,
            )
          : Row(
              children: [
                Text(texto,
                    style: AppTypography.body.copyWith(color: AppColors.blue)),
              ],
            ),
    );
  }

  Widget _buildStatusInfo(String status) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            'Estado: ',
            style: AppTypography.body.copyWith(color: AppColors.blue),
          ),
          Text(
            _translateStatus(status),
            style: AppTypography.body.copyWith(color: AppColors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final estado = widget.publicacion['estado'];
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (estado != 'en proceso' && estado != 'finalizada')
            _buildActionButton(
              Icons.edit_outlined,
              'Editar',
              AppColors.white,
              AppColors.blue,
              () {
                // Acción editar
              },
            ),
          if (estado != 'en proceso' && estado != 'finalizada')
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostulacionesScreen(
                      idPublicacion: widget.publicacion['id'],
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.delete_outline,
                size: 20.sp,
                color: AppColors.blue,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue.withOpacity(0.2),
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
              ),
              label: Text(
                'Postulaciones',
                style: AppTypography.h3.copyWith(color: AppColors.blue),
              ),
            ),
          if (estado == 'en proceso' && estado != 'finalizada')
            _buildActionButton(
              Icons.check_circle_outline,
              'Completado',
              AppColors.white,
              AppColors.blue, // fondo azul
              () => _confirmarFinalizacion(widget.publicacion['id']),
            ),
          if (estado != 'en proceso' && estado != 'finalizada')
            TextButton.icon(
              onPressed: widget.onDelete,
              icon: Icon(
                Icons.delete_outline,
                size: 20.sp,
                color: AppColors.blue,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue.withOpacity(0.2),
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
              ),
              label: Text(
                'Eliminar',
                style: AppTypography.h3.copyWith(color: AppColors.blue),
              ),
            ),
        ],
      ),
    ]);
  }

  Widget _buildActionButton(
    IconData icon,
    String text,
    Color textColor,
    Color backgroundColor,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20.sp, color: textColor),
      label: Text(
        text,
        style: AppTypography.h3.copyWith(color: AppColors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(5),
          ),
        ),
      ),
    );
  }

  void _confirmarFinalizacion(String idPublicacion) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text(
            '¿Estás seguro de marcar esta publicación como finalizada?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      try {
        final success = await widget.publicacionesController
            .updatePublicacion(idPublicacion.toString(), 'finalizada');

        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trabajo marcado como finalizado.')),
          );
        }

        setState(() {
          widget.publicacion['estado'] = 'finalizada';
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: ${e.toString()}')),
        );
      }
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'pendiente':
        return 'Activa';
      case 'en_proceso':
        return 'En Proceso';
      case 'finalizada':
        return 'Finalizada';
      default:
        return status;
    }
  }
}
