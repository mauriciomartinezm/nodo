import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class CommissionCalculatorScreen extends StatefulWidget {
  const CommissionCalculatorScreen({super.key});

  @override
  State<CommissionCalculatorScreen> createState() =>
      _CommissionCalculatorScreenState();
}

class _CommissionCalculatorScreenState
    extends State<CommissionCalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  double? _finalAmount;
  String _details = '';

  void _calculateCommission() {
    final input = double.tryParse(
        _controller.text.replaceAll(',', '').replaceAll('\$', ''));

    if (input == null || input < 25000) {
      setState(() {
        _finalAmount = null;
        _details = 'Por favor ingresa un monto válido (mínimo \$25.000 COP).';
      });
      return;
    }


    //Descuento de la pasarela
    final gatewayFee = (input * 0.0299) + 900;
    final afterGateway = input - gatewayFee;

    // Paso 2: Comisión de Nodo
    double nodoCommissionRate =0;
    if (input >= 25000 && input < 100000) {
      nodoCommissionRate = 0.10;
    } else if (input >= 100000 && input < 300000) {
      nodoCommissionRate = 0.075;
    } else if (input >=300000) {
      nodoCommissionRate = 0.05;
    }

    final nodoFee = afterGateway * nodoCommissionRate;
    final finalAmount = afterGateway - nodoFee;

    setState(() {
      _finalAmount = finalAmount;
      _details = '''
Pasarela: \$${gatewayFee.toStringAsFixed(0)}
Comisión Nodo (${(nodoCommissionRate*100).toStringAsFixed(1)}%): \$${nodoFee.toStringAsFixed(0)}
Total recibido: \$${finalAmount.toStringAsFixed(0)}
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de ganancias', style: AppTypography.h1),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.blue,
        surfaceTintColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text('Ingresa el valor acordado con el cliente en COP:',
                style: AppTypography.h3.copyWith(color: AppColors.blue)),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ej: \$200.000',
                labelStyle: TextStyle(color: AppColors.blue),
                //Borde no enfocado
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.blue), 
                ),
                //Borde enfocado
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.blue, 
                      width: 1.7),
                ),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: _calculateCommission,
              child: Text('Calcular', style: AppTypography.h2,
              ),
            ),

            const SizedBox(height: 24),

            if (_finalAmount != null || _details.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _details,
                  style: AppTypography.body.copyWith(color: AppColors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
