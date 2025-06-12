import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nodo/features/publicaciones/screens/postulaciones_screen.dart';
import '../../../core/theme/app_colors.dart';

class PublicacionDetail extends StatefulWidget {
  final dynamic publicacion;
  final VoidCallback onDelete;

  const PublicacionDetail({
    super.key,
    required this.publicacion,
    required this.onDelete,
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
              color: AppColors.primaryColor,
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
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'GothamMedium',
                    fontSize: 14.sp,
                  ),
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
    return CarouselSlider(
      items: imageList.map((imageUrl) {
        return Image.network(
          imageUrl,
          //fit: BoxFit.cover,
          //width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/diomedes_joven.jpg',
              //fit: BoxFit.cover,
              //width: double.infinity,
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
        enableInfiniteScroll: true,
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
            color: _currentIndex == entry.key
                ? AppColors.accentColor
                : AppColors.primaryColor,
          ),
        );
      }).toList(),
    );
  }

  /*Widget _buildDescriptionInfo(String texto) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Text(
        texto,
        style: TextStyle(
          color: AppColors.primaryColor,
          fontFamily: 'GothamBook',
          fontSize: 12.sp,
        ),
        softWrap: true, // Esto permite el salto de línea
        overflow: TextOverflow
            .visible, // O usa TextOverflow.ellipsis si prefieres puntos suspensivos
      ),
    );
  }*/

  Widget _buildDetailInfo(String texto, {bool isDescription = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: isDescription
          ? Text(
              texto,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: 'GothamBook',
                fontSize: 12.sp,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            )
          : Row(
              children: [
                Text(
                  texto,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'GothamBook',
                    fontSize: 12.sp,
                  ),
                ),
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
            style: TextStyle(
              color: AppColors.primaryColor,
              fontFamily: 'GothamBook',
              fontSize: 12.sp,
            ),
          ),
          Text(
            _translateStatus(status),
            style: TextStyle(
              color: AppColors.primaryColor,
              fontFamily: 'GothamMedium',
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            Icons.edit,
            'Editar',
            AppColors.secondaryColor,
            AppColors.primaryColor,
            () {
              // Acción editar
            },
          ),
          _buildActionButton(
            Icons.check_circle_outline,
            'Completado',
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.2),
            () {
              // Acción completado
            },
          ),
          ElevatedButton.icon(
            onPressed: widget.onDelete,
            icon: Icon(
              Icons.delete,
              size: 16.sp,
              color: AppColors.primaryColor,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor.withOpacity(0.2),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
            ),
            label: Text(
              'Eliminar publicación',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 10.sp,
                fontFamily: 'GothamMedium',
              ),
            ),
          ),
        ],
      ),
      Row(
        children: [
          ElevatedButton.icon(
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
              Icons.delete,
              size: 16.sp,
              color: AppColors.primaryColor,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor.withOpacity(0.2),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
            ),
            label: Text(
              'Ver postulaciones',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 10.sp,
                fontFamily: 'GothamMedium',
              ),
            ),
          ),
        ],
      )
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
      icon: Icon(icon, size: 16.sp, color: textColor),
      label: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10.sp,
          fontFamily: 'GothamMedium',
        ),
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
