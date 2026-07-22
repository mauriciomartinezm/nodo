import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nodo/core/theme/app_theme.dart';

class StartDateFilter extends StatefulWidget {
  final DateTimeRange? initialRange;
  const StartDateFilter({super.key, this.initialRange});

  @override
  State<StartDateFilter> createState() => _StartDateFilterState();
}

class _StartDateFilterState extends State<StartDateFilter> {
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _range = widget.initialRange;
  }

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _range,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.blue,
            onPrimary: Colors.white,
            onSurface: AppColors.blue,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColors.orange),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _range = picked);
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy');
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      maxChildSize: 0.7,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text('Fecha límite',
                          style: AppTypography.title
                              .copyWith(color: AppColors.blue)),
                      const Spacer(),
                      if (_range != null)
                        TextButton(
                          onPressed: () => setState(() => _range = null),
                          child: Text('Limpiar',
                              style: AppTypography.body
                                  .copyWith(color: AppColors.orange)),
                        ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: _pickRange,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _range != null
                              ? AppColors.orange
                              : AppColors.slateGrey.withValues(alpha: 0.4),
                          width: _range != null ? 1.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _range != null
                            ? AppColors.orange.withValues(alpha: 0.05)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16.r,
                            color: _range != null
                                ? AppColors.orange
                                : AppColors.slateGrey,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            _range != null
                                ? '${fmt.format(_range!.start)}  →  ${fmt.format(_range!.end)}'
                                : 'Seleccionar rango de fechas',
                            style: AppTypography.body.copyWith(
                              color: _range != null
                                  ? AppColors.orange
                                  : AppColors.slateGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, _range),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _range != null ? 'Aplicar' : 'Aceptar',
                        style: AppTypography.label
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
