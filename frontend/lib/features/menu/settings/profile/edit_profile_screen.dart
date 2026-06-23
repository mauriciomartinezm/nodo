import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores necesarios
  final TextEditingController _nameController =
      TextEditingController(text: 'Kehiber Leandro Morelo Ricardo');
  final TextEditingController _emailController =
      TextEditingController(text: 'User@mail.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '0000000000');
  final TextEditingController _cityController =
      TextEditingController(text: 'Apartadó - Antioquia');
  final TextEditingController _descriptionController =
      TextEditingController(text: 'Lorem ipsum dolor sit amet...');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Editar Perfil',
            style: AppTypography.title.copyWith(color: AppColors.blue)),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.blue),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nombre completo', _nameController),
              _buildTextField('Correo', _emailController,
                  keyboardType: TextInputType.emailAddress),
              _buildTextField('Número de contacto', _phoneController,
                  keyboardType: TextInputType.phone),
              _buildTextField('Ubicación o ciudad', _cityController),
              _buildTextField('Descripción', _descriptionController,
                  maxLines: 4),
              const SizedBox(height: 10),
              Text('Categorías',
                  style: AppTypography.label.copyWith(color: AppColors.blue)),
              const SizedBox(height: 0),
              Wrap(
                spacing: 6,
                runSpacing: -4,
                children: allTags.map((tag) {
                  final isSelected = selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag,
                        style: TextStyle(
                            color:
                                isSelected ? AppColors.white : AppColors.blue)),
                    selected: isSelected,
                    selectedColor: AppColors.blue,
                    backgroundColor: AppColors.white,
                    checkmarkColor: AppColors.white,
                    shape:
                        StadiumBorder(side: BorderSide(color: AppColors.blue)),
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
                      style: AppTypography.subtitle.copyWith(color: AppColors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label.copyWith(color: AppColors.blue)),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: (value) =>
                value == null || value.isEmpty ? 'Campo requerido' : null,
            decoration: InputDecoration(
              hintText: 'Ingresa tu $label',
              hintStyle: TextStyle(color: const Color.fromARGB(94, 6, 54, 102)),
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
