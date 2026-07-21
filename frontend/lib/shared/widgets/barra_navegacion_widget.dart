import 'package:flutter/material.dart';
import 'package:nodo/core/theme/app_theme.dart';

class BarraNavegacionWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;

  const BarraNavegacionWidget({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  void _openEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, -2), blurRadius: 4)
        ],
      ),
      child: Stack(
        children: [
          NavigationBar(
            backgroundColor: AppColors.blue,
            indicatorColor: AppColors.blue,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            destinations: [
              const NavigationDestination(
                  icon: Icon(Icons.apps_rounded, color: AppColors.white), label: ""),
              const NavigationDestination(
                  icon: Icon(Icons.work_outline_rounded, color: AppColors.white), label: ""),
              const NavigationDestination(
                  icon: Icon(Icons.notifications_none_sharp, color: AppColors.white),
                  label: ""),
              NavigationDestination(
                icon: SizedBox.expand(
                  child: GestureDetector(
                    behavior:
                        HitTestBehavior.opaque, // Asegura que el área completa sea clickeable
                    onTap: () => _openEndDrawer(context),
                    child: const Icon(Icons.menu_sharp, color: AppColors.white),
                  ),
                ),
                label: "",
              ),
            ],
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              if (index != 3) onIndexChanged(index);
            },
          ),
        ],
      ),
    );
  }
}
