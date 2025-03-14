import 'package:flutter/material.dart';
import 'app_colors.dart';

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
    return Scaffold(
        body: Column(children: [
      Expanded(
        flex: 3,
        child: Container(
            constraints: BoxConstraints.expand(
              height:
                  Theme.of(context).textTheme.headlineMedium!.fontSize! * 1.1 +
                      250.0,
            ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryColor, // Color de fondo del Container
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(100),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/iconNodoWhite.png',
                  width: 100,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Inicia sesión y descubre nuevas oportunidades de trabajo y servicios en un solo lugar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'GothamMedium',
                  ),
                ),
              ],
            )),
      ),
      Expanded(
          flex: 7,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(''), //Imagen de fondo
            )),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      labelText: "Correo electrónico o teléfono",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: "Contraseña",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                Align(
                  //El textbutton de por si solo ocupa el espacio necesario para el texto, por lo que colocar el  textAlign: TextAlign.end, como propiedad no funciona, por eso se mete dentro de un Align la porqueria esta
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(color: AppColors.accentColor),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                    ),
                    child: const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Iniciar sesión",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.secondaryColor),
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("¿No tienes una cuenta? ",
                        style: TextStyle(color: AppColors.primaryColor, fontFamily: "GothamBook")),
                    TextButton(
                      onPressed: () {
                        //print("Navegar a la pantalla de registro");
                        // Puedes usar Navigator.push aquí
                      },
                      child: Text(
                        "Regístrate",
                        style: TextStyle(
                            color: AppColors.accentColor, fontFamily: "GothamMedium"),
                      ),
                    ),
                  ],
                ),
                Text(
                  "O continua con: ", style: TextStyle(color: AppColors.primaryColor, fontFamily: "GothamMedium"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image.asset("assets/icons/iconFacebook.png", width: 40,),
                    Image.asset("assets/icons/iconGoogle.png", width: 40,),
                    Image.asset("assets/icons/iconLinkedin.png", width: 40,),
                    
                  ],
                )
              ],
            ),
          ))
    ]));
  }
}
