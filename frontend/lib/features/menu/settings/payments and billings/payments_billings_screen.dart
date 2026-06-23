import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class PaymentsBillings extends StatelessWidget {
  const PaymentsBillings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.blue,
        elevation: 0,
        title: Text(
          'Pagos y facturación',
          style: AppTypography.title,
        ),
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Métodos de pagos registrados',
                  style: AppTypography.subtitle.copyWith(color: AppColors.blue)),
              onTap: () {
                Navigator.pushNamed(context, '/PaymentsMethods');
              },
            ),
            ListTile(
              title: Text('Historial de transaccciones',
                  style: AppTypography.subtitle.copyWith(color: AppColors.blue)),
              onTap: () {
                // Navigator.pushNamed(context, '/editProfile');
              },
            ),

            ListTile(
              title: Text('Comisiones y tarifas',
                  style: AppTypography.subtitle.copyWith(color: AppColors.blue)),
              onTap: () {
                Navigator.pushNamed(context, '/CommissionsFeesScreen');
              },
            ),

            ListTile(
              title: Text('Ingresos obtenidos',
                  style: AppTypography.subtitle.copyWith(color: AppColors.blue)),
              onTap: () {
                Navigator.pushNamed(context, '/YourIncome');
              },
            ),

            ListTile(
              title: Text('Caluladora de ganancias',
                  style: AppTypography.subtitle.copyWith(color: AppColors.blue)),
              onTap: () {
                Navigator.pushNamed(context, '/CommissionCalculatorScreen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
