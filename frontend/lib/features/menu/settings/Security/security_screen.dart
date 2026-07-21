import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import '../widgets/settings_sub_header.dart';

class SecuritysScreen extends StatelessWidget {
  const SecuritysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      body: Column(
        children: [
          const SettingsSubHeader(
            title: 'Seguridad',
            subtitle: 'Protege tu cuenta',
            icon: Icons.shield_outlined,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                _card(context, [
                  _tile(
                    context,
                    icon: Icons.verified_user_outlined,
                    color: const Color(0xFF1565C0),
                    title: 'Autenticación en dos pasos',
                    subtitle: 'Añade una capa extra de seguridad',
                    available: false,
                  ),
                  _tile(
                    context,
                    icon: Icons.devices_outlined,
                    color: AppColors.blue,
                    title: 'Dispositivos conectados',
                    subtitle: 'Gestiona los dispositivos con acceso',
                    available: false,
                  ),
                ]),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.orange.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.construction_outlined,
                          color: AppColors.orange, size: 16.r),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Estas funciones están en desarrollo y estarán disponibles próximamente.',
                          style: AppTypography.caption
                              .copyWith(color: AppColors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, List<Widget> children) {
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

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    bool available = true,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: available ? onTap : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: available ? 0.1 : 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: available
                      ? color
                      : color.withValues(alpha: 0.3),
                  size: 20.r),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTypography.label.copyWith(
                        color: available
                            ? AppColors.blue
                            : AppColors.slateGrey,
                        fontFamily: 'GothamMedium',
                      )),
                  SizedBox(height: 2.h),
                  Text(subtitle,
                      style: AppTypography.caption
                          .copyWith(color: AppColors.slateGrey)),
                ],
              ),
            ),
            if (!available)
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Pronto',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.orange)),
              )
            else
              Icon(Icons.chevron_right_rounded,
                  color: AppColors.slateGrey, size: 20.r),
          ],
        ),
      ),
    );
  }
}
