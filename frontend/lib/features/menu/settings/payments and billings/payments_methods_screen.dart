import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import '../widgets/settings_sub_header.dart';

class PaymentsMethods extends StatefulWidget {
  const PaymentsMethods({super.key});

  @override
  State<PaymentsMethods> createState() => _PaymentsMethodsState();
}

class _PaymentsMethodsState extends State<PaymentsMethods> {
  List<Map<String, String>> metodos = [
    {'tipo': 'Visa', 'numero': '***123', 'predeterminado': 'true'},
    {'tipo': 'Mastercard', 'numero': '***456', 'predeterminado': 'false'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      body: Column(
        children: [
          const SettingsSubHeader(
            title: 'Métodos de pago',
            subtitle: 'Tarjetas y cuentas registradas',
            icon: Icons.credit_card_outlined,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lock_outline_rounded,
                          color: AppColors.blue, size: 16.r),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Tus datos están protegidos mediante cifrado. Solo se usan para procesar pagos de forma segura.',
                          style: AppTypography.caption
                              .copyWith(color: AppColors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                ...List.generate(metodos.length, (i) {
                  final m = metodos[i];
                  final isPrimary = m['predeterminado'] == 'true';
                  return _methodCard(m, i, isPrimary);
                }),
                SizedBox(height: 8.h),
                _addButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _methodCard(Map<String, String> m, int index, bool isPrimary) {
    final icon = m['tipo'] == 'Visa'
        ? Icons.credit_card_rounded
        : Icons.credit_card_outlined;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isPrimary
            ? Border.all(color: AppColors.blue.withValues(alpha: 0.5), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _cardDetails(m, index),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.blue, size: 20.r),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m['tipo']!,
                        style: AppTypography.label.copyWith(
                          color: AppColors.blue,
                          fontFamily: 'GothamMedium',
                        )),
                    SizedBox(height: 2.h),
                    Text(m['numero']!,
                        style: AppTypography.caption
                            .copyWith(color: AppColors.slateGrey)),
                  ],
                ),
              ),
              if (isPrimary)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Principal',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.blue)),
                )
              else
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.slateGrey, size: 20.r),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _formAdd,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(
              color: AppColors.blue.withValues(alpha: 0.3),
              width: 1.5,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: AppColors.blue, size: 20.r),
            SizedBox(width: 8.w),
            Text('Añadir método de pago',
                style: AppTypography.label.copyWith(color: AppColors.blue)),
          ],
        ),
      ),
    );
  }

  void _formAdd() {
    String titular = '';
    String numero = '';
    String fechaCaducidad = '';
    String codigoSeguridad = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Añadir método de pago',
            style: AppTypography.title.copyWith(color: AppColors.blue),
            textAlign: TextAlign.center),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField('Titular', onChanged: (v) => titular = v),
              SizedBox(height: 10.h),
              _dialogField('Número (16 dígitos)',
                  keyboard: TextInputType.number,
                  onChanged: (v) => numero = v),
              SizedBox(height: 10.h),
              _dialogField('Fecha de caducidad',
                  keyboard: TextInputType.number,
                  onChanged: (v) => fechaCaducidad = v),
              SizedBox(height: 10.h),
              _dialogField('Código de seguridad (CVV)',
                  keyboard: TextInputType.number,
                  onChanged: (v) => codigoSeguridad = v),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style:
                    AppTypography.label.copyWith(color: AppColors.slateGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (titular.isNotEmpty && numero.isNotEmpty) {
                setState(() {
                  metodos.add({
                    'titular': titular,
                    'tipo': 'Tarjeta',
                    'numero': '***${numero.length > 4 ? numero.substring(numero.length - 4) : numero}',
                    'fechaCaducidad': fechaCaducidad,
                    'codigoSeguridad': codigoSeguridad,
                    'predeterminado': 'false',
                  });
                });
                Navigator.pop(context);
              }
            },
            child: Text('Agregar', style: AppTypography.label),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(String label,
      {TextInputType? keyboard, required ValueChanged<String> onChanged}) {
    return TextField(
      keyboardType: keyboard,
      onChanged: onChanged,
      style: AppTypography.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.body.copyWith(color: AppColors.slateGrey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
    );
  }

  void _cardDetails(Map<String, String> metodo, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: AppColors.slateGrey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.blue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.credit_card_rounded,
                  color: AppColors.blue, size: 36.r),
            ),
            SizedBox(height: 16.h),
            Text(metodo['tipo'] ?? 'Tarjeta',
                style: AppTypography.title.copyWith(color: AppColors.blue)),
            SizedBox(height: 4.h),
            Text('Número: ${metodo['numero']}',
                style:
                    AppTypography.body.copyWith(color: AppColors.slateGrey)),
            if (metodo['titular']?.isNotEmpty == true) ...[
              SizedBox(height: 4.h),
              Text('Titular: ${metodo['titular']}',
                  style: AppTypography.body
                      .copyWith(color: AppColors.slateGrey)),
            ],
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                onPressed: () {
                  setState(() => metodos.removeAt(index));
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text('Eliminar tarjeta', style: AppTypography.label),
              ),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar',
                  style: AppTypography.label
                      .copyWith(color: AppColors.slateGrey)),
            ),
          ],
        ),
      ),
    );
  }
}
