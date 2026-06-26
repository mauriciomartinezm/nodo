import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nodo/features/posts/screens/applications_screen.dart';
import '../../../core/theme/app_theme.dart';
import 'package:nodo/features/posts/logic/posts_controller.dart';

class PostDetail extends StatefulWidget {
  final dynamic publicacion;
  final VoidCallback onDelete;
  final PostsController postsController;

  const PostDetail({
    super.key,
    required this.publicacion,
    required this.onDelete,
    required this.postsController,
  });

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  int _currentIndex = 0;
  late List<String> imageList;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    imageList = _parseImages(widget.publicacion['photos']);
  }

  List<String> _parseImages(dynamic fotos) {
    if (fotos is List) {
      return fotos.map((url) => url.toString()).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.alphaBlend(
          AppColors.blue.withValues(alpha: 0.03), Colors.white),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blue),
        title: Text(
          'Detalle de publicación',
          style: AppTypography.title.copyWith(color: AppColors.orange),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageCarousel(),
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Container(
                padding: EdgeInsets.all(18.r),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.publicacion['title'] ?? 'Sin título',
                            style: AppTypography.title
                                .copyWith(color: AppColors.blue),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _buildStatusChip(widget.publicacion['status']),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      widget.publicacion['description'] ?? 'Sin descripción',
                      style: AppTypography.body
                          .copyWith(color: AppColors.blue.withValues(alpha: 0.85)),
                    ),
                    SizedBox(height: 16.h),
                    Divider(color: AppColors.slateGrey.withValues(alpha: 0.3)),
                    SizedBox(height: 8.h),
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      'Publicado',
                      _formatDate(widget.publicacion['postDate']),
                    ),
                    _buildInfoRow(
                      Icons.location_on_outlined,
                      'Ubicación',
                      widget.publicacion['location'] ?? 'Sin ubicación',
                    ),
                    _buildInfoRow(
                      Icons.event_outlined,
                      'Fecha límite',
                      _formatDate(widget.publicacion['deadline']),
                    ),
                    _buildInfoRow(
                      Icons.attach_money,
                      'Presupuesto',
                      '\$${widget.publicacion['budget']?.toString() ?? '0'}',
                    ),
                    SizedBox(height: 16.h),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    if (imageList.isEmpty) {
      return Container(
        height: 220.h,
        width: double.infinity,
        color: AppColors.blue.withValues(alpha: 0.06),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_not_supported_outlined,
                size: 36.sp, color: AppColors.blue.withValues(alpha: 0.4)),
            SizedBox(height: 8.h),
            Text(
              'Esta publicación no tiene imágenes',
              style: AppTypography.body.copyWith(color: AppColors.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          items: imageList.map((imageUrl) {
            return Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            );
          }).toList(),
          options: CarouselOptions(
            height: 220.h,
            viewportFraction: 1,
            enlargeCenterPage: false,
            enableInfiniteScroll: imageList.length > 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        if (imageList.length > 1)
          Positioned(
            bottom: 12.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageList.asMap().entries.map((entry) {
                final bool isActive = _currentIndex == entry.key;
                return GestureDetector(
                  onTap: () => _carouselController.animateToPage(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 9.w : 7.w,
                    height: isActive ? 9.w : 7.w,
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? AppColors.orange : AppColors.white,
                      border: Border.all(color: AppColors.white, width: 1),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: AppColors.orange),
          SizedBox(width: 10.w),
          Text(
            '$label: ',
            style: AppTypography.body.copyWith(
              color: AppColors.blue
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.body.copyWith(color: AppColors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _statusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _translateStatus(status),
        style: AppTypography.caption.copyWith(
          color: color,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
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

  Widget _buildActionButtons() {
    final estado = widget.publicacion['status'];
    final buttons = <Widget>[
      if (estado != 'in_progress' && estado != 'finished')
        _buildActionButton(
          Icons.edit_outlined,
          'Editar',
          AppColors.blue,
          AppColors.blue.withValues(alpha: 0.1),
          () {
            // Acción editar
          },
        ),
      if (estado != 'in_progress' && estado != 'finished')
        _buildActionButton(
          Icons.person_outline,
          'Postulaciones',
          AppColors.blue,
          AppColors.blue.withValues(alpha: 0.1),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ApplicationsScreen(
                  postId: widget.publicacion['id'],
                ),
              ),
            );
          },
        ),
      if (estado == 'in_progress')
        _buildActionButton(
          Icons.check_circle_outline,
          'Completado',
          AppColors.success,
          AppColors.success.withValues(alpha: 0.12),
          () => _confirmarFinalizacion(widget.publicacion['id']),
        ),
      if (estado != 'in_progress' && estado != 'finished')
        _buildActionButton(
          Icons.delete_outline,
          'Eliminar',
          AppColors.error,
          AppColors.error.withValues(alpha: 0.1),
          () {
            widget.onDelete();
          },
        ),
    ];

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: buttons,
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
      icon: Icon(icon, size: 18.sp, color: textColor),
      label: Text(
        text,
        style: AppTypography.body.copyWith(color: textColor),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
        final success = await widget.postsController
            .finishJob(idPublicacion.toString());

        if (success) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trabajo marcado como finalizado.')),
          );
        }

        setState(() {
          widget.publicacion['status'] = 'finished';
        });
      } catch (e) {
        if (!mounted) return;
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
}
