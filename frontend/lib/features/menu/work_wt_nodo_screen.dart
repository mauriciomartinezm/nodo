import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/register/screens/register_screen.dart';

class WorkWtNodo extends StatelessWidget {
  const WorkWtNodo({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '¿Quieres ofrecer tus servicios?',
          style: AppTypography.h1,
        ),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.blue,
      body: Stack(
        children: [
          //Icono de fondo
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/icons/iconNodoWhite.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          //Icono
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/icons/iconNodoWhite.png',
                      width: 40,
                      height: 40,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Únete a la creciente comunidad de trabajadores que ya están generando ingresos con NODO y empieza tú también.',
                    style: AppTypography.h3.copyWith(color: AppColors.white),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 20),

                  ..._benefitList(isSmall),

                  Text(
                    '¿Cómo funciona?',
                    style: AppTypography.h2.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 8),

                  ..._stepTexts([
                    '1. Crea tu perfil como trabajador',
                    '2. Revisa publicaciones de servicios',
                    '3. Postúlate a los trabajos que te interesen',
                    '4. Completa el trabajo y recibe tu pago',
                  ], isSmall),

                  const SizedBox(height: 30),

                  Text(
                    'Nodo cobra una comisión justa solo cuando completas un trabajo. No pagas por usar la plataforma ni por postularte.',
                    style: AppTypography.body2.copyWith(color: AppColors.white),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: Text(
                        'Activar mi perfil como trabajador',
                        style: AppTypography.h2.copyWith(color: AppColors.orange),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _benefitList(bool isSmall) {
    final items = [
      {
        'title': 'Consigue clientes fácilmente',
        'desc':
            'Accede a nuevas oportunidades laborales de manera sencilla. Recibe notificaciones cada vez que se publique una solicitud en tu categoría y elige las que mejor se adapten a tus habilidades y disponibilidad.',
      },
      {
        'title': 'Gana por lo que sabes hacer',
        'desc':
            'Tu experiencia vale: elige solo los trabajos que te interesen y donde la paga esté alineada con lo que consideras justo.',
      },
      {
        'title': 'Habla directamente con los clientes',
        'desc':
            'Comunícate directamente con quienes solicitan tus servicios. Resuelve dudas, acuerda fechas y condiciones, y mantén una relación clara y cercana sin intermediarios que limiten tu libertad.',
      },
      {
        'title': 'Pagos seguros y seguimiento claro',
        'desc':
            'Trabaja con la tranquilidad de que tus pagos están protegidos. La plataforma garantiza un proceso de pago seguro y transparente, con todo el seguimiento necesario en un solo lugar.',
      },
      {
        'title': 'Gana reputación y destácate',
        'desc':
            'Cada trabajo completado con éxito suma a tu reputación. Obtén valoraciones positivas, gana insignias y mejora tu visibilidad para atraer más clientes y crecer profesionalmente en la comunidad de NODO.',
      },
    ];


    return items
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: AppTypography.h2.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    item['desc']!,
                    style: AppTypography.body.copyWith(color: AppColors.white),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  List<Widget> _stepTexts(List<String> steps, bool isSmall) {
    return steps
      .map(
        (s) => Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
             s,
          style: AppTypography.body.copyWith(color: AppColors.white),
          ),
        ),
      ).toList();
  }
}