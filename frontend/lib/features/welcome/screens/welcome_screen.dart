import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nodo/features/login/screens/login_screen.dart';
import 'package:nodo/features/register/screens/register_screen.dart';
import 'package:nodo/features/welcome/widgets/welcome_slide.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const int _pageCount = 3;

  static const List<String> _imageAssets = [
    'assets/icons/img_screen_one1.webp',
    'assets/icons/img_screen_two1.webp',
    'assets/icons/img_buttom_one1.webp',
    'assets/icons/img_buttom_two1.webp',
    'assets/icons/iconNodoWhite.png',
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Construidas una sola vez: evita recrear los Image.asset de cada slide
  // (y volver a pedirlos) en cada cambio de página.
  late final List<Widget> _pages = [
    _buildSlide1(),
    _buildSlide2(),
    _buildSlide3(),
  ];

  @override
  void initState() {
    super.initState();
    // Precarga todas las imágenes una sola vez en el ImageCache global, que
    // vive fuera del árbol de widgets: así, aunque el PageView desmonte una
    // slide lejana y la reconstruya luego, no vuelve a pedir el asset.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final asset in _imageAssets) {
        precacheImage(AssetImage(asset), context);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _markWelcomeSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_welcome', true);
  }

  Future<void> _skipToLogin() async {
    await _markWelcomeSeen();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _goToRegister(String userType) async {
    await _markWelcomeSeen();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterScreen(initialUserType: userType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            // Mantiene montadas las páginas adyacentes para no volver a
            // resolver (y re-pedir) sus imágenes en cada cambio de slide.
            allowImplicitScrolling: true,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: _pages,
          ),
          // Capa fija: los botones y los puntos no se mueven al cambiar de slide.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildFooter(),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: _skipToLogin,
                  style: TextButton.styleFrom(
                    foregroundColor: _currentPage == 0
                        ? const Color.fromRGBO(6, 54, 102, 1.0)
                        : Colors.white,
                    overlayColor: Colors.transparent,
                  ),
                  child: const Text('Omitir'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final dots =
        WelcomeSlideDots(currentPage: _currentPage, pageCount: _pageCount);
    final isFirst = _currentPage == 0;
    final isLast = _currentPage == _pageCount - 1;

    return Row(
      children: [
        Expanded(
          child: isFirst
              ? const SizedBox()
              : Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _goToPreviousPage,
                    style: TextButton.styleFrom(
                      foregroundColor: isLast
                          ? const Color.fromRGBO(6, 54, 102, 1.0)
                          : Colors.white,
                      padding: EdgeInsets.zero,
                      overlayColor: Colors.transparent,
                    ),
                    // icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Atrás'),
                  ),
                ),
        ),
        dots,
        const SizedBox(width: 16),
        Expanded(
          child: isLast
              ? const SizedBox()
              : Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _goToNextPage,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      overlayColor: Colors.transparent,
                    ),
                    child: const Text('Siguiente'),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSlide1() {
    return WelcomeSlide(
      backgroundImage: 'assets/icons/img_screen_one1.webp',
      boxChild: Column(
        children: [
          // const SizedBox(height: 40),
          // const Text(
          //   'Bienvenido(a) a',
          //   style: TextStyle(fontSize: 18, color: Colors.white),
          // ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/iconNodoWhite.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 20),
              const Text(
                'NODO',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'La forma más rápida y sencilla de conectar con trabajadores y profesionales confiables para tus necesidades diarias.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          // Espacio reservado para el footer fijo (Omitir/Siguiente/puntos).
          const SizedBox(height: 56),
        ],
      ),
    );
  }

  Widget _buildSlide2() {
    return WelcomeSlide(
      backgroundImage: 'assets/icons/img_screen_two1.webp',
      boxChild: Column(
        children: [
          const SizedBox(height: 110),
          const Text(
            'Publica una solicitud y recibe ofertas de trabajadores calificados em segundos. O si eres trbajador, recibe oportunidaes directamente en tu rubro',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          // Espacio reservado para el footer fijo (Omitir/Siguiente/puntos).
          const SizedBox(height: 116),
        ],
      ),
    );
  }

  Widget _buildSlide3() {
    return WelcomeSlide(
      boxAtTop: true,
      boxChild: const Column(
        children: [
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
                  text: ' ¿Buscas un servicio o quieres ofrecer tu talento?',
                ),
              ],
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      belowBoxChild: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _RoleCard(
                      label: 'Buscar\nservicios',
                      image: 'assets/icons/img_buttom_one1.webp',
                      onTap: () => _goToRegister('cliente'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _RoleCard(
                      label: 'Trabajar y\nencontrar clientes',
                      image: 'assets/icons/img_buttom_two1.webp',
                      onTap: () => _goToRegister('trabajador'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _skipToLogin,
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromRGBO(6, 54, 102, 1.0),
                overlayColor: Colors.transparent,
              ),
              child: const Text('Ya tengo una cuenta'),
            ),
            // Espacio reservado para el footer fijo (puntos).
            const SizedBox(height: 56),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String label;
  final String image;
  final VoidCallback onTap;

  const _RoleCard({
    required this.label,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(image, fit: BoxFit.cover),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: const Color.fromRGBO(6, 54, 102, 0.92),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 8,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
