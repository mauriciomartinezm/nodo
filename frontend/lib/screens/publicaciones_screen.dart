import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
    'Activas': [
      {
        'title': 'Arreglo de tubería',
        'description': 'Necesito reparar una tubería rota lo antes posible.',
        'start_date': 'Publicado hace 2 dias',
        'location': 'Apartadó',
        'price': 'Arreglo de tubería',
        'date': '08/05/2025',
        'end_date': 'Necesario para antes del viernes',
        'participants': '2',
        'status': 'Active',
      },
      {
        'title': 'Arreglo de tubería',
        'description': 'Necesito reparar una tubería rota lo antes posible.',
        'start_date': 'Publicado hace 2 dias',
        'location': 'Apartadó',
        'price': 'Arreglo de tubería',
        'date': '08/05/2025',
        'end_date': 'Necesario para antes del viernes',
        'participants': '2',
        'status': 'Active',
      },
      {
        'title': 'Arreglo de tubería',
        'description': 'Necesito reparar una tubería rota lo antes posible.',
        'start_date': 'Publicado hace 2 dias',
        'location': 'Apartadó',
        'price': 'Arreglo de tubería',
        'date': '08/05/2025',
        'end_date': 'Necesario para antes del viernes',
        'participants': '2',
        'status': 'Active',
      },
    ],
    'En Proceso': [
      {
        'title': 'Arreglo de tubería',
        'description': 'Necesito reparar una tubería rota lo antes posible.',
        'start_date': 'Publicado hace 2 dias',
        'ubication': 'Apartadó',
        'price': 'Arreglo de tubería',
        'date': '08/05/2025',
        'end_date': 'Necesario para antes del viernes',
        'participants': '2',
        'status': 'Active',
      },
    ],
    'Finalizadas': [],
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
          padding: EdgeInsets.symmetric(horizontal: 32.r),
          child: RichText(
            textAlign: TextAlign.center,
            text: obtenerMensajeVacio(),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 20.w,
        mainAxisSpacing: 10.h,
        //childAspectRatio: 0.85,
        children: items.map((item) {
          return GestureDetector(
              onTap: () => mostrarDetallePublicacion(context, item),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    //padding: EdgeInsets.all( 16.r), // Espacio interno para que no quede pegado
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.work_outline,
                      color: AppColors.primaryColor,
                      size: 100.sp,
                    ),
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
                  SizedBox(height: 4.h),
                  Text(
                    item['date']!,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'GothamBook',
                      fontSize: 10.sp,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          size: 18.r, color: AppColors.primaryColor),
                      SizedBox(width: 4.w),
                      Text(
                        item['participants']!,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'GothamBook',
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ));
        }).toList(),
      ),
    );
  }
}

void mostrarDetallePublicacion(
    BuildContext context, Map<String, String> publicacion) {
  int _currentIndex = 0; // Guardamos la posición actual
  final List<String> imageList = [
    'assets/images/demo1.jpg',
    'assets/images/demo2.jpg',
    'assets/images/demo3.jpg',
  ];
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.secondaryColor,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                CarouselSlider(
                  items: imageList.map((imagePath) {
                    return Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 150.h,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imageList.asMap().entries.map((entry) {
                    return Container(
                      width: 8.w,
                      height: 8.w,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        //border: Border.all(
                        //  color: AppColors.secondaryColor,
                        //),
                        shape: BoxShape.circle,
                        color: _currentIndex == entry.key
                            ? AppColors.accentColor
                            : AppColors.primaryColor,
                      ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        publicacion['title'] ?? '',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'GothamMedium',
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _detalleInfo(publicacion['description'] ?? ''),
                      SizedBox(height: 8.h),
                      _detalleInfo(publicacion['start_date'] ?? ''),
                      _detalleInfo(publicacion['location'] ?? ''),
                      _detalleInfo(publicacion['end_date'] ?? ''),
                      _detalleInfo(publicacion['price'] ?? ''),
                      Row(children: [
                        _detalleInfo('Postulaciones: '),
                        _detalleInfo(publicacion['participants'] ?? ''),
                      ]),
                      Row(children: [
                        _detalleInfo('Estado: '),
                        _detalleInfo(publicacion['status'] ?? ''),
                      ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _botonAccion(
                              Icons.edit,
                              'Editar',
                              AppColors.secondaryColor,
                              AppColors.primaryColor, () {
                            // Acción editar
                          }),
                          _botonAccion(
                              Icons.check_circle_outline,
                              'Completado',
                              AppColors.primaryColor,
                              AppColors.primaryColor.withOpacity(0.2), () {
                            // Acción completado
                          }),
                          _botonAccion(
                              Icons.delete_outline,
                              'Eliminar',
                              AppColors.primaryColor,
                              AppColors.primaryColor.withOpacity(0.2), () {
                            // Acción eliminar
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _detalleInfo(String texto) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      children: [
        Text(
          '$texto ',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontFamily: 'GothamBook',
            fontSize: 12.sp,
          ),
        ),
      ],
    ),
  );
}

Widget _botonAccion(IconData icono, String texto, Color color_texto,
    Color color_fondo, VoidCallback onTap) {
  return ElevatedButton.icon(
    onPressed: onTap,
    icon: Icon(icono, size: 16.sp, color: color_texto),
    label: Text(
      texto,
      style: TextStyle(
        color: color_texto,
        fontSize: 10.sp,
        fontFamily: 'GothamMedium',
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: color_fondo,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5))),
    ),
  );
}
