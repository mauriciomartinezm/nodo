import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../../providers/userprovider.dart';
import '../../../models/cliente.dart';
import '../../../models/trabajador.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/screens/home_screen.dart';
import 'package:nodo/features/register/widgets/registerclient1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  bool _loading = false;

  Future<void> _login() async {
      print("hola");

    final telefono = _telefonoController.text.trim();
    final contrasena = _contrasenaController.text;

    if (telefono.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final clienteResponse = await http.post(
        Uri.parse(ApiConstants.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'telefono': telefono, 'contrasena': contrasena}),
      );
      print(clienteResponse.statusCode);
      if (clienteResponse.statusCode == 200) {
        final clienteData = jsonDecode(clienteResponse.body);

        if (clienteData['messageSuccess'] != null) {
          final cliente = Cliente.fromJson(clienteData['cliente']);
          final usuarioProvider =
              Provider.of<UserProvider>(context, listen: false);
          //usuarioProvider.loginComoCliente(cliente);
          // Verificamos si también es trabajador
          final trabajadorResponse = await http.get(
            Uri.parse(
                "${ApiConstants.baseUrl}/getTrabajadorByUserId/${cliente.id}"),
          );
          //print(jsonDecode(trabajadorResponse.body));
          if (trabajadorResponse.statusCode == 200) {
            final trabajadorData = jsonDecode(trabajadorResponse.body);
            //print(trabajadorData[0]);

            if (trabajadorData != null && trabajadorData.isNotEmpty) {
              final trabajador = Trabajador.fromJson(trabajadorData[0]);

              //final usuarioProvider =
              //    Provider.of<UsuarioProvider>(context, listen: false);
                  //print("trabajador: ");
                  //print(trabajador);
                  //print("Cliente: ");
                  //print(cliente);
              //usuarioProvider.loginComoTrabajador(trabajador, cliente);
            }
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Inicio de sesión fallido')),
          );
        }
      } else if (clienteResponse.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Credenciales inválidas')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error del servidor: ${clienteResponse.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/icons/iconNodoWhite.png',
                    width: 55.w,
                    height: 55.h,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.15),
                    child: AutoSizeText(
                      'Inicia sesión y descubre nuevas oportunidades de trabajo y servicios en un solo lugar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: 14.sp,
                        fontFamily: 'GothamMedium',
                      ),
                      maxLines: 3,
                      minFontSize: 5,
                      maxFontSize: 22,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.085,
              ).copyWith(
                top: MediaQuery.of(context).size.height * 0.15,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextField(
                      controller: _telefonoController,
                      decoration: InputDecoration(
                        labelText: "Teléfono",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.015,
                    ),
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextField(
                      controller: _contrasenaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "¿Olvidaste tu contraseña?",
                        style: TextStyle(
                            color: AppColors.accentColor,
                            fontFamily: "GothamBook",
                            fontSize: 11.r),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.025,
                    ),
                    child: ElevatedButton(
                      onPressed: _loading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        minimumSize: Size(
                          double.infinity,
                          MediaQuery.of(context).size.height * 0.06,
                        ),
                      ),
                      child: _loading
                          ? CircularProgressIndicator(
                              color: AppColors.secondaryColor)
                          : ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                              child: Center(
                                child: AutoSizeText("Iniciar sesión",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontFamily: "GothamMedium",
                                      fontSize: 12.sp,
                                    ),
                                    maxLines: 2,
                                    minFontSize: 5,
                                    maxFontSize: 28),
                              ),
                            ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿No tienes una cuenta? ",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontFamily: "GothamBook",
                              fontSize: 11.r)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterClient1()),
                          );
                        },
                        child: Text(
                          "Regístrate",
                          style: TextStyle(
                              color: AppColors.accentColor,
                              fontFamily: "GothamMedium",
                              fontSize: 11.r),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.09,
                        bottom: MediaQuery.of(context).size.height * 0.015),
                    child: Text(
                      "O continua con: ",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: "GothamMedium",
                          fontSize: 11.r),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.facebook,
                          size: MediaQuery.of(context).size.height * 0.03,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.height * 0.03),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          FontAwesomeIcons.google,
                          size: MediaQuery.of(context).size.height * 0.03,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.height * 0.03),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          FontAwesomeIcons.linkedin,
                          size: MediaQuery.of(context).size.height * 0.03,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
