import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:nodo/core/theme/app_theme.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? CircularProgressIndicator(color: AppColors.white)
          : ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.025,
              ),
              child: Center(
                child: AutoSizeText(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  minFontSize: 5,
                  maxFontSize: 28,
                ),
              ),
            ),
    );
  }
}
