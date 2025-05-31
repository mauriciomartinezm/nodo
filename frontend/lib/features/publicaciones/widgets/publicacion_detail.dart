import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  final List<String> imageList = [
    'assets/images/diomedes_joven.jpg',
    'assets/images/diomedes_joven.jpg',
    'assets/images/diomedes_joven.jpg',
  ];

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
                _buildDetailInfo(widget.publicacion['descripcion_necesidad'] ?? 'Sin descripción'),
                _buildDetailInfo('Publicado: ${_formatDate(widget.publicacion['fecha_publicacion'])}'),
                _buildDetailInfo('Ubicación: ${widget.publicacion['ubicacion'] ?? 'Sin ubicación'}'),
                _buildDetailInfo('Fecha límite: ${_formatDate(widget.publicacion['fecha_limite'])}'),
                _buildDetailInfo('Presupuesto: \$${widget.publicacion['presupuesto']?.toString() ?? '0'}'),
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
      items: imageList.map((imagePath) {
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
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

  Widget _buildDetailInfo(String texto) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
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
    return Row(
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
    );
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