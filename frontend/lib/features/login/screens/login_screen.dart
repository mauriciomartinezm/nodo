import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:nodo/features/home/screens/home_screen.dart';
import 'package:nodo/features/welcome/widgets/welcome3.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/userprovider.dart';
import '../../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identificadorController =
      TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  bool _loading = false;

  Future<void> _login() async {
    print("Entrando a la función _login");
    final identificador = _identificadorController.text.trim();
    final contrasena = _contrasenaController.text;

    if (identificador.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });
    try {
      print("Entrado al try dentro del _login");
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      print(
          "Esperando al login exitoso de la API en la funcion dentro de userProvider");
      String message =
          await userProvider.loginUsuario(identificador, contrasena);
      print("Mensaje devuelto por userProvider: ");
      print(message);
      if (message.startsWith("Login exitoso")) {
        final prefs = await SharedPreferences.getInstance();
        final seenWelcome = prefs.getBool('seen_welcome') ?? false;
        print('seen_welcome en navegación: $seenWelcome');

        print("Login exitoso, ejecutando pushReplacement /home");
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );*/
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } else if (message.startsWith("Credenciales inválidas")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Credenciales inválidas')),
        );
      } else if (message == "Error al conectar con el servidor") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al conectar con el servidor')),
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
                      controller: _identificadorController,
                      decoration: InputDecoration(
                        labelText: "Correo electronico o teléfono",
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
                            MaterialPageRoute(
                                builder: (context) => const Welcome3Screen()),
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
