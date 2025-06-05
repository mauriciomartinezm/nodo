import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class CommissionsFeesScreen extends StatelessWidget {
  const CommissionsFeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comisiones y tarifas',
          style: AppTypography.h1
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.blue,
        surfaceTintColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: AppTypography.h2.copyWith(color: AppColors.blue),
                children: const [
                  TextSpan(text: 'Comisiones y tarifas - '),
                  TextSpan(
                    text: 'CLIENTES',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              '¿Cuánto cuesta usar NODO como cliente?',
              style: AppTypography.h3.copyWith(color: AppColors.blue),
              textAlign: TextAlign.justify,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Text(
                'Publicar en NODO es completamente gratis. Solo pagas el valor que acuerdas con el trabajador.',
                style: AppTypography.body.copyWith(color: AppColors.blue),
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 15),
            Text(
              'Transparencia total',
              style: AppTypography.h3.copyWith(color: AppColors.blue),
            ),
            const SizedBox(height: 4),
            bulletPoint(
              'El precio que determines será el que reciba el trabajador, una vez descontadas sus comisiones.'),
            bulletPoint(
              'Puedes acordar el precio final directamente con el trabajador antes de contratar.'),

            const SizedBox(height: 10),

            Text(
              'Importante saber:',
              style: AppTypography.h3.copyWith(color: AppColors.blue),
            ),
            const SizedBox(height: 4),
            bulletPoint(
              'Dado que se les aplican comisiones, algunos trabajadores pueden modificar sus tarifas y hacerte una contraoferta en respuesta a tus publicaciones.'),
            bulletPoint(
              'NODO no interviene en la negociación del precio entre el trabajador y tú.'),

            const SizedBox(height: 15),
            Divider(color: AppColors.orange),
            const SizedBox(height: 15),

            RichText(
              text: TextSpan(
                style: AppTypography.h2.copyWith(color: AppColors.blue),
                children: const [
                  TextSpan(text: 'Comisiones y tarifas - '),
                  TextSpan(
                    text: 'TRABAJADORES',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Text(
                'Cuando completas un trabajo, la pasarela de pagos aplica su tarifa y luego se descuenta nuestra comisión sobre el monto restante.',
                style: AppTypography.body.copyWith(color: AppColors.blue),
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Text(
                'Tarifa de la pasarela de pagos',
                style: AppTypography.h3.copyWith(color: AppColors.blue),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Text(
                    '2.99% + \$900 COP',
                    style: AppTypography.body.copyWith(color: AppColors.blue),
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message:
                      'Este valor incluye el impuesto (IVA) correspondiente por el uso del servicio',
                  child: const Icon(Icons.info_outline,
                      size: 16, color: Colors.orange),
                ),
              ],
            ),

            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Text(
                'Comisión escalonada de NODO',
                style: AppTypography.h3.copyWith(color: AppColors.blue),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(8), //Esquinas redondeadas
                  border: Border.all(color: AppColors.blue), //Bordes externos
                ),
                child: Table(
                  border: TableBorder(
                    horizontalInside: BorderSide(color: AppColors.blue), //divisiones internas
                    verticalInside: BorderSide(
                      color: AppColors.blue,
                      width: 1,
                    ),
                    //Wlimina los bordes
                    left: BorderSide.none, 
                    right: BorderSide.none, 
                    top: BorderSide.none, 
                    bottom: BorderSide.none, 
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(2), //Columna izquierda
                    1: FlexColumnWidth(1), //Columna derecha
                  },
                  children: [
                    _buildTableRow(
                      ['Valor del trabajo', 'Comisión de NODO',],
                      backgroundColor: AppColors.blue, // Fondo azul claro
                      textStyle: AppTypography.h3.copyWith(color: AppColors.white),
                    ),
                    _buildTableRow(['25.000 a 100.000 COP', '10%']),
                    _buildTableRow(['\$100.000 a \$300.000 COP', '7.5%']),
                    _buildTableRow(['Mayor a \$300.000 COP', '5%']),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Text(
                'Ejemplo práctico:',
                style: AppTypography.h3.copyWith(color: AppColors.blue),
              ),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Column(
                children: [
                  exampleRow('Cliente paga:', '\$200.000 COP'),
                  exampleRow('Pasarela cobra:', '\$6.880 COP'),
                  exampleRow('Queda:', '\$193.120 COP'),
                  exampleRow('Comisión Nodo (7,5%):', '\$14.484 COP'),
                  exampleRow('Recibes:', '\$178.636 COP'),
                ],
              ),
            ),
            
            const SizedBox(height: 15),
            Divider(color: AppColors.orange),
            const SizedBox(height: 15),

            Text(
              '¿Tienes dudas?',
              style: AppTypography.h3.copyWith(color: AppColors.blue),
            ),
            const SizedBox(height: 5),
            linkText('Ver métodos de pago aceptados'),
            const SizedBox(height: 5),
            linkText('Contactar con soporte'),
          ],
        ),
      ),
    );
  }

  //wdgt que controlas los bulletPoints
  Widget bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: AppTypography.h3.copyWith(color: AppColors.orange),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTypography.body.copyWith(color: AppColors.blue),
            ),
          ),
        ],
      ),
    );
  }
  //wdgt que controla el ejemplo
  Widget exampleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTypography.body.copyWith(color: AppColors.blue)),
          Text(value,
              style: AppTypography.body.copyWith(color: AppColors.blue),
          ),
        ],
      ),
    );
  }
  
  //wdgt para controlar el linktext 
  Widget linkText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: AppTypography.body.copyWith(
          color: AppColors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

//Metodo para controlar la tabla
  TableRow _buildTableRow(
    List<String> cells, {
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: backgroundColor != null
            ? const BorderRadius.vertical(top: Radius.circular(8))
            : null,
      ),
      children: cells.map((text) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            text,
            style:
                textStyle ?? AppTypography.body.copyWith(color: AppColors.blue),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
}