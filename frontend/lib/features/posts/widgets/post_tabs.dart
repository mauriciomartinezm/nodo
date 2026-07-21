import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class PostTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final List<int> counts;

  const PostTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    this.counts = const [0, 0, 0],
  });

  static const _tabs = [
    (label: 'Activas', icon: Icons.pending_actions_outlined),
    (label: 'En Proceso', icon: Icons.construction_outlined),
    (label: 'Finalizadas', icon: Icons.task_alt_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final isSelected = selectedIndex == i;
          final count = i < counts.length ? counts[i] : 0;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.blue.withValues(alpha: 0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          _tabs[i].icon,
                          size: 18.r,
                          color: isSelected
                              ? AppColors.white
                              : AppColors.blue.withValues(alpha: 0.5),
                        ),
                        if (count > 0)
                          Positioned(
                            top: -4,
                            right: -8,
                            child: Container(
                              padding: EdgeInsets.all(2.r),
                              constraints: BoxConstraints(
                                minWidth: 14.r,
                                minHeight: 14.r,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.orange
                                    : AppColors.blue.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontFamily: 'GothamBold',
                                  fontSize: 8.sp,
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.blue,
                                  height: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      _tabs[i].label,
                      style: AppTypography.caption.copyWith(
                        color: isSelected
                            ? AppColors.white
                            : AppColors.blue.withValues(alpha: 0.6),
                        fontFamily:
                            isSelected ? 'GothamMedium' : 'GothamBook',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
