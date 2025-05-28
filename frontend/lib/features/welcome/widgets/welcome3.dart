import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodo/providers/userprovider.dart';
import 'package:nodo/features/register/widgets/registerclient1.dart';

class Welcome3Screen extends StatelessWidget {
  const Welcome3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    int currentIndex = 2;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(6, 54, 102, 1.0),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(100),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                SizedBox(height: 60),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'Dinos cómo quieres empezar en ',
                    children: [
                      TextSpan(
                        text: 'NODO',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            ' ¿Buscas un servicio o quieres ofrecer tu talento?',
                      ),
                    ],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 40),

          const Text(
            'Buscar servicios',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 220,
            width: 300,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              onPressed: () {
                // Establece isWorker en false
                Provider.of<UserProvider>(context, listen: false)
                    .setIsWorker(false);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterClient1(),
                  ),
                );
              },
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/icons/img_buttom_one.png',
                  height: 204,
                  width: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Trabajar y encontrar clientes',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 220,
            width: 300,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              onPressed: () {
                // Establece isWorker en true
                Provider.of<UserProvider>(context, listen: false)
                    .setIsWorker(true);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterClient1(),
                  ),
                );
              },
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/icons/img_buttom_two.png',
                  height: 204,
                  width: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Spacer(),

          // Indicadores
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: index == currentIndex ? 10 : 6,
                  height: index == currentIndex ? 10 : 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == currentIndex
                        ? Colors.orange
                        : Colors.black54,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
