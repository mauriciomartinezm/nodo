import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:nodo/features/register/widgets/register_scaffold.dart';
import 'registerclient4.dart';
import 'register5.dart';
import 'package:provider/provider.dart';
import 'package:nodo/providers/userprovider.dart';

class RegisterClient3 extends StatefulWidget {
  const RegisterClient3({super.key});

  @override
  State<RegisterClient3> createState() => _RegisterClient3State();
}

class _RegisterClient3State extends State<RegisterClient3> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _secondsRemaining = 30;
  late Timer _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _canResend = false;
    _secondsRemaining = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
        if (_secondsRemaining == 0) {
          _canResend = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyCode() {
    final code = _controllers.map((c) => c.text).join();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isWorker = userProvider.isWorker;

    if (code.length == 6) {
      if (isWorker) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Register5()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterClient4()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa los 6 dígitos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? screenWidth * 0.1 : 16.0;
  

    final formContent = Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Hemos enviado un código de 6 dígitos a tu correo electrónico. Ingrésalo a continuación.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 55,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blueGrey),
                        ),
                      ),
                      onChanged: (value) => _onChanged(value, index),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: screenWidth * 0.85,
                child: ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A3557),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Verificar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
                  children: [
                    const TextSpan(text: '¿No recibiste el código? '),
                    _canResend
                        ? TextSpan(
                            text: 'Reenviar',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _startCountdown();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Código reenviado.')),
                                );
                              },
                          )
                        : TextSpan(
                            text: 'Reenviar en $_secondsRemaining s.',
                            style: const TextStyle(color: Colors.black),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return RegisterScaffold(
      title: 'Verificación',
      stepIndex: 2,
      formContent: formContent,
      onNext: _verifyCode,
      // isWorker lo maneja internamente RegisterScaffold para ProgressDots
    );
  }
}
