import 'package:flutter/material.dart';
import 'package:nodo/features/crear_publicacion/widgets/foto_widget.dart';
import 'package:nodo/providers/userprovider.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/crear_publicacion_controller.dart';
import '../widgets/header_info.dart';
import '../widgets/text_field.dart';
import '../widgets/categoria_dropdown.dart';
import '../widgets/descripcion_field.dart';

class CrearPublicacionScreen extends StatefulWidget {
  const CrearPublicacionScreen({super.key});

  @override
  State<CrearPublicacionScreen> createState() => _CrearPublicacionScreenState();
}

class _CrearPublicacionScreenState extends State<CrearPublicacionScreen> {
  List<String> _urlsImagenes = [];
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _presupuestoController = TextEditingController();
  final _fechaLimiteController = TextEditingController();
  final _descripcionController = TextEditingController();
  String? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller =
          Provider.of<CrearPublicacionController>(context, listen: false);
      controller.cargarCategorias();
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _ubicacionController.dispose();
    _presupuestoController.dispose();
    _fechaLimiteController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _enviarPublicacion() async {
    final controller =
        Provider.of<CrearPublicacionController>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (!_validarCampos()) return;

    final datos = {
      "id_cliente": userProvider.usuario!.id,
      "titulo": _tituloController.text,
      "id_categoria": _getIdCategoriaSeleccionada(),
      "ubicacion": _ubicacionController.text,
      "presupuesto": int.tryParse(_presupuestoController.text) ?? 0,
      "fecha_limite": _fechaLimiteController.text,
      "descripcion_necesidad": _descripcionController.text,
      "fotos": _urlsImagenes,
    };

    final success = await controller.crearPublicacion(datos);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Publicación creada con éxito!")),
      );
      _limpiarFormulario();
    }
  }

  bool _validarCampos() {
    final controller =
        Provider.of<CrearPublicacionController>(context, listen: false);

    if (_tituloController.text.isEmpty ||
        _categoriaSeleccionada == null ||
        _ubicacionController.text.isEmpty ||
        _presupuestoController.text.isEmpty ||
        _fechaLimiteController.text.isEmpty ||
        _descripcionController.text.isEmpty) {
      controller.setErrorMessage("Todos los campos son obligatorios");
      return false;
    }
    return true;
  }

  String _getIdCategoriaSeleccionada() {
    final controller =
        Provider.of<CrearPublicacionController>(context, listen: false);
    return controller.categorias.firstWhere(
      (cat) => cat['nombre'] == _categoriaSeleccionada,
      orElse: () => {'id': ''},
    )['id']!;
  }

  void _limpiarFormulario() {
    _tituloController.clear();
    _ubicacionController.clear();
    _presupuestoController.clear();
    _fechaLimiteController.clear();
    _descripcionController.clear();
    setState(() => _categoriaSeleccionada = null);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CrearPublicacionController>(context);

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 15.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderInfoWidget(),
                SizedBox(height: 20.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    children: [
                      CustomTextField("Título", _tituloController),
                      SizedBox(height: 10.h),
                      CategoriaDropdown(
                        categorias: controller.categorias,
                        value: _categoriaSeleccionada,
                        onChanged: (value) =>
                            setState(() => _categoriaSeleccionada = value),
                      ),
                      SizedBox(height: 10.h),
                      CustomTextField("Ubicación", _ubicacionController),
                      SizedBox(height: 10.h),
                      CustomTextField("Presupuesto", _presupuestoController,
                          isNumber: true),
                      SizedBox(height: 10.h),

                      /// CAMPO DE FECHA CON DATEPICKER
                      GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            final formattedDate =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            setState(() {
                              _fechaLimiteController.text = formattedDate;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _fechaLimiteController,
                            decoration: const InputDecoration(
                              labelText: "Fecha límite",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),
                      DescripcionField(controller: _descripcionController),
                      SizedBox(height: 10.h),
                      SubirFotoWidget(
                        onUploadComplete: (urls) => _urlsImagenes = urls,
                      ),
                      if (controller.errorMessage != null) ...[
                        SizedBox(height: 10.h),
                        Text(
                          controller.errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                      SizedBox(height: 15.h),
                      FractionallySizedBox(
                        widthFactor: 0.3,
                        child: ElevatedButton(
                          onPressed:
                              controller.isLoading ? null : _enviarPublicacion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: controller.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  "Publicar",
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontFamily: "GothamMedium",
                                    fontSize: 12.sp,
                                  ),
                                ),
                        ),
                      ),
                    ],
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
