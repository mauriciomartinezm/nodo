import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import '../widgets/settings_sub_header.dart';

class CommissionCalculatorScreen extends StatefulWidget {
  const CommissionCalculatorScreen({super.key});

  @override
  State<CommissionCalculatorScreen> createState() =>
      _CommissionCalculatorScreenState();
}

class _CommissionCalculatorScreenState
    extends State<CommissionCalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  double? _gatewayFee;
  double? _nodoFee;
  double? _finalAmount;
  double? _nodoRate;
  String? _errorText;

  void _calculate() {
    final raw = _controller.text.replaceAll('.', '').replaceAll(',', '').replaceAll('\$', '');
    final input = double.tryParse(raw);

    if (input == null || input < 25000) {
      setState(() {
        _gatewayFee = null;
        _nodoFee = null;
        _finalAmount = null;
        _nodoRate = null;
        _errorText = 'Ingresa un monto válido (mínimo \$25.000 COP)';
      });
      return;
    }

    final gateway = (input * 0.0299) + 900;
    final afterGateway = input - gateway;

    double rate;
    if (input < 100000) {
      rate = 0.10;
    } else if (input < 300000) {
      rate = 0.075;
    } else {
      rate = 0.05;
    }

    final nodo = afterGateway * rate;
    final final_ = afterGateway - nodo;

    setState(() {
      _gatewayFee = gateway;
      _nodoFee = nodo;
      _finalAmount = final_;
      _nodoRate = rate;
      _errorText = null;
    });
  }

  String _fmt(double v) =>
      '\$${v.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} COP';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      body: Column(
        children: [
          const SettingsSubHeader(
            title: 'Calculadora de ganancias',
            subtitle: 'Estima cuánto recibirás por un trabajo',
            icon: Icons.calculate_outlined,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _inputCard(),
                  SizedBox(height: 12.h),
                  if (_errorText != null) _errorBanner(),
                  if (_finalAmount != null) _resultCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Valor acordado con el cliente',
              style: AppTypography.label.copyWith(
                  color: AppColors.blue, fontFamily: 'GothamMedium')),
          SizedBox(height: 10.h),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            style: AppTypography.body.copyWith(color: AppColors.blue),
            decoration: InputDecoration(
              hintText: 'Ej: 200000',
              hintStyle: AppTypography.body.copyWith(color: AppColors.slateGrey),
              prefixText: '\$ ',
              prefixStyle:
                  AppTypography.body.copyWith(color: AppColors.blue),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: AppColors.blue, width: 1.5),
              ),
            ),
            onSubmitted: (_) => _calculate(),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              onPressed: _calculate,
              icon: const Icon(Icons.calculate_outlined),
              label: Text('Calcular', style: AppTypography.label),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorBanner() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded,
              color: AppColors.error, size: 16.r),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(_errorText!,
                style: AppTypography.caption.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _resultCard() {
    final rows = [
      ['Monto ingresado', _fmt(double.parse(_controller.text.replaceAll('.', '').replaceAll(',', '').replaceAll('\$', '')))],
      ['Comisión pasarela (2.99% + \$900)', '- ${_fmt(_gatewayFee!)}'],
      ['Comisión NODO (${(_nodoRate! * 100).toStringAsFixed(1)}%)', '- ${_fmt(_nodoFee!)}'],
    ];

    return Container(
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
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                ...rows.map((r) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r[0],
                              style: AppTypography.body.copyWith(
                                  color: AppColors.slateGrey)),
                          Text(r[1],
                              style: AppTypography.body
                                  .copyWith(color: AppColors.blue)),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.slateGrey.withValues(alpha: 0.15),
          ),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recibes',
                    style: AppTypography.label.copyWith(
                        color: AppColors.blue, fontFamily: 'GothamMedium')),
                Text(_fmt(_finalAmount!),
                    style: AppTypography.title
                        .copyWith(color: AppColors.blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
