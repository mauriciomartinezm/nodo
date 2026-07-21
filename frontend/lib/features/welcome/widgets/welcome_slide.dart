import 'package:flutter/material.dart';

/// Plantilla visual reutilizable para cada slide del onboarding.
///
/// Slides 1 y 2 usan [backgroundImage] con la caja anclada abajo.
/// Slide 3 no tiene imagen de fondo: la caja queda arriba ([boxAtTop])
/// y [belowBoxChild] ocupa el resto de la pantalla.
class WelcomeSlide extends StatelessWidget {
  final String? backgroundImage;
  final bool boxAtTop;
  final Widget boxChild;
  final Widget? belowBoxChild;

  const WelcomeSlide({
    super.key,
    this.backgroundImage,
    this.boxAtTop = false,
    required this.boxChild,
    this.belowBoxChild,
  });

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(6, 54, 102, 1.0),
        borderRadius: BorderRadius.only(
          topRight: boxAtTop ? Radius.zero : const Radius.circular(100),
          bottomRight: boxAtTop ? const Radius.circular(100) : Radius.zero,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: boxChild,
    );

    if (backgroundImage != null) {
      return Stack(
        children: [
          Positioned.fill(
            child: Image.asset(backgroundImage!, fit: BoxFit.cover),
          ),
          Column(children: [const Spacer(), box]),
        ],
      );
    }

    return Column(
      children: [
        box,
        if (belowBoxChild != null) Expanded(child: belowBoxChild!),
      ],
    );
  }
}

/// Indicador de puntos compartido por todos los slides.
class WelcomeSlideDots extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const WelcomeSlideDots({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: index == currentPage ? 10 : 6,
            height: index == currentPage ? 10 : 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentPage ? Colors.orange : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
