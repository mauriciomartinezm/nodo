import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/chat/screens/chat_1.dart';
import 'package:nodo/features/posts/logic/applications_controller.dart';
import 'package:nodo/features/posts/logic/applications_service.dart';
import 'package:nodo/features/posts/logic/posts_controller.dart';
import 'package:nodo/features/posts/models/job_application.dart';
import 'package:nodo/shared/providers/user_provider.dart';

class ApplicationsScreen extends StatelessWidget {
  final String postId;
  const ApplicationsScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ApplicationsController(ApplicationsService(), postId),
      child: const _ApplicationsView(),
    );
  }
}

class _ApplicationsView extends StatelessWidget {
  const _ApplicationsView();

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  (String, Color) _statusLabel(String status) => switch (status) {
        'accepted' => ('Aceptado', AppColors.success),
        'rejected' => ('Rechazado', AppColors.error),
        _ => ('Pendiente', AppColors.orange),
      };

  void _openDetail(
      BuildContext context, JobApplication app, ApplicationsController ctrl) {
    // Capturar referencias síncronas antes de cualquier async / modal
    final postsCtrl = Provider.of<PostsController>(context, listen: false);
    final userId =
        Provider.of<UserProvider>(context, listen: false).user?.id ?? '';
    final navigator = Navigator.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _WorkerDetailSheet(
        application: app,
        controller: ctrl,
        initials: _initials(app.workerName),
        onGoToChat: () {
          navigator.pop();
          navigator.push(
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                applicationId: app.id,
                currentUserId: userId,
                otherPersonName: app.workerName,
              ),
            ),
          );
        },
        onAccepted: () {
          postsCtrl.requestHomeTab(0);
          postsCtrl.setSelectedIndex(1);
          postsCtrl.highlightPost(ctrl.postId);
          postsCtrl.loadPosts();
          navigator.popUntil((route) => route.isFirst);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ApplicationsController>();

    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blue),
        title: Text(
          'Postulaciones',
          style: AppTypography.title.copyWith(color: AppColors.orange),
        ),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.blue))
          : controller.applications.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  color: AppColors.orange,
                  onRefresh: controller.loadApplications,
                  child: ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    itemCount: controller.applications.length,
                    itemBuilder: (context, index) {
                      final app = controller.applications[index];
                      return _ApplicationCard(
                        application: app,
                        initials: _initials(app.workerName),
                        statusLabel: _statusLabel(app.status),
                        onTap: () => _openDetail(context, app, controller),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline_rounded,
                size: 48.r,
                color: AppColors.blue.withValues(alpha: 0.35),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Sin postulaciones aún',
              style: AppTypography.subtitle.copyWith(color: AppColors.blue),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Cuando un trabajador se postule a esta publicación, aparecerá aquí.',
              style: AppTypography.body.copyWith(color: AppColors.slateGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final JobApplication application;
  final String initials;
  final (String, Color) statusLabel;
  final VoidCallback onTap;

  const _ApplicationCard({
    required this.application,
    required this.initials,
    required this.statusLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (label, color) = statusLabel;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildAvatar(40.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    application.workerName,
                    style:
                        AppTypography.subtitle.copyWith(color: AppColors.blue),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(Icons.work_outline_rounded,
                          size: 12.r, color: AppColors.slateGrey),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          application.workerCategory,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.slateGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 12.r, color: AppColors.slateGrey),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          application.workerLocation,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.slateGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _statusChip(label, color),
                SizedBox(height: 8.h),
                Icon(Icons.chevron_right_rounded,
                    size: 20.r,
                    color: AppColors.slateGrey.withValues(alpha: 0.6)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(double radius) {
    if (application.workerPhoto != null &&
        application.workerPhoto!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(application.workerPhoto!),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.orange,
      child: Text(
        initials,
        style: TextStyle(
          fontFamily: 'GothamBold',
          fontSize: radius * 0.55,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontFamily: 'GothamMedium',
        ),
      ),
    );
  }
}

class _WorkerDetailSheet extends StatefulWidget {
  final JobApplication application;
  final ApplicationsController controller;
  final String initials;
  final VoidCallback onGoToChat;
  final VoidCallback onAccepted;

  const _WorkerDetailSheet({
    required this.application,
    required this.controller,
    required this.initials,
    required this.onGoToChat,
    required this.onAccepted,
  });

  @override
  State<_WorkerDetailSheet> createState() => _WorkerDetailSheetState();
}

class _WorkerDetailSheetState extends State<_WorkerDetailSheet> {
  bool _loading = false;

  Future<void> _doAction(
    Future<bool> Function() action,
    String successMsg,
    String errorMsg, {
    VoidCallback? onSuccess,
  }) async {
    setState(() => _loading = true);
    final ok = await action();
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? successMsg : errorMsg)),
    );
    if (ok) {
      if (onSuccess != null) {
        onSuccess();
      } else {
        Navigator.pop(context);
      }
    }
  }

  (String, Color) get _statusInfo => switch (widget.application.status) {
        'accepted' => ('Aceptado', AppColors.success),
        'rejected' => ('Rechazado', AppColors.error),
        _ => ('Pendiente', AppColors.orange),
      };

  @override
  Widget build(BuildContext context) {
    final app = widget.application;
    final ctrl = widget.controller;
    final (statusLabel, statusColor) = _statusInfo;
    final isPending = app.status == 'pending';
    final isAccepted = app.status == 'accepted';
    final canAccept = isPending && !ctrl.hasAcceptedApplication;

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.45,
      maxChildSize: 0.93,
      expand: false,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              decoration: BoxDecoration(
                color: AppColors.slateGrey.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Scrollable content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  SizedBox(height: 8.h),
                  // Avatar + name + status
                  Center(child: _buildAvatar(app, 40.r)),
                  SizedBox(height: 14.h),
                  Center(
                    child: Text(
                      app.workerName,
                      style: AppTypography.title.copyWith(color: AppColors.blue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusLabel,
                        style: AppTypography.caption.copyWith(
                          color: statusColor,
                          fontFamily: 'GothamMedium',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Info section
                  _buildInfoSection(app),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
            // Action buttons
            if (!_loading)
              _buildActions(app, canAccept, isPending, isAccepted, ctrl)
            else
              Padding(
                padding: EdgeInsets.all(20.r),
                child: const CircularProgressIndicator(color: AppColors.blue),
              ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(JobApplication app, double radius) {
    if (app.workerPhoto != null && app.workerPhoto!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(app.workerPhoto!),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.orange,
      child: Text(
        widget.initials,
        style: TextStyle(
          fontFamily: 'GothamBold',
          fontSize: radius * 0.55,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoSection(JobApplication app) {
    return Container(
      decoration: BoxDecoration(
        color: Color.alphaBlend(
            AppColors.blue.withValues(alpha: 0.03), Colors.white),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.slateGrey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          _infoRow(Icons.work_outline_rounded, 'Rubro', app.workerCategory),
          _divider(),
          _infoRow(Icons.location_on_outlined, 'Ubicación', app.workerLocation),
          _divider(),
          _infoRow(Icons.email_outlined, 'Correo', app.workerEmail),
          _divider(),
          _infoRow(Icons.phone_outlined, 'Teléfono', app.workerPhone),
          if (app.workerDescription != null &&
              app.workerDescription!.isNotEmpty) ...[
            _divider(),
            _infoRow(Icons.description_outlined, 'Descripción',
                app.workerDescription!),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.r, color: AppColors.orange),
          SizedBox(width: 10.w),
          SizedBox(
            width: 76.w,
            child: Text(
              label,
              style: AppTypography.label.copyWith(color: AppColors.slateGrey),
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

  Widget _divider() => Divider(
        height: 1,
        indent: 14.w,
        endIndent: 14.w,
        color: AppColors.slateGrey.withValues(alpha: 0.2),
      );

  Widget _buildActions(
    JobApplication app,
    bool canAccept,
    bool isPending,
    bool isAccepted,
    ApplicationsController ctrl,
  ) {
    final buttons = <Widget>[];

    // Chat — siempre visible cuando hay postulación activa
    buttons.add(
      Expanded(
        child: _actionButton(
          icon: Icons.chat_bubble_outline_rounded,
          label: 'Chatear',
          bgColor: AppColors.blue.withValues(alpha: 0.09),
          fgColor: AppColors.blue,
          onTap: widget.onGoToChat,
        ),
      ),
    );

    if (isPending) {
      buttons.add(SizedBox(width: 8.w));
      // Rechazar
      buttons.add(
        Expanded(
          child: _actionButton(
            icon: Icons.close_rounded,
            label: 'Rechazar',
            bgColor: AppColors.error.withValues(alpha: 0.09),
            fgColor: AppColors.error,
            onTap: () => _doAction(
              () => ctrl.rejectApplication(app.id),
              'Postulación rechazada',
              'Error al rechazar',
            ),
          ),
        ),
      );
      if (canAccept) {
        buttons.add(SizedBox(width: 8.w));
        // Aceptar
        buttons.add(
          Expanded(
            child: _actionButton(
              icon: Icons.check_rounded,
              label: 'Aceptar',
              bgColor: AppColors.success.withValues(alpha: 0.12),
              fgColor: AppColors.success,
              onTap: () => _doAction(
                () => ctrl.acceptApplication(app.id),
                '¡Trabajador aceptado!',
                'Error al aceptar',
                onSuccess: widget.onAccepted,
              ),
            ),
          ),
        );
      }
    }

    if (isAccepted) {
      // Nota informativa de que ya fue aceptado
      return Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 4.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded,
                      size: 16.r, color: AppColors.success),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Trabajador aceptado para este trabajo',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.success),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Row(children: buttons),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      child: Row(children: buttons),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color fgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20.r, color: fgColor),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: fgColor,
                fontFamily: 'GothamMedium',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
