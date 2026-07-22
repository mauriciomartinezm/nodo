import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';

class PostTimeFilter extends StatefulWidget {
  final String? initialSelected;
  const PostTimeFilter({super.key, this.initialSelected});

  @override
  State<PostTimeFilter> createState() => _PostTimeFilterState();
}

class _PostTimeFilterState extends State<PostTimeFilter> {
  String? _selected;

  static const _opciones = ['Última Hora', 'Hoy', 'Esta semana'];

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected;
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
                  Text('Tiempo de publicación',
                      style:
                          AppTypography.title.copyWith(color: AppColors.blue)),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: _opciones.map((op) {
                        final isActive = _selected == op;
                        return ListTile(
                          title: Text(op,
                              style: AppTypography.body.copyWith(
                                color: isActive
                                    ? AppColors.orange
                                    : AppColors.blue,
                                fontFamily:
                                    isActive ? 'GothamMedium' : 'GothamBook',
                              )),
                          trailing: isActive
                              ? Icon(Icons.check,
                                  color: AppColors.orange, size: 18.r)
                              : null,
                          onTap: () => setState(() =>
                              _selected = isActive ? null : op),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, _selected ?? ''),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _selected != null ? 'Aplicar: $_selected' : 'Aceptar',
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
