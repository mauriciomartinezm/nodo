import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:nodo/features/login/logic/login_controller.dart';
import 'package:nodo/features/register/screens/register_screen.dart';
import 'package:nodo/features/welcome/widgets/welcome3.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/user_provider.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/shared/widgets/elevated_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identificadorController =
      TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  late LoginController _loginController;

  @override
  void initState() {
    super.initState();
    _loginController = LoginController(context);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final bool _loading = userProvider.isLoading;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.blue,
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
                      style: AppTypography.h2.copyWith(color: AppColors.white),
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
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "¿Olvidaste tu contraseña?",
                        style: AppTypography.body
                            .copyWith(color: AppColors.orange),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.025,
                    ),
                    child: CustomElevatedButton(
                      text: "Iniciar sesión",
                      onPressed: _loading
                          ? null
                          : () async {
                              await _loginController.login(
                                _identificadorController.text.trim(),
                                _contrasenaController.text.trim(),
                              );
                            },
                      loading: _loading,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿No tienes una cuenta? ",
                          style: AppTypography.body
                              .copyWith(color: AppColors.blue)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Text("Regístrate",
                            style: AppTypography.body.copyWith(
                                fontFamily: 'GothamMedium',
                                color: AppColors.orange)),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.09,
                        bottom: MediaQuery.of(context).size.height * 0.015),
                    child: Text("O continua con: ",
                        style: AppTypography.body.copyWith(
                            fontFamily: 'GothamMedium', color: AppColors.blue)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.facebook,
                          size: MediaQuery.of(context).size.height * 0.03,
                          color: AppColors.blue,
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.height * 0.03),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          FontAwesomeIcons.google,
                          size: MediaQuery.of(context).size.height * 0.03,
                          color: AppColors.blue,
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.height * 0.03),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          FontAwesomeIcons.linkedin,
                          size: MediaQuery.of(context).size.height * 0.03,
                          color: AppColors.blue,
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
