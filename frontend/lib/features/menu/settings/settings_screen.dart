import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              children: [
                _sectionCard(
                  context,
                  label: 'Cuenta',
                  items: [
                    _Item(
                      icon: Icons.person_outline_rounded,
                      color: AppColors.blue,
                      title: 'Perfil y datos',
                      subtitle: 'Edita tu información personal',
                      route: '/AccountProfileScreen',
                    ),
                    _Item(
                      icon: Icons.shield_outlined,
                      color: const Color(0xFF1565C0),
                      title: 'Seguridad',
                      subtitle: 'Contraseña y acceso',
                      route: '/SecuritysScreen',
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _sectionCard(
                  context,
                  label: 'Aplicación',
                  items: [
                    _Item(
                      icon: Icons.notifications_outlined,
                      color: AppColors.orange,
                      title: 'Notificaciones',
                      subtitle: 'Controla cómo te avisamos',
                      route: '/NotificationSettingsScreen',
                    ),
                    _Item(
                      icon: Icons.tune_rounded,
                      color: const Color(0xFF00897B),
                      title: 'Preferencias',
                      subtitle: 'Idioma y ubicación',
                      route: '/PreferencesScreen',
                    ),
                    _Item(
                      icon: Icons.credit_card_outlined,
                      color: const Color(0xFF6A1B9A),
                      title: 'Pagos y facturación',
                      subtitle: 'Métodos, historial e ingresos',
                      route: '/PaymentsBillings',
                    ),
                    _Item(
                      icon: Icons.info_outline_rounded,
                      color: AppColors.slateGrey,
                      title: 'Acerca de',
                      subtitle: 'Políticas, créditos y versión',
                      route: '/About',
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          8.w, MediaQuery.of(context).padding.top + 8.h, 16.w, 20.h),
      decoration: const BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.white, size: 20.r),
          ),
          Expanded(
            child: Text(
              'Ajustes',
              style: AppTypography.subtitle.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(BuildContext context,
      {required String label, required List<_Item> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label.toUpperCase(),
            style: AppTypography.caption.copyWith(
              color: AppColors.slateGrey,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
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
            children: List.generate(items.length, (i) {
              final item = items[i];
              final isLast = i == items.length - 1;
              return Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.vertical(
                      top: i == 0 ? const Radius.circular(16) : Radius.zero,
                      bottom: isLast
                          ? const Radius.circular(16)
                          : Radius.zero,
                    ),
                    onTap: item.route != null
                        ? () => Navigator.pushNamed(context, item.route!)
                        : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: item.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item.icon,
                                color: item.color, size: 20.r),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title,
                                    style: AppTypography.label.copyWith(
                                      color: AppColors.blue,
                                      fontFamily: 'GothamMedium',
                                    )),
                                SizedBox(height: 2.h),
                                Text(item.subtitle,
                                    style: AppTypography.caption.copyWith(
                                        color: AppColors.slateGrey)),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded,
                              color: AppColors.slateGrey, size: 20.r),
                        ],
                      ),
                    ),
                  ),
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
        ),
      ],
    );
  }
}

class _Item {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String? route;

  const _Item({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.route,
  });
}
