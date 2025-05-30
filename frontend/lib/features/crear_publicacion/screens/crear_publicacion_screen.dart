import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nodo/core/constants/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/features/register/widgets/subir_foto_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:provider/provider.dart';
//import '../../../providers/userprovider.dart';

class CrearPublicacionScreen extends StatefulWidget {
  const CrearPublicacionScreen({super.key});

  @override
  State<CrearPublicacionScreen> createState() => _CrearPublicacionScreenState();
}

class _CrearPublicacionScreenState extends State<CrearPublicacionScreen> {
  

  final _formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final ubicacionController = TextEditingController();
  final presupuestoController = TextEditingController();
  final fechaLimiteController = TextEditingController();
  final descripcionController = TextEditingController();

  String? categoriaSeleccionada;
  String? mensajeErrorGeneral;

  List<Map<String, String>> categorias = [];

  @override
  void initState() {
    super.initState();
    obtenerCategorias(); // Carga las categorías apenas se crea el widget
  }

  Future<void> obtenerCategorias() async {
    print("obtener categorias");
    final url = Uri.parse(ApiConstants.getCategoriasEndpoint);
    try {
      final response = await http.get(url);
    print(response.statusCode);
    print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          categorias = data.map<Map<String, String>>((categoria) {
            return {
              'id': categoria['id'],
              'nombre': categoria['nombre_cat'],
              'descripcion': categoria['descripcion']
            };
          }).toList();
        });
      } else {
        print('Error al obtener categorías: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud de categorías: $e');
    }
  }

  Future<void> enviarPublicacion(String idCliente) async {
    setState(() {
      mensajeErrorGeneral = null;
    });

    // Validación manual de campos obligatorios
    if (tituloController.text.isEmpty ||
        categoriaSeleccionada == null ||
        ubicacionController.text.isEmpty ||
        presupuestoController.text.isEmpty ||
        fechaLimiteController.text.isEmpty ||
        descripcionController.text.isEmpty) {
      setState(() {
        mensajeErrorGeneral = "Todos los campos son obligatorios";
      });
      return;
    }

    final url = Uri.parse(ApiConstants.createPublicacionEndpoint);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_cliente":
              idCliente, // Este debe venir del login si está implementado
          "id_categoria": categorias.firstWhere(
              (cat) => cat['nombre'] == categoriaSeleccionada)['id'],

          "titulo": tituloController.text,
          "descripcion_necesidad": descripcionController.text,
          "ubicacion": ubicacionController.text,
          "presupuesto": int.tryParse(presupuestoController.text) ?? 0,
          "estado": "pendiente"
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Publicación creada con éxito!")),
        );
        // Opcional: Limpiar formulario después de éxito
        tituloController.clear();
        ubicacionController.clear();
        presupuestoController.clear();
        fechaLimiteController.clear();
        descripcionController.clear();
        setState(() {
          categoriaSeleccionada = null;
          mensajeErrorGeneral = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error del servidor: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al conectar con el servidor")),
      );
    }
  }

  @override
  void dispose() {
    tituloController.dispose();
    ubicacionController.dispose();
    presupuestoController.dispose();
    fechaLimiteController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final usuarioProvider = Provider.of<UserProvider>(context);
    String nombre = '';
    String profesion = '';
    //nombre = usuarioProvider.cliente!.nombre;
    //String cliente_id = usuarioProvider.cliente!.id;
    ////if (usuarioProvider.tipo == TipoUsuario.cliente &&
    ////    usuarioProvider.cliente != null) {
    ////}
    //if (usuarioProvider.tipo == TipoUsuario.trabajador &&
    //    usuarioProvider.trabajador != null) {
    //  profesion = usuarioProvider.trabajador!.habilidad;
    //}

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 15.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/diomedes_joven.jpg',
                              height: 60.r,
                              width: 60.r,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nombre,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontFamily: "GothamMedium",
                                  fontSize: 14.r,
                                ),
                              ),
                              if (profesion.isNotEmpty)
                                Text(
                                  profesion,
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 14.r,
                                    fontFamily: "GothamBook",
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      AutoSizeText(
                        "Publica tu solicitud y encuentra al profesional ideal",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: "GothamMedium",
                          fontSize: 17.r,
                        ),
                        maxLines: 3,
                        minFontSize: 5,
                        maxFontSize: 22,
                      ),
                      AutoSizeText(
                        "Describe lo que necesitas y deja que los mejores trabajadores te contacten",
                        style: TextStyle(
                          color: AppColors.accentColor,
                          fontFamily: "GothamBook",
                          fontSize: 14.r,
                        ),
                        maxLines: 3,
                        minFontSize: 5,
                        maxFontSize: 22,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    children: [
                      buildTextField("Título", tituloController),
                      SizedBox(height: 10.h),
                      buildDropdown(),
                      SizedBox(height: 10.h),
                      buildTextField("Ubicación", ubicacionController),
                      SizedBox(height: 10.h),
                      buildTextField("Presupuesto", presupuestoController,
                          isNumber: true),
                      SizedBox(height: 10.h),
                      buildTextField("Fecha límite", fechaLimiteController),
                      SizedBox(height: 10.h),
                      buildDescripcionField(),
                      SizedBox(height: 10.h),
                      const SubirFotoWidget(),
                      // Aquí mostramos el mensaje de error general, si existe
                      if (mensajeErrorGeneral != null) ...[
                        SizedBox(height: 10.h),
                        Center(
                          child: Text(
                            mensajeErrorGeneral!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 15.h),
                      FractionallySizedBox(
                        widthFactor: 0.3,
                        child: ElevatedButton(
                          onPressed: () async {
                            //enviarPublicacion(cliente_id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(
                                50, MediaQuery.of(context).size.height * 0.06),
                          ),
                          child: Text(
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

  Widget buildTextField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return SizedBox(
      height: 30.h,
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(
          fontSize: 9.sp,
          color: Colors.black,
          fontFamily: "GothamBook",
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 9.sp,
            color: AppColors.aux,
            fontFamily: "GothamBook",
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2.r, color: AppColors.aux),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2.r, color: AppColors.aux),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 6.h,
            horizontal: 10.w,
          ),
        ),
      ),
    );
  }

  Widget buildDescripcionField() {
    return TextField(
      controller: descripcionController,
      maxLines: 3,
      style: TextStyle(
          fontSize: 9.sp, color: Colors.black, fontFamily: "GothamBook"),
      decoration: InputDecoration(
        labelText: "Descripción",
        alignLabelWithHint: true,
        labelStyle: TextStyle(
            fontSize: 12.r, color: AppColors.aux, fontFamily: "GothamBook"),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2.r, color: AppColors.aux),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2.r, color: AppColors.aux),
        ),
      ),
    );
  }

  Widget buildDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Categoría",
        labelStyle: TextStyle(
          fontSize: 9.sp,
          color: AppColors.aux,
          fontFamily: "GothamBook",
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2.r, color: AppColors.aux),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2.r, color: AppColors.aux),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 6.h,
          horizontal: 10.w,
        ),
      ),
      value: categoriaSeleccionada,
      items: categorias.map<DropdownMenuItem<String>>((categoria) {
        return DropdownMenuItem<String>(
          value: categoria['nombre'],
          child: Text(categoria['nombre']!),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          categoriaSeleccionada = value;
        });
      },
    );
  }
}
