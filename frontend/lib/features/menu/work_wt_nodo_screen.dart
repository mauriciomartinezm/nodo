import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/activate_worker/screens/activate_worker_screen.dart';

class WorkWtNodo extends StatelessWidget {
  const WorkWtNodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '¿Quieres ofrecer tus servicios?',
          style: AppTypography.title.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.blue,
      body: Stack(
        children: [
          // Icono de fondo
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/icons/iconNodoWhite.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/icons/iconNodoWhite.png',
                      width: 48.w,
                      height: 48.w,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Únete a la creciente comunidad de trabajadores que ya están generando ingresos con NODO y empieza tú también.',
                    style: AppTypography.label.copyWith(color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ..._benefitCards(),
                  SizedBox(height: 8.h),
                  _howItWorksCard(),
                  SizedBox(height: 20.h),
                  Text(
                    'Nodo cobra una comisión justa solo cuando completas un trabajo. No pagas por usar la plataforma ni por postularte.',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.white.withValues(alpha: 0.85),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.orange,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 14.h),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ActivateWorkerScreen()),
                        );
                      },
                      label: Text(
                        'Activar mi perfil como trabajador',
                        style: AppTypography.subtitle.copyWith(color: AppColors.orange),
                      ),
                      icon: Icon(Icons.arrow_forward, color: AppColors.orange, size: 18.r),
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

  Widget _benefitCard(IconData icon, String title, String desc) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.orange, size: 20.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.subtitle.copyWith(color: AppColors.blue)),
                SizedBox(height: 4.h),
                Text(
                  desc,
                  style: AppTypography.body
                      .copyWith(color: AppColors.blue.withValues(alpha: 0.75)),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _benefitCards() {
    final items = [
      (
        Icons.group_outlined,
        'Consigue clientes fácilmente',
        'Accede a nuevas oportunidades laborales de manera sencilla. Recibe notificaciones cada vez que se publique una solicitud en tu rubro y elige las que mejor se adapten a tus habilidades y disponibilidad.',
      ),
      (
        Icons.handyman_outlined,
        'Gana por lo que sabes hacer',
        'Tu experiencia vale: elige solo los trabajos que te interesen y donde la paga esté alineada con lo que consideras justo.',
      ),
      (
        Icons.chat_bubble_outline,
        'Habla directamente con los clientes',
        'Comunícate directamente con quienes solicitan tus servicios. Resuelve dudas, acuerda fechas y condiciones, y mantén una relación clara y cercana sin intermediarios que limiten tu libertad.',
      ),
      (
        Icons.verified_user_outlined,
        'Pagos seguros y seguimiento claro',
        'Trabaja con la tranquilidad de que tus pagos están protegidos. La plataforma garantiza un proceso de pago seguro y transparente, con todo el seguimiento necesario en un solo lugar.',
      ),
      (
        Icons.military_tech_outlined,
        'Gana reputación y destácate',
        'Cada trabajo completado con éxito suma a tu reputación. Obtén valoraciones positivas, gana insignias y mejora tu visibilidad para atraer más clientes y crecer profesionalmente en la comunidad de NODO.',
      ),
    ];

    return items.map((item) => _benefitCard(item.$1, item.$2, item.$3)).toList();
  }

  Widget _howItWorksCard() {
    final steps = [
      'Crea tu perfil como trabajador',
      'Revisa publicaciones de servicios',
      'Postúlate a los trabajos que te interesen',
      'Completa el trabajo y recibe tu pago',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_outlined, size: 16.r, color: AppColors.blue),
              SizedBox(width: 6.w),
              Text('¿Cómo funciona?',
                  style: AppTypography.label.copyWith(color: AppColors.blue)),
            ],
          ),
          SizedBox(height: 12.h),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == steps.length - 1 ? 0 : 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22.r,
                    height: 22.r,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: AppTypography.caption.copyWith(color: AppColors.white),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      steps[i],
                      style: AppTypography.body.copyWith(color: AppColors.blue),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
