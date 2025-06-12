import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/providers/userprovider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  static const int _descripcionMaxLength = 500;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _fSurnameController;
  late TextEditingController _sSurnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _descriptionController;

  List<String> allTags = [
    "Creativo",
    "Carismático",
    "Sociable",
    "Responsable",
    "Honesto",
    "Aventurero",
    "Optimista",
    "Amable",
    "Inteligente",
    "Divertido",
    "Curioso",
    "Paciente",
    "Apasionado",
    "Guapo",
    "Poderoso",
    "Asombroso",
    "Muy hermoso",
    "Armonioso",
  ];

  List<String> selectedTags = [];
  List<String> _originalTags = [];

  late String originalName;
  late String originalFSurname;
  late String originalSSurname;
  late String originalEmail;
  late String originalPhone;
  late String originalCity;
  late String originalDescription;

  bool get hasChanges =>
      _nameController.text != originalName ||
      _fSurnameController.text != originalFSurname ||
      _sSurnameController.text != originalSSurname ||
      _emailController.text != originalEmail ||
      _phoneController.text != originalPhone ||
      _cityController.text != originalCity ||
      _descriptionController.text != originalDescription ||
      !listEquals(selectedTags, _originalTags);

@override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.usuario;

    _nameController = TextEditingController(text: user?.nombres ?? '');
    _fSurnameController =
        TextEditingController(text: user?.primerApellido ?? '');
    _sSurnameController =
        TextEditingController(text: user?.segundoApellido ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.telefono ?? '');
    _cityController = TextEditingController(text: user?.ubicacion ?? '');
    _descriptionController =
        TextEditingController(text: user?.descripcion ?? '');

    selectedTags = [user?.idCategoria ?? ''];
    _originalTags = List<String>.from(selectedTags);

    originalName = _nameController.text;
    originalFSurname = _fSurnameController.text;
    originalSSurname = _sSurnameController.text;
    originalEmail = _emailController.text;
    originalPhone = _phoneController.text;
    originalCity = _cityController.text;
    originalDescription = _descriptionController.text;
  }


  Future<bool> _onWillPop() async {
    if (!hasChanges) return true;

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cancelar los cambios?'),
        content: const Text(
            'Tienes cambios sin guardar. ¿Deseas salir sin guardar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    return shouldLeave ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fSurnameController.dispose();
    _sSurnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context);

    return PopScope(
      canPop: !hasChanges,
      onPopInvoked: (didPop) async {
        if (kDebugMode) {
          print('Intento de salir detectado. ¿Ya salió?: $didPop');
        }
        if (didPop) return;

        final shouldLeave = await _onWillPop();
        if (shouldLeave) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: Text('Editar Perfil',
              style: AppTypography.h1.copyWith(color: AppColors.blue)),
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          iconTheme: IconThemeData(color: AppColors.blue),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField('Nombre completo', _nameController),
                buildTextField('Primer apellido', _fSurnameController),
                buildTextField('Segundo apellido', _sSurnameController),
                buildTextField('Correo', _emailController,
                    keyboardType: TextInputType.emailAddress),
                buildTextField('Número de contacto', _phoneController,
                    keyboardType: TextInputType.phone),
                buildTextField('Ubicación o ciudad', _cityController),
                buildTextField(
                  'Descripción',
                  _descriptionController,
                  maxLines: 4,
                  maxLength: _descripcionMaxLength,
                ),

                const SizedBox(height: 10),
                Text('Categorías',
                    style: AppTypography.h3.copyWith(color: AppColors.blue)),
                const SizedBox(height: 0),
                Wrap(
                  spacing: 6,
                  runSpacing: -4,
                  children: allTags.map((tag) {
                    final isSelected = selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag,
                          style: TextStyle(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.blue)),
                      selected: isSelected,
                      selectedColor: AppColors.blue,
                      backgroundColor: AppColors.white,
                      checkmarkColor: AppColors.white,
                      shape: StadiumBorder(
                          side: BorderSide(color: AppColors.blue)),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedTags.add(tag);
                          } else {
                            selectedTags.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: Text('Guardar',
                        style:
                            AppTypography.h2.copyWith(color: AppColors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          hasChanges ? AppColors.orange : Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: hasChanges
                        ? () async {
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            final user = userProvider.usuario!;

                            Usuario actualizado = Usuario(
                              id: user.id,
                              nombres: _nameController.text,
                              primerApellido: _fSurnameController.text,
                              segundoApellido: _sSurnameController.text,
                              email: _emailController.text,
                              telefono: _phoneController.text,
                              fechaNacimiento: user.fechaNacimiento,
                              contrasena: user.contrasena,
                              fechaRegistro: user.fechaRegistro,
                              fotoPerfil: user.fotoPerfil,
                              verificado: user.verificado,
                              tipoUsuario: user.tipoUsuario,
                              idCategoria: selectedTags.isNotEmpty
                                  ? selectedTags.first
                                  : '',
                              ubicacion: _cityController.text,
                              descripcion: _descriptionController.text,
                              calificacionPromedio: user.calificacionPromedio,
                              trabajosCompletados: user.trabajosCompletados,
                            );

                            final resultado = await userProvider
                                .guardarCambiosUsuario(actualizado);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(resultado)));
                            Navigator.pop(context); // Vuelve atrás si se desea
                          }
                        : null,

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


 Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.h3.copyWith(color: AppColors.blue),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: (_) =>
                setState(() {}), // Opcional: para re-renderizar si se necesita
            validator: (value) {
              if (!required) return null;
              return value == null || value.isEmpty ? 'Campo requerido' : null;
            },
            buildCounter: (BuildContext context,
                {required int currentLength,
                required bool isFocused,
                required int? maxLength}) {
              if (maxLength == null) return null;
              return Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$currentLength/$maxLength',
                  style: TextStyle(
                    fontSize: 12,
                    color: currentLength > maxLength ? Colors.red : Colors.grey,
                  ),
                ),
              );
            },
            decoration: InputDecoration(
              hintText: 'Ingresa tu $label',
              hintStyle: const TextStyle(color: Color.fromARGB(94, 6, 54, 102)),
              errorStyle: TextStyle(color: AppColors.orange),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.blue, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.blue, width: 1.3),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.orange),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.orange),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
