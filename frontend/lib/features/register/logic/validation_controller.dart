import 'dart:async';
import 'package:flutter/material.dart';

class ValidationController extends ChangeNotifier {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  int secondsRemaining = 30;
  bool canResend = false;
  Timer? _timer;

  ValidationController() {
    startCountdown();
  }

  void startCountdown() {
    canResend = false;
    secondsRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsRemaining--;
      if (secondsRemaining == 0) {
        canResend = true;
        _timer?.cancel();
      }
      notifyListeners();
    });
  }

  void onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String getEnteredCode() => controllers.map((c) => c.text).join();

  void disposeResources() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
  }
}
