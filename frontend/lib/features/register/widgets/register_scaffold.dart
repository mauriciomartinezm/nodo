import 'package:flutter/material.dart';
import 'package:nodo/features/register/widgets/progress.dart';
import 'package:provider/provider.dart';
import 'package:nodo/providers/userprovider.dart';

class RegisterScaffold extends StatelessWidget {
  final String title;
  final int stepIndex;
  final Widget formContent;
  final VoidCallback onNext;
  final bool showNextButton;

  const RegisterScaffold({
    required this.title,
    required this.stepIndex,
    required this.formContent,
    required this.onNext,
    this.showNextButton = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.05;
    final topSpacing = screenHeight * 0.01;
    final betweenSpacing = screenHeight * 0.015;
    final bottomSpacing = screenHeight * 0.02;

    // Obtengo el isWorker del provider aquí
    final isWorker = Provider.of<UserProvider>(context).isWorker;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: topSpacing),
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/icons/iconNodoBlue.png',
                        height: screenHeight * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: betweenSpacing),
              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.055,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1C2D41),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Expanded(child: formContent),
              Row(
                mainAxisAlignment: showNextButton
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  ProgressDots(
                    activeIndex: stepIndex,
                    isWorker: isWorker,  // <---- paso el isWorker aquí
                  ),
                  if (showNextButton)
                    TextButton(
                      onPressed: onNext,
                      child: Text(
                        'Siguiente',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                          color: const Color(0xFF1C2D41),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: bottomSpacing),
            ],
          ),
        ),
      ),
    );
  }
}