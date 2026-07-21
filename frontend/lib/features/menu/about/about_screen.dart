import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import '../settings/widgets/settings_sub_header.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      body: Column(
        children: [
          const SettingsSubHeader(
            title: 'Acerca de NODO',
            subtitle: 'Legal, privacidad y más',
            icon: Icons.info_outline_rounded,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                _card(context, [
                  _tile(
                    context,
                    icon: Icons.article_outlined,
                    color: AppColors.blue,
                    title: 'Política de tratamiento de datos',
                    subtitle: 'Cómo usamos tu información',
                    onTap: () {},
                  ),
                  _tile(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    color: const Color(0xFF1565C0),
                    title: 'Política de privacidad',
                    subtitle: 'Tus derechos y nuestra responsabilidad',
                    onTap: () {},
                  ),
                  _tile(
                    context,
                    icon: Icons.people_outline_rounded,
                    color: const Color(0xFF6A1B9A),
                    title: 'Créditos / Equipo de desarrollo',
                    subtitle: 'Conoce a quienes construyeron NODO',
                    onTap: () => Navigator.pushNamed(context, '/Credits'),
                  ),
                ]),
                SizedBox(height: 12.h),
                _card(context, [
                  _tile(
                    context,
                    icon: Icons.hub_outlined,
                    color: AppColors.orange,
                    title: 'No pierdas el hilo, sigue el NODO',
                    subtitle: 'Síguenos en redes sociales',
                    onTap: () {},
                    titleColor: AppColors.orange,
                  ),
                ]),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    'Versión NODO 2025\nTodos los derechos reservados.',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.slateGrey),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
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
}
