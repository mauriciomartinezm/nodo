import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nodo/features/posts/screens/applications_screen.dart';
import '../../../core/theme/app_theme.dart';
import 'package:nodo/features/posts/logic/publicaciones_controller.dart';

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
  final CarouselSliderController _carouselController = CarouselSliderController();
  @override
  void initState() {
    super.initState();
    // Parsear las imágenes de la publicación
    imageList = _parseImages(widget.publicacion['fotos']);
    if (imageList.isEmpty) {
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
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      CarouselSlider(
        carouselController: _carouselController, 
        items: imageList.map((imageUrl) {
          return ClipRRect(
            //borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: 180.h,
          viewportFraction: 0.9,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),

      // Indicadores sobre la imagen
      Positioned(
        bottom: 10.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageList.asMap().entries.map((entry) {
            final bool isActive = _currentIndex == entry.key;
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isActive ? 7.w : 7.w, //cambiar el primer valor para ajustar tamaño
                height: isActive ? 7.w : 7.w, //cambiar el primer valor para ajustar tamaño
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppColors.orange : AppColors.blue,
                  border: Border.all(color: AppColors.white, width: 0.5),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ],
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
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
            _buildActionButton(
              Icons.person,
              'Postulaciones',
              AppColors.blue,
              AppColors.blue.withOpacity(0.2),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostulacionesScreen(
                      idPublicacion: widget.publicacion['id'],
                    ),
                  ),
                );
              },
            ),
          if (estado == 'en proceso' && estado != 'finalizada')
            _buildActionButton(
              Icons.check_circle_outline,
              'Completado',
              AppColors.blue,
              AppColors.blue.withOpacity(0.2), // fondo azul
              () => _confirmarFinalizacion(widget.publicacion['id']),
            ),
          if (estado != 'en proceso' && estado != 'finalizada')
            _buildActionButton(
              Icons.delete_outline,
              'Eliminar',
              AppColors.blue,
              AppColors.blue.withOpacity(0.2), // fondo azul
              () {
                widget.onDelete();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String text,
    Color textColor,
    Color backgroundColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20.sp, color: textColor),
        label: Text(
          text,
          style: AppTypography.body.copyWith(color: textColor),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          tapTargetSize:
              MaterialTapTargetSize.shrinkWrap, // 🔹 Compacta el espacio
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
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
            .finalizarTrabajo(idPublicacion.toString());

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
