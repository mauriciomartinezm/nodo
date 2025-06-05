import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

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
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.blue,
        elevation: 0,
        title: Text('Métodos de pago registrados', style: AppTypography.h1),
      ),
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Administra las tarjetas o cuentas que tienes vinculadas a tu perfil.',
                style: AppTypography.body.copyWith(color: AppColors.blue),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: metodos.length,
              itemBuilder: (context, index) {
                final metodo = metodos[index];
                final isPredeterminado = metodo['predeterminado'] == 'true';
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Card(
                    elevation: isPredeterminado ? 2 : 0,
                    color: isPredeterminado ? AppColors.blue : AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: AppColors.blue),
                    ),
                    child: ListTile(
                      onTap: () => _cardDetails(metodo, index),
                      title: Text(
                        metodo['tipo']!,
                        style: AppTypography.h3.copyWith(
                          color: isPredeterminado
                              ? AppColors.white
                              : AppColors.blue,
                        ),
                      ),
                      trailing: Text(
                        metodo['numero']!,
                        style: AppTypography.h3.copyWith(
                          color: isPredeterminado
                              ? AppColors.white
                              : AppColors.blue,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                );
              },
            ),
          ),
          TextButton(
            onPressed: _formAdd,
            child: Text('+ Añadir método de pago',
                style: AppTypography.h3.copyWith(color: AppColors.blue)),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Tus datos están protegidos mediante cifrado. Usaremos esta información únicamente para procesar pagos de forma segura.',
              textAlign: TextAlign.center,
              style: AppTypography.body2.copyWith(color: AppColors.blue),
            ),
          ),
        ],
      ),
    );
  }

  void _formAdd() {
    String titular = '';
    String numero = '';
    String fecha_caducidad = '';
    String codigo_seguridad = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Añadir método de pago', 
          style: AppTypography.h2.copyWith(color: AppColors.blue),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Titular',
                labelStyle: TextStyle(color: AppColors.blue),
                enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.blue), //Borde no enfocado
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.blue, //Borde enfocado
                      width: 1.7),
                ),
              ),
              onChanged: (value) => titular = value,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Número (16 dígitos)',
                  labelStyle: AppTypography.body.copyWith(color: AppColors.blue),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.blue), //Borde no enfocado
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.blue, // Borde enfocado
                      width: 1.7),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => numero = value,
            ),
            TextField(
              decoration:
                InputDecoration(
                labelText: 'Fecha de caducidad',
                labelStyle: AppTypography.body.copyWith(color: AppColors.blue),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.blue), //Borde no enfocado
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.blue, // Borde enfocado
                      width: 1.7),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => fecha_caducidad = value,
            ),
            TextField(
              decoration:
                InputDecoration(labelText: 'Código de seguridad (cvv)',
                labelStyle: AppTypography.body.copyWith(color: AppColors.blue),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.blue), //Borde no enfocado
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.blue, // Borde enfocado
                      width: 1.7),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => codigo_seguridad = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style: AppTypography.h3.copyWith(color: AppColors.blue))   
          ),
          ElevatedButton(
            onPressed: () {
              if (titular.isNotEmpty && numero.isNotEmpty) {
                setState(() {
                  metodos.add({
                    'titular': titular,
                    'numero': '***$numero',
                    'predeterminado': 'false',
                  });
                });
                Navigator.pop(context);
              }
            },
            // backgroundColor: AppColors.blue,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue),
            child: Text('Agregar', style: AppTypography.h3.copyWith(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

void _cardDetails(Map<String, String> metodo, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.credit_card, size: 40, color: AppColors.blue),
              const SizedBox(height: 10),
              Text(
                'Titular: ${metodo['titular']}',
                style: AppTypography.body,
              ),
              const SizedBox(height: 10),
              Text(
                'Número: ${metodo['numero']}',
                style: AppTypography.body,
              ),
              const SizedBox(height: 10),
              Text(
                '${metodo['tipo']}',
                style: AppTypography.h2.copyWith(color: AppColors.blue),
              ),
              const SizedBox(height: 5),
              Text(
                'Número de seguridad: ${metodo['codigo_seguridad']}',
                style: AppTypography.body,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    metodos.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Eliminar tarjeta'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: AppColors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}