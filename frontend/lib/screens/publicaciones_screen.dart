import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/usuario_provider.dart';
import '../constants/api_constants.dart';

class PublicacionesScreen extends StatefulWidget {
  const PublicacionesScreen({super.key});

  @override
  _PublicacionesScreenState createState() => _PublicacionesScreenState();
}

class _PublicacionesScreenState extends State<PublicacionesScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  List<dynamic> _publicaciones = [];
  String _errorMessage = '';

  late UsuarioProvider usuarioProvider;

  @override
  void initState() {
    super.initState();
    _loadPublicaciones();
  }

  Future<void> _loadPublicaciones() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
      final clienteId = usuarioProvider.cliente!.id;

      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/getPublicacionesByUserId/$clienteId'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData is List) {
          setState(() {
            _publicaciones = responseData;
            _isLoading = false;
          });
        } else if (responseData is Map &&
            responseData['message'] == 'No existen registros') {
          setState(() {
            _publicaciones = [];
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Formato de respuesta inesperado';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'Error al cargar las publicaciones (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión: $e';
        _isLoading = false;
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Filtra las publicaciones según su estado
  List<dynamic> _filtrarPublicaciones(String estado) {
    return _publicaciones
        .where((pub) => pub['estado'] == estado.toLowerCase())
        .toList();
  }

  bool hayAlMenosUnaPublicacion() {
    return _publicaciones.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ['Activas', 'En Proceso', 'Finalizadas'];

    // Mapeo de estados para el filtro
    final estadoMap = {
      'Activas': 'pendiente',
      'En Proceso': 'en_proceso',
      'Finalizadas': 'finalizada'
    };

    final List<Widget> tabViews = tabs.map((tab) {
      final estado = estadoMap[tab]!;
      return PublicacionListView(
        filter: tab,
        items: _filtrarPublicaciones(estado),
        onDelete: (item) {
          _confirmarEliminar(context, item, tab);
        },
        confirmarEliminar: (item) {
          _confirmarEliminar(context, item, tab);
        },
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
              Icons.refresh,
              color: AppColors.primaryColor,
              size: 24.r,
            ),
            onPressed: _loadPublicaciones,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty && _publicaciones.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _publicaciones.isEmpty
                  ? _mensajeCentradoSpan(obtenerMensajeInicial())
                  : Column(
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 9.r, horizontal: 8.r),
                                    margin: EdgeInsets.only(right: 5.w),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primaryColor
                                          : AppColors.primaryColor
                                              .withOpacity(0.2),
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
                          child: PublicacionListView(
                            filter: tabs[_selectedIndex],
                            items: _filtrarPublicaciones(
                                estadoMap[tabs[_selectedIndex]]!),
                            onDelete: (item) => _confirmarEliminar(
                                context, item, tabs[_selectedIndex]),
                            confirmarEliminar: (item) => _confirmarEliminar(
                                context, item, tabs[_selectedIndex]),
                          ),
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

  void _confirmarEliminar(
      BuildContext context, dynamic item, String tab) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Estás seguro?'),
          content: const Text('Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final response = await http.delete(
                    Uri.parse(
                        '${ApiConstants.baseUrl}/deletePublicacion/${item['id']}'),
                  );

                  if (response.statusCode == 200) {
                    Navigator.of(context).pop(true);
                  } else {
                    Navigator.of(context).pop(false);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Error al eliminar la publicación')),
                      );
                    }
                  }
                } catch (e) {
                  Navigator.of(context).pop(false);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error de conexión: $e')),
                    );
                  }
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicación eliminada')),
        );
        // Forzar un rebuild inmediato mostrando mensaje inicial
        setState(() {
          _publicaciones = [];
          _errorMessage = '';
        });
        // Luego cargar las publicaciones actualizadas
        await _loadPublicaciones();
        Navigator.of(context).pop(); // Cierra el modal
      }
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
}

class PublicacionListView extends StatelessWidget {
  final Function(dynamic) confirmarEliminar;
  final String filter;
  final List<dynamic> items;
  final Function(dynamic) onDelete;
  const PublicacionListView({
    super.key,
    required this.filter,
    required this.items,
    required this.onDelete,
    required this.confirmarEliminar,
  });

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
        children: items.map((item) {
          return GestureDetector(
              onTap: () => mostrarDetallePublicacion(context, item),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
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
                    item['titulo'] ?? 'Sin título',
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
                    _formatDate(item['fecha_publicacion']),
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: 'GothamBook',
                      fontSize: 10.sp,
                    ),
                  ),
                  /*Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 18.r, color: AppColors.primaryColor),
                      SizedBox(width: 4.w),
                      Text(
                        item['ubicacion'] ?? 'Sin ubicación',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'GothamBook',
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),*/
                ],
              ));
        }).toList(),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void mostrarDetallePublicacion(BuildContext context, dynamic publicacion) {
    int _currentIndex = 0;
    final List<String> imageList = [
      'assets/images/diomedes_joven.jpg',
      'assets/images/diomedes_joven.jpg',
      'assets/images/diomedes_joven.jpg',
    ];
    print("Mostrar detalle publicacion");
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.secondaryColor,
      useRootNavigator: true,
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
                          publicacion['titulo'] ?? 'Sin título',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontFamily: 'GothamMedium',
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        _detalleInfo(publicacion['descripcion_necesidad'] ??
                            'Sin descripción'),
                        SizedBox(height: 8.h),
                        _detalleInfo(
                            'Publicado: ${_formatDate(publicacion['fecha_publicacion'])}'),
                        _detalleInfo(
                            'Ubicación: ${publicacion['ubicacion'] ?? 'Sin ubicación'}'),
                        _detalleInfo(
                            'Presupuesto: \$${publicacion['presupuesto']?.toString() ?? '0'}'),
                        Row(children: [
                          _detalleInfo('Estado: '),
                          _detalleInfo(_translateStatus(publicacion['estado'])),
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
                            ElevatedButton.icon(
                              onPressed: () async {
                                final result =
                                    await confirmarEliminar(publicacion);
                                if (result == true && context.mounted) {
                                  Navigator.of(context)
                                      .pop(); // Cierra el modal
                                }
                              },
                              icon: Icon(Icons.delete,
                                  size: 16.sp, color: AppColors.primaryColor),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.primaryColor.withOpacity(0.2),
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.h, horizontal: 12.w),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5))),
                              ),
                              label: Text(
                                'Eliminar publicación',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 10.sp,
                                  fontFamily: 'GothamMedium',
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
            );
          },
        );
      },
    );
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'pendiente':
        return 'Activa';
      case 'en_proceso':
        return 'En Proceso';
      case 'finalizada':
        return 'Finalizada';
      default:
        return status;
    }
  }

  Widget _detalleInfo(String texto) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            texto,
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
}
