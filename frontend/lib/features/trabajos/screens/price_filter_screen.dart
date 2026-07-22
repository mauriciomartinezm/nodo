import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class PriceFilter extends StatefulWidget {
  final double? initialMin;
  final double? initialMax;
  const PriceFilter({super.key, this.initialMin, this.initialMax});

  @override
  State<PriceFilter> createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  late final TextEditingController _minCtrl;
  late final TextEditingController _maxCtrl;

  @override
  void initState() {
    super.initState();
    _minCtrl = TextEditingController(
        text: widget.initialMin != null
            ? widget.initialMin!.toStringAsFixed(0)
            : '');
    _maxCtrl = TextEditingController(
        text: widget.initialMax != null
            ? widget.initialMax!.toStringAsFixed(0)
            : '');
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    final min = double.tryParse(_minCtrl.text.trim());
    final max = double.tryParse(_maxCtrl.text.trim());
    Navigator.pop(context, {'min': min, 'max': max});
  }

  @override
  Widget build(BuildContext context) {
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
                mainAxisSize: MainAxisSize.min,
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
                  Text('Rango de precio',
                      style:
                          AppTypography.title.copyWith(color: AppColors.blue)),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: _PriceField(
                            controller: _minCtrl, label: 'Mínimo (\$)'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text('–',
                            style: AppTypography.title
                                .copyWith(color: AppColors.slateGrey)),
                      ),
                      Expanded(
                        child: _PriceField(
                            controller: _maxCtrl, label: 'Máximo (\$)'),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _apply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Aplicar',
                          style:
                              AppTypography.label.copyWith(color: Colors.white)),
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

class _PriceField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const _PriceField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: AppTypography.body.copyWith(color: AppColors.blue),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.caption.copyWith(color: AppColors.slateGrey),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.slateGrey.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
    );
  }
}
