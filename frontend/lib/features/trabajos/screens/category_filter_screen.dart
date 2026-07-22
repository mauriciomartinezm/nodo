import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/trabajos/logic/job_filter.dart';
import 'package:nodo/features/trabajos/screens/category_filter_detail_screen.dart';
import 'package:nodo/features/trabajos/screens/location_filter_screen.dart';
import 'package:nodo/features/trabajos/screens/price_filter_screen.dart';
import 'package:nodo/features/trabajos/screens/post_time_screen.dart';
import 'package:nodo/features/trabajos/screens/start_date_filter.dart';

class CategoryFilterScreen extends StatefulWidget {
  final JobFilter initialFilter;
  const CategoryFilterScreen({super.key, required this.initialFilter});

  @override
  State<CategoryFilterScreen> createState() => _CategoryFilterScreenState();
}

class _CategoryFilterScreenState extends State<CategoryFilterScreen> {
  late List<String> _categoryIds;
  late String? _location;
  late double? _minPrice;
  late double? _maxPrice;
  late String? _timeFilter;
  late DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilter;
    _categoryIds = List.from(f.categoryIds);
    _location = f.location;
    _minPrice = f.minPrice;
    _maxPrice = f.maxPrice;
    _timeFilter = f.timeFilter;
    _dateRange = f.dateRange;
  }

  JobFilter get _current => JobFilter(
        categoryIds: _categoryIds,
        location: _location,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        timeFilter: _timeFilter,
        dateRange: _dateRange,
      );

  void _reset() => setState(() {
        _categoryIds = [];
        _location = null;
        _minPrice = null;
        _maxPrice = null;
        _timeFilter = null;
        _dateRange = null;
      });

  String? get _categorySubtitle => _categoryIds.isEmpty
      ? null
      : '${_categoryIds.length} seleccionada${_categoryIds.length == 1 ? '' : 's'}';

  String? get _priceSubtitle {
    if (_minPrice == null && _maxPrice == null) return null;
    if (_minPrice != null && _maxPrice != null) {
      return '\$${_minPrice!.toStringAsFixed(0)} – \$${_maxPrice!.toStringAsFixed(0)}';
    }
    if (_minPrice != null) return 'Desde \$${_minPrice!.toStringAsFixed(0)}';
    return 'Hasta \$${_maxPrice!.toStringAsFixed(0)}';
  }

  String? get _dateSubtitle {
    if (_dateRange == null) return null;
    final fmt = DateFormat('dd/MM/yy');
    return '${fmt.format(_dateRange!.start)} – ${fmt.format(_dateRange!.end)}';
  }

  @override
  Widget build(BuildContext context) {
    final filter = _current;
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (ctx, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Material(
            color: Colors.white,
            child: Column(
              children: [
                // Handle
                Padding(
                  padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                // Header
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  child: Row(
                    children: [
                      Text('Filtrar',
                          style: AppTypography.title
                              .copyWith(color: AppColors.blue)),
                      if (filter.isActive) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${filter.activeCount}',
                            style: AppTypography.caption.copyWith(
                              color: Colors.white,
                              fontFamily: 'GothamMedium',
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (filter.isActive)
                        TextButton(
                          onPressed: _reset,
                          child: Text('Restablecer',
                              style: AppTypography.body
                                  .copyWith(color: AppColors.orange)),
                        ),
                    ],
                  ),
                ),
                Divider(
                    height: 1,
                    color: AppColors.slateGrey.withValues(alpha: 0.15)),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    children: [
                      _FilterTile(
                        icon: Icons.grid_view_rounded,
                        label: 'Tipo de trabajo',
                        subtitle: _categorySubtitle,
                        isActive: _categoryIds.isNotEmpty,
                        onClear: _categoryIds.isNotEmpty
                            ? () => setState(() => _categoryIds = [])
                            : null,
                        onTap: () async {
                          final result =
                              await showModalBottomSheet<List<String>>(
                            context: ctx,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => CategoryFilterDetailScreen(
                              initialSelected: _categoryIds,
                            ),
                          );
                          if (result != null) {
                            setState(() => _categoryIds = result);
                          }
                        },
                      ),
                      _FilterTile(
                        icon: Icons.location_on_outlined,
                        label: 'Ubicación',
                        subtitle: _location,
                        isActive: _location != null,
                        onClear: _location != null
                            ? () => setState(() => _location = null)
                            : null,
                        onTap: () async {
                          final result =
                              await showModalBottomSheet<String>(
                            context: ctx,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => LocationFilterScreen(
                                initialLocation: _location),
                          );
                          if (result != null) {
                            setState(() =>
                                _location = result.isEmpty ? null : result);
                          }
                        },
                      ),
                      _FilterTile(
                        icon: Icons.attach_money,
                        label: 'Rango de Precio',
                        subtitle: _priceSubtitle,
                        isActive: _minPrice != null || _maxPrice != null,
                        onClear: (_minPrice != null || _maxPrice != null)
                            ? () => setState(() {
                                  _minPrice = null;
                                  _maxPrice = null;
                                })
                            : null,
                        onTap: () async {
                          final result =
                              await showModalBottomSheet<Map<String, double?>>(
                            context: ctx,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => PriceFilter(
                              initialMin: _minPrice,
                              initialMax: _maxPrice,
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              _minPrice = result['min'];
                              _maxPrice = result['max'];
                            });
                          }
                        },
                      ),
                      _FilterTile(
                        icon: Icons.access_time,
                        label: 'Tiempo de Publicación',
                        subtitle: _timeFilter,
                        isActive: _timeFilter != null,
                        onClear: _timeFilter != null
                            ? () => setState(() => _timeFilter = null)
                            : null,
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            context: ctx,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) =>
                                PostTimeFilter(initialSelected: _timeFilter),
                          );
                          if (result != null) {
                            setState(() => _timeFilter = result);
                          }
                        },
                      ),
                      _FilterTile(
                        icon: Icons.calendar_today,
                        label: 'Fecha límite',
                        subtitle: _dateSubtitle,
                        isActive: _dateRange != null,
                        onClear: _dateRange != null
                            ? () => setState(() => _dateRange = null)
                            : null,
                        onTap: () async {
                          final result =
                              await showModalBottomSheet<DateTimeRange>(
                            context: ctx,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) =>
                                StartDateFilter(initialRange: _dateRange),
                          );
                          if (result != null) {
                            setState(() => _dateRange = result);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      20.w,
                      8.h,
                      20.w,
                      20.h + MediaQuery.of(context).padding.bottom),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, _current),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        filter.isActive
                            ? 'Aplicar filtros (${filter.activeCount})'
                            : 'Aplicar filtros',
                        style:
                            AppTypography.label.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _FilterTile({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.subtitle,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
      horizontalTitleGap: 12.w,
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.orange.withValues(alpha: 0.12)
              : AppColors.blue.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isActive ? AppColors.orange : AppColors.blue,
          size: 18.r,
        ),
      ),
      title: Text(
        label,
        style: AppTypography.body.copyWith(
          color: AppColors.blue,
          fontFamily: isActive ? 'GothamMedium' : 'GothamBook',
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.caption.copyWith(
                color: isActive ? AppColors.orange : AppColors.slateGrey,
              ),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onClear != null)
            GestureDetector(
              onTap: onClear,
              child: Container(
                padding: EdgeInsets.all(4.r),
                margin: EdgeInsets.only(right: 4.w),
                decoration: BoxDecoration(
                  color: AppColors.slateGrey.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close,
                    size: 12.r, color: AppColors.slateGrey),
              ),
            ),
          Icon(Icons.chevron_right,
              color: AppColors.slateGrey, size: 20.r),
        ],
      ),
      onTap: onTap,
    );
  }
}
