import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class BarraNavegacionWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;

  const BarraNavegacionWidget({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  static const _items = [
    (icon: Icons.article_outlined,       iconActive: Icons.article_rounded,        label: 'Publicaciones'),
    (icon: Icons.work_outline_rounded,   iconActive: Icons.work_rounded,           label: 'Trabajos'),
    (icon: Icons.notifications_outlined, iconActive: Icons.notifications_rounded,  label: 'Avisos'),
    (icon: Icons.menu_rounded,           iconActive: Icons.menu_rounded,           label: 'Menú'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.blue,
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60.h + (bottomPadding > 0 ? 0 : 4.h),
          child: Row(
            children: List.generate(_items.length, (i) {
              final isSelected = currentIndex == i;
              final isMenu = i == 3;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (isMenu) {
                      Scaffold.of(context).openEndDrawer();
                    } else {
                      onIndexChanged(i);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSelected ? 14.w : 0,
                            vertical: isSelected ? 5.h : 0,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.white.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            isSelected
                                ? _items[i].iconActive
                                : _items[i].icon,
                            size: 22.r,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.45),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontFamily:
                                isSelected ? 'GothamMedium' : 'GothamBook',
                            fontSize: 9.5.sp,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.45),
                            height: 1,
                          ),
                          child: Text(_items[i].label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
