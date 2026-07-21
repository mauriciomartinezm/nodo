import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import '../widgets/settings_sub_header.dart';

class PaymentsBillings extends StatelessWidget {
  const PaymentsBillings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      body: Column(
        children: [
          const SettingsSubHeader(
            title: 'Pagos y facturación',
            subtitle: 'Métodos, historial e ingresos',
            icon: Icons.credit_card_outlined,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                _sectionLabel('Pagos'),
                _card(context, [
                  _tile(
                    context,
                    icon: Icons.credit_card_outlined,
                    color: const Color(0xFF6A1B9A),
                    title: 'Métodos de pago',
                    subtitle: 'Tarjetas y cuentas registradas',
                    route: '/PaymentsMethods',
                  ),
                  _tile(
                    context,
                    icon: Icons.receipt_long_outlined,
                    color: AppColors.blue,
                    title: 'Historial de transacciones',
                    subtitle: 'Revisa tus movimientos',
                    available: false,
                  ),
                ]),
                SizedBox(height: 12.h),
                _sectionLabel('Ingresos y tarifas'),
                _card(context, [
                  _tile(
                    context,
                    icon: Icons.account_balance_wallet_outlined,
                    color: const Color(0xFF00897B),
                    title: 'Ingresos obtenidos',
                    subtitle: 'Tu balance en NODO',
                    route: '/YourIncome',
                  ),
                  _tile(
                    context,
                    icon: Icons.percent_rounded,
                    color: AppColors.orange,
                    title: 'Comisiones y tarifas',
                    subtitle: 'Conoce las tarifas de la plataforma',
                    route: '/CommissionsFeesScreen',
                  ),
                  _tile(
                    context,
                    icon: Icons.calculate_outlined,
                    color: const Color(0xFF1565C0),
                    title: 'Calculadora de ganancias',
                    subtitle: 'Estima cuánto recibirás por un trabajo',
                    route: '/CommissionCalculatorScreen',
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.caption.copyWith(
          color: AppColors.slateGrey,
          letterSpacing: 1.0,
        ),
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
    String? route,
    bool available = true,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: (available && route != null)
          ? () => Navigator.pushNamed(context, route)
          : null,
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
