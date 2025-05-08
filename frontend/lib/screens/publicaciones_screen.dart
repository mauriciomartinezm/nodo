import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PublicacionesScreen extends StatefulWidget {
  const PublicacionesScreen({super.key});

  @override
  _PublicacionesScreenState createState() => _PublicacionesScreenState();
}

class _PublicacionesScreenState extends State<PublicacionesScreen> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Datos simulados para las publicaciones
  final Map<String, List<Map<String, String>>> publicaciones = {
    'Activas': [],
    'En Proceso': [],
    'Finalizadas': [
      {
        'title': 'Arreglo de tubería',
        'description': 'Necesito reparar una tubería rota lo antes posible.',
        'date': '08/05/2025',
        'participants': '2',
      },
    ],
  };

  bool hayAlMenosUnaPublicacion() {
    return publicaciones.values.any((lista) => lista.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ['Activas', 'En Proceso', 'Finalizadas'];

    final List<Widget> tabViews = tabs.map((tab) {
      return PublicacionListView(
        filter: tab,
        items: publicaciones[tab] ?? [],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mis Publicaciones',
          style: TextStyle(
              color: AppColors.primaryColor,
              fontFamily: 'GothamMedium',
              fontSize: 14.sp),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: AppColors.primaryColor,
              size: 24.r,
            ),
            onPressed: () {
              // Acción de configuración
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Solo mostramos las tabs si hay al menos una publicación
          if (hayAlMenosUnaPublicacion())
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(tabs.length, (index) {
                  final bool isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () => _onTabTapped(index),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 9.r, horizontal: 8.r),
                      margin: EdgeInsets.only(right: 5.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.primaryColor,
                          fontFamily: 'GothamMedium',
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          Expanded(
            child: hayAlMenosUnaPublicacion()
                ? tabViews[_selectedIndex]
                : _mensajeCentradoSpan(obtenerMensajeInicial()),
          )
        ],
      ),
    );
  }

  TextSpan obtenerMensajeInicial() {
    return TextSpan(
      children: [
        TextSpan(
          text: 'Aquí verás tus publicaciones\n\n',
          style: TextStyle(
            color: AppColors.accentColor.withOpacity(0.6),
            fontFamily: 'GothamMedium',
            fontSize: 18.sp,
          ),
        ),
        TextSpan(
          text:
              'Cuando publiques una solicitud de servicio, aparecerá aquí para que hagas el seguimiento',
          style: TextStyle(
            color: AppColors.primaryColor.withOpacity(0.6),
            fontFamily: 'GothamBook',
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }
}

Widget _mensajeCentradoSpan(TextSpan mensaje) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: RichText(
        textAlign: TextAlign.center,
        text: mensaje,
      ),
    ),
  );
}

class PublicacionListView extends StatelessWidget {
  final String filter;
  final List<Map<String, String>> items;

  const PublicacionListView(
      {super.key, required this.filter, required this.items});

  TextSpan obtenerMensajeVacio() {
    if (filter == 'Activas') {
      return TextSpan(
        children: [
          TextSpan(
            text: 'Tus publicaciones activas\n\n',
            style: TextStyle(
              color: AppColors.accentColor.withOpacity(0.6),
              fontFamily: 'GothamMedium',
              fontSize: 18.sp,
            ),
          ),
          TextSpan(
            text:
                'Aquí se mostrarán las solicitudes de servicio que hayas publicado y aún no tengan un trabajador asignado',
            style: TextStyle(
              color: AppColors.primaryColor.withOpacity(0.6),
              fontFamily: 'GothamBook',
              fontSize: 15.sp,
            ),
          ),
        ],
      );
    }
    if (filter == 'En Proceso') {
      return TextSpan(
        children: [
          TextSpan(
            text: 'Tus publicaciones en proceso\n\n',
            style: TextStyle(
              color: AppColors.accentColor.withOpacity(0.6),
              fontFamily: 'GothamMedium',
              fontSize: 18.sp,
            ),
          ),
          TextSpan(
            text:
                'Aquí aparecerán las solicitudes en las que hayas asignado un trabajador a una solicitud de servicio',
            style: TextStyle(
              color: AppColors.primaryColor.withOpacity(0.6),
              fontFamily: 'GothamBook',
              fontSize: 15.sp,
            ),
          ),
        ],
      );
    }
    if (filter == 'Finalizadas') {
      return TextSpan(
        children: [
          TextSpan(
            text: 'Tus publicaciones finalizadas\n\n',
            style: TextStyle(
              color: AppColors.accentColor.withOpacity(0.6),
              fontFamily: 'GothamMedium',
              fontSize: 18.sp,
            ),
          ),
          TextSpan(
            text:
                'Aquí aparecerán las solicitudes de servicio que han sido completadas',
            style: TextStyle(
              color: AppColors.primaryColor.withOpacity(0.6),
              fontFamily: 'GothamBook',
              fontSize: 15.sp,
            ),
          ),
        ],
      );
    }

    // En caso que no coincida con ninguno (no debería pasar)
    return const TextSpan(text: '');
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: RichText(
            textAlign: TextAlign.center,
            text: obtenerMensajeVacio(),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
        children: items.map((item) {
          return Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160.r,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.work_outline,
                      color: AppColors.primaryColor, size: 40.r),
                ),
                SizedBox(height: 8.h),
                Text(
                  item['title']!,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'GothamMedium',
                    fontSize: 10.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Fecha: ${item['date']}',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'GothamBook',
                    fontSize: 9.sp,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 16, color: AppColors.primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      item['participants']!,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: 'GothamBook',
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
