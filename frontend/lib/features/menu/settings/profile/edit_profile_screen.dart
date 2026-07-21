import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:nodo/core/services/user_service.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/create_post/widgets/text_field_widget.dart';
import 'package:nodo/models/categorie.dart';
import 'package:nodo/models/location.dart';
import 'package:nodo/shared/providers/general_category_provider.dart';
import 'package:nodo/shared/providers/location_provider.dart';
import 'package:nodo/shared/providers/user_provider.dart';
import 'package:nodo/shared/widgets/elevated_button_widget.dart';
import 'package:nodo/shared/widgets/multi_select_dropdown.dart';
import 'package:nodo/shared/widgets/searchable_dropdown_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  final _nameController = TextEditingController();
  final _lastName1Controller = TextEditingController();
  final _lastName2Controller = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<String> _selectedCategoryIds = [];
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user!;
    _nameController.text = user.nombres;
    _lastName1Controller.text = user.primerApellido;
    _lastName2Controller.text = user.segundoApellido;
    _emailController.text = user.email;
    _phoneController.text = user.telefono;
    _locationController.text = user.ubicacion is String ? user.ubicacion : '';
    _descriptionController.text = user.descripcion is String ? user.descripcion : '';
    _selectedCategoryIds = user.categorias.map((c) => c.id).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastName1Controller.dispose();
    _lastName2Controller.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty ||
        _lastName1Controller.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Nombres, apellido, correo y teléfono son obligatorios');
      return;
    }

    final userProvider = context.read<UserProvider>();
    final user = userProvider.user!;
    final esTrabajador = user.tipoUsuario == 'trabajador';

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final data = {
        "firstName": _nameController.text.trim(),
        "lastName": _lastName1Controller.text.trim(),
        "secondLastName": _lastName2Controller.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "location": _locationController.text.trim(),
        if (esTrabajador) "description": _descriptionController.text.trim(),
        if (esTrabajador) "generalCategoryIds": _selectedCategoryIds,
      };

      await _userService.updateUser(user.id, data);
      final updatedUser = await _userService.getUser(user.id);
      userProvider.updateUsuario(updatedUser);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => _errorMessage = 'Error al actualizar el perfil: $e');
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
    final user = context.watch<UserProvider>().user;
    final categorieProvider = context.watch<GeneralCategoryProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final esTrabajador = user?.tipoUsuario == 'trabajador';

    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.blue),
        title: Text('Editar perfil',
            style: AppTypography.title.copyWith(color: AppColors.orange)),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard(
                  title: 'Datos personales',
                  icon: Icons.person_outline,
                  child: Column(
                    children: [
                      CustomTextField('Nombres *', _nameController,
                          icon: Icons.badge_outlined),
                      SizedBox(height: 12.h),
                      CustomTextField(
                          'Primer apellido *', _lastName1Controller,
                          icon: Icons.badge_outlined),
                      SizedBox(height: 12.h),
                      CustomTextField(
                          'Segundo apellido', _lastName2Controller,
                          icon: Icons.badge_outlined),
                    ],
                  ),
                ),
                _buildCard(
                  title: 'Contacto',
                  icon: Icons.contact_mail_outlined,
                  child: Column(
                    children: [
                      CustomTextField('Correo *', _emailController,
                          icon: Icons.email_outlined),
                      SizedBox(height: 12.h),
                      CustomTextField(
                          'Número de contacto *', _phoneController,
                          icon: Icons.phone_outlined),
                    ],
                  ),
                ),
                _buildCard(
                  title: 'Ubicación',
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
                if (esTrabajador) ...[
                  _buildCard(
                    title: 'Sobre mí',
                    icon: Icons.notes_outlined,
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      minLines: 3,
                      style: AppTypography.body,
                      decoration: InputDecoration(
                        hintText: 'Cuéntale a tus clientes sobre tu experiencia',
                        hintStyle: AppTypography.body
                            .copyWith(color: AppColors.slateGrey),
                        filled: true,
                        fillColor: AppColors.blue.withValues(alpha: 0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 14.w),
                      ),
                    ),
                  ),
                  _buildCard(
                    title: 'Rubros',
                    icon: Icons.work_outline,
                    child: MultiSelectDropdown<Categorie>(
                      label: 'Rubros',
                      hint: 'Selecciona tus rubros',
                      options: categorieProvider.categories,
                      selectedValues: categorieProvider.categories
                          .where((c) => _selectedCategoryIds.contains(c.id))
                          .toList(),
                      labelBuilder: (categoria) => categoria.name,
                      onChanged: (selected) => setState(() =>
                          _selectedCategoryIds = selected.map((c) => c.id).toList()),
                    ),
                  ),
                ],
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
                    text: 'Guardar cambios',
                    icon: Icons.save_outlined,
                    loading: _isSaving,
                    onPressed: _isSaving ? null : _save,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
