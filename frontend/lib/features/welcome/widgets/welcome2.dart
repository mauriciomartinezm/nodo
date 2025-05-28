// welcome2.dart
import 'package:flutter/material.dart';
import 'welcome3.dart'; // Importa la tercera pantalla de bienvenida

class Welcome2Screen extends StatefulWidget {
  const Welcome2Screen({super.key});

  @override
  State<Welcome2Screen> createState() => _Welcome2ScreenState();
}

class _Welcome2ScreenState extends State<Welcome2Screen> {
  bool isOmitirPressed = false; // Estado para el botón "Omitir"
  bool isSiguientePressed = false; // Estado para el botón "Siguiente"

  @override
  Widget build(BuildContext context) {
    int currentIndex = 1;
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/icons/img_screen_two.png', // Ruta de la imagen
              fit: BoxFit.cover, // Ajuste para que cubra toda la pantalla
            ),
          ),

          Column(
            children: [
              // Sección inferior (fondo con bordes redondeados)
              Spacer(),
              Container(
                width: double.infinity, // Ancho completo
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                    6,
                    54,
                    102,
                    1.0,
                  ), // Color de fondo
                  borderRadius: const BorderRadius.only(
                    // Borde redondeado en la esquina superior izquierda
                    topRight: Radius.circular(
                      100,
                    ), // Borde redondeado en la esquina superior derecha
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 110),
                    // Descripción
                    const Text(
                      'Publica una solicitud y recibe ofertas de trabajadores calificados em segundos. O si eres trbajador, recibe oportunidaes directamente en tu categoría',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white, // Color del texto
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ), // Espacio entre texto y botones
                    // Boton "Entendido"
                    Row(
                      children: [
                        Expanded(child: SizedBox()),
                        //Circulos entre pantallas
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              child: AnimatedContainer(
                                duration: Duration(
                                  milliseconds: 300,
                                ), // Duración de la animación
                                curve:
                                    Curves
                                        .easeInOut, // Efecto de animación suave
                                width: index == currentIndex ? 10 : 6,
                                height: index == currentIndex ? 10 : 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      index == currentIndex
                                          ? Colors.orange
                                          : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Botón "Entendido" a la derecha
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Transición de tipo slider al navegar a la siguiente pantalla
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => const Welcome3Screen(),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;

                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(CurveTween(curve: curve));
                                      var offsetAnimation = animation.drive(
                                        tween,
                                      );

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Colors.white, // Color del texto
                                padding:
                                    EdgeInsets
                                        .zero, // Elimina el padding adicional
                              ),
                              child: Text(
                                'Entendido',
                                style: TextStyle(
                                  decoration:
                                      isSiguientePressed
                                          ? TextDecoration
                                              .underline // Subrayado si está presionado
                                          : TextDecoration
                                              .none, // Sin subrayado por defecto
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
