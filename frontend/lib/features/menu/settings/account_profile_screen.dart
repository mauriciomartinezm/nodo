import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'widgets/settings_sub_header.dart';

class AccountProfileScreen extends StatefulWidget {
  const AccountProfileScreen({super.key});

  @override
  State<AccountProfileScreen> createState() => _AccountProfileScreenState();
}

class _AccountProfileScreenState extends State<AccountProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      body: Column(
        children: [
          const SettingsSubHeader(
            title: 'Cuenta y perfil',
            subtitle: 'Gestiona tus datos personales',
            icon: Icons.person_outline_rounded,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                _card([
                  _tile(
                    icon: Icons.edit_outlined,
                    color: AppColors.blue,
                    title: 'Editar perfil',
                    subtitle: 'Nombres, contacto, descripción y rubros',
                    onTap: () => Navigator.pushNamed(context, '/editProfile'),
                  ),
                  _tile(
                    icon: Icons.lock_outline_rounded,
                    color: const Color(0xFF1565C0),
                    title: 'Cambiar contraseña',
                    subtitle: 'Actualiza tu contraseña de acceso',
                    onTap: _changePassword,
                  ),
                ]),
                SizedBox(height: 12.h),
                _card([
                  _tile(
                    icon: Icons.delete_outline_rounded,
                    color: AppColors.error,
                    title: 'Eliminar cuenta',
                    subtitle: 'Esta acción es permanente e irreversible',
                    onTap: _deleteModal,
                    titleColor: AppColors.error,
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: List.generate(children.length, (i) {
          final isLast = i == children.length - 1;
          return Column(
            children: [
              children[i],
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 56.w,
                  color: AppColors.slateGrey.withValues(alpha: 0.15),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20.r),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTypography.label.copyWith(
                        color: titleColor ?? AppColors.blue,
                        fontFamily: 'GothamMedium',
                      )),
                  SizedBox(height: 2.h),
                  Text(subtitle,
                      style: AppTypography.caption
                          .copyWith(color: AppColors.slateGrey)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.slateGrey, size: 20.r),
          ],
        ),
      ),
    );
  }

  void _changePassword() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cambiar contraseña',
            style: AppTypography.title.copyWith(color: AppColors.blue),
            textAlign: TextAlign.center),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _passwordField(currentCtrl, 'Contraseña actual'),
              SizedBox(height: 12.h),
              _passwordField(newCtrl, 'Nueva contraseña'),
              SizedBox(height: 12.h),
              _passwordField(confirmCtrl, 'Confirmar nueva contraseña'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style: AppTypography.label.copyWith(color: AppColors.slateGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (newCtrl.text != confirmCtrl.text) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Las contraseñas no coinciden'),
                  backgroundColor: AppColors.error,
                ));
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Contraseña actualizada'),
                backgroundColor: AppColors.success,
              ));
            },
            child: Text('Actualizar', style: AppTypography.label),
          ),
        ],
      ),
    );
  }

  Widget _passwordField(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      obscureText: true,
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.body.copyWith(color: AppColors.slateGrey),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
    );
  }

  void _deleteModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: AppColors.slateGrey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.warning_amber_rounded,
                  color: AppColors.error, size: 36.r),
            ),
            SizedBox(height: 16.h),
            Text('Eliminar cuenta',
                style:
                    AppTypography.title.copyWith(color: AppColors.error)),
            SizedBox(height: 8.h),
            Text(
              'Esta acción es PERMANENTE. Perderás tu perfil, publicaciones, historial, calificaciones y todos tus datos en NODO.',
              style: AppTypography.body.copyWith(color: AppColors.slateGrey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text('Eliminar mi cuenta',
                    style: AppTypography.label
                        .copyWith(color: AppColors.white)),
              ),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar',
                  style: AppTypography.label
                      .copyWith(color: AppColors.slateGrey)),
            ),
          ],
        ),
      ),
    );
  }
}
