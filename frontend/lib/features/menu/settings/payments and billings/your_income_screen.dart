import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import '../widgets/settings_sub_header.dart';

class YourIncome extends StatefulWidget {
  const YourIncome({super.key});

  @override
  State<YourIncome> createState() => _YourIncomeState();
}

class _YourIncomeState extends State<YourIncome> {
  String _selected = 'Último mes';

  final _periods = ['Hoy', 'Últimos 15 días', 'Último mes', 'Último año', 'Total'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      body: Column(
        children: [
          const SettingsSubHeader(
            title: 'Tus ingresos',
            subtitle: 'Balance neto en NODO',
            icon: Icons.account_balance_wallet_outlined,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: AppColors.blue, size: 16.r),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Los valores mostrados son netos: ya se descontaron las comisiones de la pasarela y de NODO.',
                          style: AppTypography.caption
                              .copyWith(color: AppColors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _periods.map((p) {
                      final isSelected = _selected == p;
                      return GestureDetector(
                        onTap: () => setState(() => _selected = p),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: EdgeInsets.only(right: 8.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.blue
                                  : AppColors.slateGrey
                                      .withValues(alpha: 0.3),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color:
                                          AppColors.blue.withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            p,
                            style: AppTypography.caption.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.slateGrey,
                              fontFamily:
                                  isSelected ? 'GothamMedium' : 'GothamBook',
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16.h),
                _totalCard(),
                SizedBox(height: 12.h),
                _statsRow(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalCard() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue, AppColors.blue.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total ganado — $_selected',
            style:
                AppTypography.caption.copyWith(color: Colors.white70),
          ),
          SizedBox(height: 8.h),
          Text(
            '\$2.200.000',
            style: AppTypography.title.copyWith(
              color: Colors.white,
              fontSize: 28.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text('COP',
              style: AppTypography.caption.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(child: _statCard('Trabajos', '12', Icons.work_outline_rounded)),
        SizedBox(width: 10.w),
        Expanded(
            child: _statCard(
                'Promedio', '\$183.000', Icons.trending_up_rounded)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.blue, size: 18.r),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: AppTypography.label.copyWith(
                        color: AppColors.blue, fontFamily: 'GothamMedium')),
                Text(label,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.slateGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
