import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/notificaciones_settings.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../core/constants/api_constants.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  _NotificacionesScreenState createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  int _selectedIndex = 0;
  late Future<List<dynamic>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _fetchNotifications();
  }

  Future<List<dynamic>> _fetchNotifications() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/getNotificacionesByUserId/${userProvider.usuario?.id}'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<dynamic> _filterNotifications(
      List<dynamic> notifications, String filter) {
    switch (filter) {
      case 'Todo':
        return notifications;
      case 'Solicitudes':
        return notifications.where((n) => n['tipo'] == 'solicitud').toList();
      case 'Reseñas':
        return notifications.where((n) => n['tipo'] == 'reseña').toList();
      case 'Trabajos Completados':
        return notifications
            .where((n) => n['tipo'] == 'trabajo completado')
            .toList();
      default:
        return notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = [
      'Todo',
      'Solicitudes',
      'Reseñas',
      'Trabajos Completados'
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
            icon: Icon(
              Icons.settings_outlined,
              color: AppColors.primaryColor,
              size: 24.r,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificacionesSettings()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _notificationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return RefreshIndicator(
                    color: AppColors.primaryColor,
                    onRefresh: () async {
                      setState(() {
                        _notificationsFuture = _fetchNotifications();
                      });
                      await _notificationsFuture;
                    },
                    child: CustomScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'No hay notificaciones',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontFamily: 'GothamMedium',
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final filteredNotifications = _filterNotifications(
                  snapshot.data!,
                  tabs[_selectedIndex],
                );

                return RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                    setState(() {
                      _notificationsFuture = _fetchNotifications();
                    });
                    await _notificationsFuture;
                  },
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _NotificationItem(notification: notification);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final dynamic notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconForType(notification['tipo']),
              color: AppColors.primaryColor,
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['titulo'],
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'GothamMedium',
                    fontSize: 12.sp,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['mensaje'],
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: 'GothamBook',
                    fontSize: 10.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(notification['fecha']),
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'GothamBook',
                    fontSize: 8.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'solicitud':
        return Icons.assignment;
      case 'reseña':
        return Icons.star;
      case 'trabajo completado':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}