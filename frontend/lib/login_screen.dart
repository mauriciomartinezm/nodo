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
      body: Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.headlineMedium!.fontSize! * 1.1 +
              200.0,
        ),
        padding: const EdgeInsets.all(8.0),
        //color: AppColors.primaryColor,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryColor, // Color de fondo del Container
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(100),
          ),
        ),
        child: Text(
          'Inicia sesión y descubre nuevas oportunidades de trabajo y servicios en un solo lugar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Arial',
          ),
        ),
      ),
    );
  }
}
