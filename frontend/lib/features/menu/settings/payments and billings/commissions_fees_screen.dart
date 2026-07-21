import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import '../widgets/settings_sub_header.dart';

class CommissionsFeesScreen extends StatelessWidget {
  const CommissionsFeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      body: Column(
        children: [
          const SettingsSubHeader(
            title: 'Comisiones y tarifas',
            subtitle: 'Transparencia total en cada cobro',
            icon: Icons.percent_rounded,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('CLIENTES', AppColors.blue),
                  SizedBox(height: 10.h),
                  _infoCard([
                    _item('¿Cuánto cuesta publicar?',
                        'Publicar en NODO es completamente gratis. Solo pagas lo que acuerdas con el trabajador.'),
                  ]),
                  SizedBox(height: 10.h),
                  _infoCard([
                    _item('Transparencia total',
                        'El precio que determines es el que recibe el trabajador, ya descontadas sus comisiones.'),
                    _item('Negociación directa',
                        'NODO no interviene en la negociación del precio.'),
                    _item('Contraoferta posible',
                        'Algunos trabajadores pueden hacerte una contraoferta al aplicar sus comisiones.'),
                  ]),
                  SizedBox(height: 16.h),
                  _divider(),
                  SizedBox(height: 16.h),
                  _sectionHeader('TRABAJADORES', AppColors.orange),
                  SizedBox(height: 10.h),
                  _infoCard([
                    _item('¿Cómo se calculan mis ingresos?',
                        'Cuando completas un trabajo, la pasarela de pagos aplica su tarifa y luego se descuenta la comisión de NODO sobre el monto restante.'),
                  ]),
                  SizedBox(height: 10.h),
                  _gatewayCard(),
                  SizedBox(height: 10.h),
                  _commissionsTable(),
                  SizedBox(height: 10.h),
                  _exampleCard(),
                  SizedBox(height: 16.h),
                  _divider(),
                  SizedBox(height: 16.h),
                  _infoCard([
                    _item('¿Tienes dudas?',
                        'Puedes revisar los métodos de pago aceptados o contactar con soporte desde la sección de ayuda.'),
                  ]),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String label, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontFamily: 'GothamMedium',
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _infoCard(List<Widget> items) {
    return _card(
      Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        ),
      ),
    );
  }

  Widget _item(String title, String body) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTypography.label.copyWith(
                  color: AppColors.blue, fontFamily: 'GothamMedium')),
          SizedBox(height: 3.h),
          Text(body,
              style:
                  AppTypography.body.copyWith(color: AppColors.slateGrey)),
        ],
      ),
    );
  }

  Widget _gatewayCard() {
    return _card(
      Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Icon(Icons.bolt_rounded, color: AppColors.orange, size: 20.r),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pasarela de pagos',
                      style: AppTypography.label.copyWith(
                          color: AppColors.blue, fontFamily: 'GothamMedium')),
                  SizedBox(height: 2.h),
                  Text('2.99% + \$900 COP (incluye IVA)',
                      style: AppTypography.body
                          .copyWith(color: AppColors.slateGrey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _commissionsTable() {
    final rows = [
      ['\$25.000 – \$100.000 COP', '10%'],
      ['\$100.000 – \$300.000 COP', '7.5%'],
      ['Mayor a \$300.000 COP', '5%'],
    ];
    return _card(
      Column(
        children: [
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Valor del trabajo',
                      style: AppTypography.label
                          .copyWith(color: Colors.white)),
                ),
                Text('Comisión NODO',
                    style:
                        AppTypography.label.copyWith(color: Colors.white)),
              ],
            ),
          ),
          ...List.generate(rows.length, (i) {
            final isLast = i == rows.length - 1;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(rows[i][0],
                            style: AppTypography.body
                                .copyWith(color: AppColors.blue)),
                      ),
                      Text(rows[i][1],
                          style: AppTypography.label.copyWith(
                              color: AppColors.blue,
                              fontFamily: 'GothamMedium')),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 16.w,
                    color: AppColors.slateGrey.withValues(alpha: 0.15),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _exampleCard() {
    final rows = [
      ['Cliente paga:', '\$200.000 COP'],
      ['Pasarela cobra:', '\$6.880 COP'],
      ['Queda:', '\$193.120 COP'],
      ['Comisión NODO (7.5%):', '\$14.484 COP'],
      ['Recibes:', '\$178.636 COP'],
    ];
    return _card(
      Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calculate_outlined,
                    color: AppColors.blue, size: 16.r),
                SizedBox(width: 6.w),
                Text('Ejemplo práctico',
                    style: AppTypography.label.copyWith(
                        color: AppColors.blue, fontFamily: 'GothamMedium')),
              ],
            ),
            SizedBox(height: 10.h),
            ...List.generate(rows.length, (i) {
              final isTotal = i == rows.length - 1;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(rows[i][0],
                        style: AppTypography.body.copyWith(
                            color: isTotal
                                ? AppColors.blue
                                : AppColors.slateGrey,
                            fontFamily:
                                isTotal ? 'GothamMedium' : 'GothamBook')),
                    Text(rows[i][1],
                        style: AppTypography.body.copyWith(
                            color: isTotal
                                ? AppColors.blue
                                : AppColors.slateGrey,
                            fontFamily:
                                isTotal ? 'GothamMedium' : 'GothamBook')),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
              color: AppColors.orange.withValues(alpha: 0.4), thickness: 1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Icon(Icons.circle, color: AppColors.orange, size: 6.r),
        ),
        Expanded(
          child: Divider(
              color: AppColors.orange.withValues(alpha: 0.4), thickness: 1),
        ),
      ],
    );
  }
}
