import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'notificaciones_settings.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  _NotificacionesScreenState createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = [
      'Todo',
      'Solicitudes',
      'Reseñas',
      'Trabajos Completados'
    ];
    final List<Widget> tabViews = [
      NotificationListView(filter: 'Todo'),
      NotificationListView(filter: 'Solicitudes'),
      NotificationListView(filter: 'Reseñas'),
      NotificationListView(filter: 'Trabajos Completados'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notificaciones',
          style: TextStyle(
              color: AppColors.primaryColor,
              fontFamily: 'GothamMedium',
              fontSize: 14.sp),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined,
          color: AppColors.primaryColor, size: 24.r,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificacionesSettings()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16), // Igual que AppBar title
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
                          fontSize: 10.sp),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Vista asociada al tab seleccionado
          Expanded(
            child: tabViews[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

class NotificationListView extends StatelessWidget {
  final String filter;

  const NotificationListView({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    // Ahora usaremos título y descripción en lugar de solo un texto simple
    final Map<String, List<Map<String, String>>> notifications = {
      'Todo': [
        {
          'title': 'Ocupo arreglar una tubería de la tasa del baño',
          'description':
              'El día de ayer se rompió mientra le hacia un lavado, tengo una fuga que ocupo arreglar de manera urgente ya que es el único baño de la casa',
        },
        {
          'title': 'Cucarachas por el lavamanos',
          'description':
              'Ayer se rompió la tubería en mi casa y necesito ayuda urgente',
        },
        {
          'title': 'Ocupo arreglar una tubería',
          'description':
              'Ayer se rompió la tubería en mi casa y necesito ayuda urgente',
        },
        {
          'title': 'Ocupo arreglar una tubería',
          'description':
              'Ayer se rompió la tubería en mi casa y necesito ayuda urgente',
        },
        {
          'title': 'Ocupo arreglar una tubería',
          'description':
              'Ayer se rompió la tubería en mi casa y necesito ayuda urgente',
        },
        {
          'title': 'Ocupo arreglar una tubería',
          'description':
              'Ayer se rompió la tubería en mi casa y necesito ayuda urgente',
        },
        {
          'title': 'Ocupo arreglar una tubería',
          'description':
              'Ayer se rompió la tubería en mi casa y necesito ayuda urgente',
        },
        {
          'title': 'Consulta sobre presupuesto',
          'description': '¿Cuánto costaría reparar una fuga pequeña?',
        },
        {
          'title': 'Consulta sobre presupuesto',
          'description': '¿Cuánto costaría reparar una fuga pequeña?',
        },
        {
          'title': 'Consulta sobre presupuesto',
          'description': '¿Cuánto costaría reparar una fuga pequeña?',
        },
        {
          'title': 'Consulta sobre presupuesto',
          'description': '¿Cuánto costaría reparar una fuga pequeña?',
        },
        {
          'title': 'Consulta sobre presupuesto',
          'description': '¿Cuánto costaría reparar una fuga pequeña?',
        },
      ],
      'Solicitudes': [
        {
          'title': 'Solicitud de servicio',
          'description':
              'Necesito instalar un calentador de agua nuevo esta semana',
        },
      ],
      'Reseñas': [
        {
          'title': 'Nueva reseña recibida',
          'description':
              'Excelente trabajo realizado, muy satisfecho con el servicio',
        },
      ],
      'Trabajos Completados': [
        {
          'title': 'Trabajo finalizado',
          'description': 'Reparación de fuga completada con éxito',
        },
      ],
    };

    final List<Map<String, String>> items = notifications[filter] ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          //margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            //color: Colors.white, // opcional: para resaltar
            borderRadius: BorderRadius.circular(12),
            //boxShadow: [
            //  BoxShadow(
            //    color: Colors.black12,
            //    blurRadius: 4,
            //    offset: Offset(0, 2),
            //  ),
            //],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.notifications,
                    color: Colors.black54, size: 60),
              ),
              const SizedBox(width: 16), // De imagen con el texto
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${item['title']!}: ',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'GothamMedium',
                          fontSize: 10.sp,
                        ),
                      ),
                      TextSpan(
                        text: item['description']!,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontFamily: 'GothamBook',
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
