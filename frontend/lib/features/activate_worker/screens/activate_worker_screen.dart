import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:nodo/core/services/user_service.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/models/categorie.dart';
import 'package:nodo/models/location.dart';
import 'package:nodo/shared/providers/general_category_provider.dart';
import 'package:nodo/shared/providers/location_provider.dart';
import 'package:nodo/shared/providers/user_provider.dart';
import 'package:nodo/shared/widgets/elevated_button_widget.dart';
import 'package:nodo/shared/widgets/multi_select_dropdown.dart';
import 'package:nodo/shared/widgets/searchable_dropdown_field.dart';

/// Le permite a un cliente ya registrado completar los datos que le faltan
/// (descripción, rubros y, si no la tenía, ubicación) para activar su
/// perfil de trabajador, sin tener que volver a registrarse desde cero.
class ActivateWorkerScreen extends StatefulWidget {
  const ActivateWorkerScreen({super.key});

  @override
  State<ActivateWorkerScreen> createState() => _ActivateWorkerScreenState();
}

class _ActivateWorkerScreenState extends State<ActivateWorkerScreen> {
  final _userService = UserService();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  List<String> _selectedCategoryIds = [];
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user!;
    _locationController.text = user.ubicacion is String ? user.ubicacion : '';
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _activar() async {
    if (_descriptionController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Cuéntanos sobre tu experiencia para continuar');
      return;
    }
    if (_locationController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Selecciona tu ubicación');
      return;
    }
    if (_selectedCategoryIds.isEmpty) {
      setState(() => _errorMessage = 'Selecciona al menos un rubro');
      return;
    }

    final userProvider = context.read<UserProvider>();
    final user = userProvider.user!;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await _userService.activateWorker(user.id, {
        "description": _descriptionController.text.trim(),
        "generalCategoryIds": _selectedCategoryIds,
        "location": _locationController.text.trim(),
      });

      final updatedUser = await _userService.getUser(user.id);
      userProvider.updateUsuario(updatedUser);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Listo! Ya puedes recibir ofertas de trabajo')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => _errorMessage = 'Error al activar el perfil: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.r, color: AppColors.blue),
              SizedBox(width: 6.w),
              Text(title, style: AppTypography.label.copyWith(color: AppColors.blue)),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categorieProvider = context.watch<GeneralCategoryProvider>();
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blue),
        title: Text('Activar perfil de trabajador',
            style: AppTypography.title.copyWith(color: AppColors.orange)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Solo nos falta esto para activar tu perfil como trabajador y que empieces a recibir ofertas de trabajo.',
                style: AppTypography.body.copyWith(color: AppColors.blue.withValues(alpha: 0.8)),
              ),
              SizedBox(height: 16.h),
              _buildCard(
                title: 'Sobre mí *',
                icon: Icons.notes_outlined,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  minLines: 3,
                  style: AppTypography.body,
                  decoration: InputDecoration(
                    hintText: 'Cuéntale a tus clientes sobre tu experiencia',
                    hintStyle: AppTypography.body.copyWith(color: AppColors.slateGrey),
                    filled: true,
                    fillColor: AppColors.blue.withValues(alpha: 0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
                  ),
                ),
              ),
              _buildCard(
                title: 'Ubicación *',
                icon: Icons.location_on_outlined,
                child: SearchableDropdownField<Location>(
                  label: 'Ubicación',
                  icon: Icons.location_on_outlined,
                  searchHint: 'Buscar ubicación...',
                  emptyMessage: 'No se encontraron ubicaciones',
                  options: locationProvider.locations,
                  labelBuilder: (location) => location.name,
                  value: locationProvider.locations.cast<Location?>().firstWhere(
                        (l) => l!.name == _locationController.text,
                        orElse: () => null,
                      ),
                  onChanged: (location) =>
                      setState(() => _locationController.text = location.name),
                ),
              ),
              _buildCard(
                title: 'Rubros *',
                icon: Icons.work_outline,
                child: MultiSelectDropdown<Categorie>(
                  label: 'Rubros',
                  hint: 'Selecciona tus rubros',
                  options: categorieProvider.categories,
                  selectedValues: categorieProvider.categories
                      .where((c) => _selectedCategoryIds.contains(c.id))
                      .toList(),
                  labelBuilder: (categoria) => categoria.name,
                  onChanged: (selected) => setState(
                      () => _selectedCategoryIds = selected.map((c) => c.id).toList()),
                ),
              ),
              if (_errorMessage != null) ...[
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Text(
                    _errorMessage!,
                    style: AppTypography.caption.copyWith(color: AppColors.error),
                  ),
                ),
              ],
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  text: 'Activar perfil de trabajador',
                  icon: Icons.check_circle_outline,
                  loading: _isSaving,
                  onPressed: _isSaving ? null : _activar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
