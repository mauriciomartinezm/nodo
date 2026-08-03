import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nodo/features/chat/screens/chat_1.dart';
import 'package:nodo/features/create_post/logic/create_post_service.dart';
import 'package:nodo/features/edit_post/logic/edit_post_controller.dart';
import 'package:nodo/features/edit_post/screens/edit_post_screen.dart';
import 'package:nodo/features/posts/logic/applications_service.dart';
import 'package:nodo/features/posts/models/job_application.dart';
import 'package:nodo/features/posts/screens/applications_screen.dart';
import '../../../core/theme/app_theme.dart';
import 'package:nodo/features/posts/logic/posts_controller.dart';
import 'package:nodo/features/posts/utils/post_format_utils.dart';
import 'package:nodo/features/posts/utils/post_status.dart';
import 'package:nodo/shared/providers/user_provider.dart';
import 'package:provider/provider.dart';

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

  JobApplication? _acceptedApplication;
  bool _loadingApplication = false;
  bool _clientHasConfirmed = false;
  bool _workerHasConfirmed = false;

  @override
  void initState() {
    super.initState();
    imageList = parsePostImages(widget.publicacion['photos']);
    if (widget.publicacion['status'] == 'in_progress') {
      _loadAcceptedApplication();
    }
  }

  Future<void> _loadAcceptedApplication() async {
    setState(() => _loadingApplication = true);
    try {
      final apps = await ApplicationsService()
          .getApplicationsByPostId(widget.publicacion['id']);
      final accepted = apps.where((a) => a.status == 'accepted').firstOrNull;
      if (mounted) {
        setState(() {
          _acceptedApplication = accepted;
          _clientHasConfirmed = accepted?.clientCompletionRequest ?? false;
          _workerHasConfirmed = accepted?.workerCompletionRequest ?? false;
          _loadingApplication = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingApplication = false);
    }
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
                      style: AppTypography.body.copyWith(
                          color: AppColors.blue.withValues(alpha: 0.85)),
                    ),
                    SizedBox(height: 16.h),
                    Divider(
                        color: AppColors.slateGrey.withValues(alpha: 0.3)),
                    SizedBox(height: 8.h),
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      'Publicado',
                      formatPostDate(widget.publicacion['postDate']),
                    ),
                    _buildInfoRow(
                      Icons.location_on_outlined,
                      'Ubicación',
                      widget.publicacion['location'] ?? 'Sin ubicación',
                    ),
                    _buildInfoRow(
                      Icons.event_outlined,
                      'Fecha límite',
                      formatPostDate(widget.publicacion['deadline']),
                    ),
                    _buildInfoRow(
                      Icons.attach_money,
                      'Presupuesto',
                      '\$${formatBudget(widget.publicacion['budget'])}',
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
            style: AppTypography.body.copyWith(color: AppColors.blue),
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
    final color = postStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        translatePostStatus(status),
        style: AppTypography.caption.copyWith(color: color),
      ),
    );
  }

  Widget _buildActionButtons() {
    final estado = widget.publicacion['status'];

    if (estado == 'in_progress') {
      return _buildInProgressActions();
    }

    final buttons = <Widget>[
      if (estado != 'finished')
        _buildActionButton(
          Icons.edit_outlined,
          'Editar',
          AppColors.blue,
          AppColors.blue.withValues(alpha: 0.1),
          () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => EditPostController(
                    CreatePostService(),
                    widget.postsController,
                    widget.publicacion['id'],
                    widget.publicacion,
                  ),
                  child: const EditPostScreen(),
                ),
              ),
            );
          },
        ),
      if (estado != 'finished')
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
      if (estado != 'finished')
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

    return Wrap(spacing: 10.w, runSpacing: 10.h, children: buttons);
  }

  Widget _buildInProgressActions() {
    if (_loadingApplication) {
      return const Center(child: CircularProgressIndicator());
    }

    final workerName = _acceptedApplication?.workerName ?? 'el trabajador';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Completion status panel
        _buildCompletionStatusPanel(workerName),
        SizedBox(height: 12.h),
        // Chat button
        SizedBox(
          width: double.infinity,
          child: _buildActionButton(
            Icons.chat_bubble_outline,
            'Chat con $workerName',
            AppColors.blue,
            AppColors.blue.withValues(alpha: 0.1),
            () {
              final currentUserId =
                  Provider.of<UserProvider>(context, listen: false).user?.id ??
                      '';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    applicationId: _acceptedApplication!.id,
                    currentUserId: currentUserId,
                    otherPersonName: workerName,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),

        // Boton de cinfirmacion
        if (!_clientHasConfirmed)
          SizedBox(
            width: double.infinity,
            child: _buildActionButton(
              Icons.check_circle_outline,
              'Confirmar finalización',
              AppColors.success,
              AppColors.success.withValues(alpha: 0.12),
              () => _confirmarFinalizacion(widget.publicacion['id']),
            ),
          ),
      ],
    );
  }

  Widget _buildCompletionStatusPanel(String workerName) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blue.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado de finalización',
            style: AppTypography.label.copyWith(color: AppColors.blue),
          ),
          SizedBox(height: 10.h),
          _buildConfirmationRow(
            icon: Icons.person_outline,
            label: 'Tú',
            confirmed: _clientHasConfirmed,
          ),
          SizedBox(height: 6.h),
          _buildConfirmationRow(
            icon: Icons.construction_outlined,
            label: workerName,
            confirmed: _workerHasConfirmed,
          ),
          if (_clientHasConfirmed && !_workerHasConfirmed) ...[
            SizedBox(height: 10.h),
            Text(
              'Esperando confirmación del trabajador…',
              style: AppTypography.caption
                  .copyWith(color: AppColors.slateGrey),
            ),
          ],
          if (!_clientHasConfirmed && _workerHasConfirmed) ...[
            SizedBox(height: 10.h),
            Text(
              'El trabajador ya confirmó. Confirma tu parte para cerrar el trabajo.',
              style: AppTypography.caption.copyWith(color: AppColors.orange),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConfirmationRow({
    required IconData icon,
    required String label,
    required bool confirmed,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.blue.withValues(alpha: 0.6)),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(color: AppColors.blue),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(
          confirmed ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 18.sp,
          color: confirmed ? AppColors.success : AppColors.slateGrey,
        ),
        SizedBox(width: 4.w),
        Text(
          confirmed ? 'Confirmado' : 'Pendiente',
          style: AppTypography.caption.copyWith(
            color: confirmed ? AppColors.success : AppColors.slateGrey,
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
        title: const Text('Confirmar finalización'),
        content: const Text(
            'Al confirmar, el trabajo se cerrará cuando el trabajador también lo confirme. ¿Estás de acuerdo?'),
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

    if (confirmado != true) return;

    try {
      final result =
          await widget.postsController.finishJob(idPublicacion.toString());

      if (!mounted) return;

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al confirmar la finalización.')),
        );
        return;
      }

      final completed = result['completed'] as bool? ?? false;

      if (completed) {
        setState(() {
          widget.publicacion['status'] = 'finished';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('¡Trabajo finalizado con éxito! Ambos confirmaron.')),
        );
      } else {
        setState(() {
          _clientHasConfirmed = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Confirmación enviada. Esperando que el trabajador confirme también.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al confirmar: ${e.toString()}')),
      );
    }
  }
}
