import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class PublicacionTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const PublicacionTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ['Activas', 'En Proceso', 'Finalizadas'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(tabs.length, (index) {
          final bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onTabChanged(index),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 9.r, horizontal: 8.r),
              margin: EdgeInsets.only(right: 5.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.blue
                    : AppColors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.blue,
                  fontFamily: 'GothamMedium',
                  fontSize: 10.sp,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}