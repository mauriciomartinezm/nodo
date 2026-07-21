import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

/// Campo con apariencia de TextField que, al tocarlo, abre una lista con
/// buscador para elegir una sola opción (a diferencia de
/// [MultiSelectDropdown], que permite varias).
class SearchableDropdownField<T> extends StatelessWidget {
  final String label;
  final List<T> options;
  final String Function(T option) labelBuilder;
  final T? value;
  final ValueChanged<T> onChanged;
  final IconData? icon;
  final String searchHint;
  final String emptyMessage;

  const SearchableDropdownField({
    super.key,
    required this.label,
    required this.options,
    required this.labelBuilder,
    required this.onChanged,
    this.value,
    this.icon,
    this.searchHint = 'Buscar...',
    this.emptyMessage = 'Sin resultados',
  });

  Future<void> _openPicker(BuildContext context) async {
    final result = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        var query = '';
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filtered = options
                .where((o) => labelBuilder(o)
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList();

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style:
                          AppTypography.subtitle.copyWith(color: AppColors.blue),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      autofocus: true,
                      onChanged: (text) => setSheetState(() => query = text),
                      style: AppTypography.body,
                      decoration: InputDecoration(
                        hintText: searchHint,
                        prefixIcon: Icon(Icons.search,
                            size: 18.r, color: AppColors.slateGrey),
                        filled: true,
                        fillColor: AppColors.blue.withValues(alpha: 0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 14.w,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.45,
                      ),
                      child: filtered.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Text(
                                emptyMessage,
                                style: AppTypography.label
                                    .copyWith(color: AppColors.slateGrey),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final option = filtered[index];
                                final isSelected = option == value;
                                return ListTile(
                                  title: Text(
                                    labelBuilder(option),
                                    style: AppTypography.body.copyWith(
                                      color: AppColors.blue,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? Icon(Icons.check,
                                          color: AppColors.blue, size: 18.r)
                                      : null,
                                  onTap: () => Navigator.pop(context, option),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openPicker(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTypography.body.copyWith(color: AppColors.slateGrey),
          prefixIcon: icon != null
              ? Icon(icon, size: 18.r, color: AppColors.slateGrey)
              : null,
          suffixIcon: Icon(Icons.arrow_drop_down, color: AppColors.slateGrey),
          filled: true,
          fillColor: AppColors.blue.withValues(alpha: 0.04),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                width: 1.r, color: AppColors.slateGrey.withValues(alpha: 0.4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 1.6.r, color: AppColors.blue),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 14.w,
          ),
        ),
        child: Text(
          value != null ? labelBuilder(value as T) : '',
          style: AppTypography.body.copyWith(color: AppColors.blue),
        ),
      ),
    );
  }
}
