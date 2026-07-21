import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/posts/utils/post_format_utils.dart';

class PostCard extends StatefulWidget {
  final dynamic item;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isHighlighted;
  final VoidCallback? onHighlightEnd;

  const PostCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
    this.isHighlighted = false,
    this.onHighlightEnd,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _anim = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    if (widget.isHighlighted) _startHighlight();
  }

  @override
  void didUpdateWidget(PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted && !oldWidget.isHighlighted) {
      _startHighlight();
    }
  }

  Future<void> _startHighlight() async {
    for (int i = 0; i < 2; i++) {
      await _animController.forward();
      await _animController.reverse();
    }
    if (mounted) widget.onHighlightEnd?.call();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imagenes = parsePostImages(widget.item['photos']);
    final bool tieneImagen = imagenes.isNotEmpty;
    final String titulo = widget.item['title'] ?? 'Sin título';
    final String descripcion = widget.item['description'] ?? '';
    final String ubicacion = widget.item['location'] ?? '';
    final String presupuesto = formatBudget(widget.item['budget']);
    final String deadline = formatPostDate(widget.item['deadline']);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          final h = _anim.value;
          return DecoratedBox(
            decoration: BoxDecoration(
              color: Color.lerp(
                AppColors.white,
                AppColors.orange.withValues(alpha: 0.06),
                h,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Color.lerp(Colors.transparent, AppColors.orange, h)!,
                width: 1 + h * 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue.withValues(alpha: 0.08 + h * 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: child!,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen: proporción fija respecto al ancho (no depende de pantalla)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
              child: AspectRatio(
                aspectRatio: 2.0,
                child: tieneImagen
                    ? Image.network(
                        imagenes.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                        loadingBuilder: (_, child, progress) =>
                            progress == null ? child : _loadingPlaceholder(),
                      )
                    : _placeholder(),
              ),
            ),

            // Contenido: apilado sin altura fija
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    titulo,
                    style: AppTypography.body.copyWith(color: AppColors.blue),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (descripcion.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      descripcion,
                      style: AppTypography.caption
                          .copyWith(color: AppColors.slateGrey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 8.h),
                  if (ubicacion.isNotEmpty) ...[
                    _infoRow(Icons.location_on_outlined, ubicacion,
                        AppColors.slateGrey),
                    SizedBox(height: 4.h),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: _infoRow(
                            Icons.event_outlined, deadline, AppColors.slateGrey),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '\$$presupuesto',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.orange,
                            fontFamily: 'GothamMedium',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 10.r, color: color),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            text,
            style: AppTypography.caption.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.blue.withValues(alpha: 0.06),
      child: Center(
        child: Icon(
          Icons.work_outline_rounded,
          color: AppColors.blue.withValues(alpha: 0.3),
          size: 36.r,
        ),
      ),
    );
  }

  Widget _loadingPlaceholder() {
    return Container(
      color: AppColors.blue.withValues(alpha: 0.04),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
