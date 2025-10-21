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

  /*@override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        minimumSize: Size(
          double.infinity,
          MediaQuery.of(context).size.height * 0.06,
        ),
      ),
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
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: "GothamMedium",
                    fontSize: 12.sp,
                  ),
                  maxLines: 2,
                  minFontSize: 5,
                  maxFontSize: 28,
                ),
              ),
            ),
    );
  }*/
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
