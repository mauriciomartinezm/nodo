// welcome1.dart
import 'package:flutter/material.dart';
import 'welcome2.dart'; // Importa la segunda pantalla de bienvenida

class Welcome1Screen extends StatefulWidget {
  const Welcome1Screen({super.key});

  @override
  State<Welcome1Screen> createState() => _Welcome1ScreenState();
}

class _Welcome1ScreenState extends State<Welcome1Screen> {
  bool isOmitirPressed = false; // Estado para el botón "Omitir"
  bool isSiguientePressed = false; // Estado para el botón "Siguiente"

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/icons/img_screen_one.png', // Ruta de la imagen
              fit: BoxFit.cover, // Ajuste para que cubra toda la pantalla
            ),
          ),

          Column(
            children: [
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
                    const SizedBox(height: 40),
                    // Texto "Bienvenido(a) a"
                    const Text(
                      'Bienvenido(a) a',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 40), // Espacio entre textos
                    // Texto "NODO"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/iconNodoWhite.png', // Ruta de la imagen en assets
                          width: 40, // Ajusta el tamaño según necesites
                          height: 40,
                        ),

                        const SizedBox(width: 20),

                        const Text(
                          'NODO',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white, // Color destacado
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                    // Descripción
                    const Text(
                      'La forma más rápida y sencilla de conectar con trabajadores y profesionales confiables para tus necesidades diarias.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white, // Color del texto
                      ),
                    ),
                    const SizedBox(height: 40), // Espacio entre texto y botones
                    // Botones "Omitir" y "Siguiente"
                    Row(
                      children: [
                        // Botón "Omitir" a la izquierda
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                isOmitirPressed = true; // Subrayar al presionar
                                isSiguientePressed =
                                    false; // Quitar subrayado del otro botón
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white, // Color del texto
                              padding:
                                  EdgeInsets
                                      .zero, // Elimina el padding adicional
                            ),
                            child: Text(
                              'Omitir',
                              style: TextStyle(
                                decoration:
                                    isOmitirPressed
                                        ? TextDecoration
                                            .underline // Subrayado si está presionado
                                        : TextDecoration
                                            .none, // Sin subrayado por defecto
                              ),
                            ),
                          ),
                        ),

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

                        const SizedBox(width: 16), // Espacio entre botones
                        // Botón "Siguiente" a la derecha
                        Expanded(
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
                                      ) => const Welcome2Screen(),
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
                              foregroundColor: Colors.white, // Color del texto
                              padding:
                                  EdgeInsets
                                      .zero, // Elimina el padding adicional
                            ),
                            child: Text(
                              'Siguiente',
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
