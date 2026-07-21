import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class YourIncome extends StatelessWidget {
  const YourIncome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tus ingresos en NODO',
          style: AppTypography.title,
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.blue,
        elevation: 0,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView(
          children: [
            Text(
              'Consulta cuanto has ganado a traves de la app.',
              style: AppTypography.body.copyWith(color: AppColors.blue),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 20),

            //Selector de período
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  _PeriodButton('Hoy'),
                  SizedBox(width: 8),
                  _PeriodButton('Últimos 15 días'),
                  SizedBox(width: 8),
                  _PeriodButton('Último mes'),
                  SizedBox(width: 8),
                  _PeriodButton('Último año'),
                  SizedBox(width: 8),
                  _PeriodButton('Total'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Período: Último mes',
                style: AppTypography.subtitle.copyWith(
                  color: AppColors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),

            //Tarjeta total ganado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    AppColors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total ganado:',
                    style: AppTypography.label.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$2.200.000 COP',
                    style: AppTypography.title.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Los ingresos mostrados ya tienen aplicada la comisión de la pasarela de pagos y la comisión de Nodo. El valor mostrado como "Total ganado" es el dinero neto transferido a tu cuenta.',
              style: AppTypography.body.copyWith(color: AppColors.blue),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String text;

  const _PeriodButton(this.text);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.blue,
        side: BorderSide(color: AppColors.blue),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(text),
    );
  }
}
