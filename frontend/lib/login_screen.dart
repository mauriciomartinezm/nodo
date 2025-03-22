import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return NewWidget();
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final diagonal = sqrt(
      pow(MediaQuery.of(context).size.width, 2) +
          pow(MediaQuery.of(context).size.height, 2),
    );

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Container(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              //padding: EdgeInsets.all(20.w),
              alignment: Alignment.center,
              //constraints: BoxConstraints.expand(
              //  height:
              //      Theme.of(context).textTheme.headlineMedium!.fontSize! * 1.1 +
              //          250.0,
              //),
              decoration: BoxDecoration(
                color: AppColors.primaryColor, // Color de fondo del Container
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/icons/iconNodoWhite.png', //necesito el svg, la imagen no quiere cambiar de tama;o
                    width: 55.w,
                    height: 55.h,
                  ),
                  //SizedBox(
                  //    // ????????????? espacio entre el logo y el texto
                  //    height: 30.h,
                  //    ),
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
                        maxLines: 3, // Máximo de líneas
                        minFontSize: 5, // Tamaño mínimo de la fuente
                        maxFontSize: 22),
                  )
                ],
              )),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.15,
                  //bottom: MediaQuery.of(context).size.height * 0.15,
                  left: MediaQuery.of(context).size.width * 0.085,
                  right: MediaQuery.of(context).size.width * 0.085),
              //decoration: BoxDecoration(
              //    image: DecorationImage(
              //  image: AssetImage('assets/icons/iconNodoBlue.png'), //Imagen de fondo
              //  fit: BoxFit.cover
              //)
              //),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Correo electrónico o teléfono",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        //contentPadding: EdgeInsets.all(
                        //    MediaQuery.of(context).size.width * 0.05)
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.015,
                    ),
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextField(
                      obscureText: true,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        //contentPadding: EdgeInsets.all(
                        //    MediaQuery.of(context).size.height * 0.05)
                      ),
                    ),
                  ),
                  Align(
                    //El textbutton de por si solo ocupa el espacio necesario para el texto, por lo que colocar el  textAlign: TextAlign.end, como propiedad no funciona, por eso se mete dentro de un Align la porqueria esta
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            minimumSize: Size(
                                double.infinity,
                                MediaQuery.of(context).size.height *
                                    0.06) //Debería ser 5% pero los textfield tienen un padding interno, lo que hace verlos mas grande
                            ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.025),
                          child: Center(
                              child: AutoSizeText("Iniciar sesión",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontFamily: "GothamMedium",
                                      fontSize: 12.sp),
                                  maxLines: 2, // Máximo de líneas
                                  minFontSize: 5, // Tamaño mínimo de la fuente
                                  maxFontSize: 28)),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿No tienes una cuenta? ",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontFamily: "GothamBook",
                            fontSize: 11.r
                          )),
                      TextButton(
                        onPressed: () {
                          //print("Navegar a la pantalla de registro");
                          // Puedes usar Navigator.push aquí
                        },
                        child: Text(
                          "Regístrate",
                          style: TextStyle(
                            color: AppColors.accentColor,
                            fontFamily: "GothamMedium",
                            fontSize: 11.r
                          ),
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
                        fontSize: 11.r
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.facebook,
                            size: MediaQuery.of(context).size.height *
                                0.03, // Tamaño del ícono

                            color: AppColors.primaryColor,
                          )),
                      Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.03,
                            right: MediaQuery.of(context).size.height * 0.03),
                        child: InkWell(
                            onTap: () {},
                            child: Icon(
                              FontAwesomeIcons.google,
                              size: MediaQuery.of(context).size.height *
                                  0.03, // Tamaño del ícono

                              color: AppColors.primaryColor,
                            )),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          FontAwesomeIcons.linkedin,
                          size: MediaQuery.of(context).size.height *
                              0.03, // Tamaño del ícono

                          color: AppColors.primaryColor,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ))
      ])),
    );
  }
}
