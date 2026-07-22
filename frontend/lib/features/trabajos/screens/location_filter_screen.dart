import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/shared/providers/location_provider.dart';

class LocationFilterScreen extends StatefulWidget {
  final String? initialLocation;
  const LocationFilterScreen({super.key, this.initialLocation});

  @override
  State<LocationFilterScreen> createState() => _LocationFilterScreenState();
}

class _LocationFilterScreenState extends State<LocationFilterScreen> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialLocation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().cargarUbicaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locations = context.watch<LocationProvider>().locations;
    final isLoading = context.watch<LocationProvider>().isLoading;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.85,
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
                      Text('Ubicación',
                          style: AppTypography.title
                              .copyWith(color: AppColors.blue)),
                      const Spacer(),
                      if (_selected != null)
                        TextButton(
                          onPressed: () => setState(() => _selected = null),
                          child: Text('Limpiar',
                              style: AppTypography.body
                                  .copyWith(color: AppColors.orange)),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  if (isLoading)
                    const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                  else
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: locations.length,
                        itemBuilder: (_, i) {
                          final loc = locations[i];
                          final isActive = _selected == loc.name;
                          return ListTile(
                            title: Text(loc.name,
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
                            onTap: () =>
                                setState(() => _selected = loc.name),
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, _selected ?? ''),
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
