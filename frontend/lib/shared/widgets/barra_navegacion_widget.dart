// En tu archivo barra_navegacion_widget.dart
import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_colors.dart';

class BarraNavegacionWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;

  const BarraNavegacionWidget({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: AppColors.primaryColor,
      indicatorColor: Color.fromARGB(51, 255, 255, 255),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.web, color: AppColors.secondaryColor),
            label: ""),
        NavigationDestination(
            icon: Icon(Icons.work, color: AppColors.secondaryColor), label: ""),
        NavigationDestination(
            icon: Icon(Icons.add_circle, color: AppColors.secondaryColor),
            label: ""),
        NavigationDestination(
            icon: Icon(Icons.notifications, color: AppColors.secondaryColor),
            label: ""),
        NavigationDestination(
            icon: Icon(Icons.menu, color: AppColors.secondaryColor), label: ""),
      ],
      selectedIndex: currentIndex,
      onDestinationSelected: onIndexChanged,
      height: MediaQuery.of(context).size.height * 0.07, // Por defecto es 80
    );
  }
}
