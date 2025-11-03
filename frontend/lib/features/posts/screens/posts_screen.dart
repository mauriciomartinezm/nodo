import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/publicaciones_controller.dart';
import '../widgets/post_empty_state.dart';
import '../widgets/post_tabs.dart';
import '../widgets/post_list_view.dart';

class PublicacionesScreen extends StatefulWidget {
  const PublicacionesScreen({super.key});

  @override
  State<PublicacionesScreen> createState() => _PublicacionesScreenState();
}

class _PublicacionesScreenState extends State<PublicacionesScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar publicaciones cuando el widget se inicializa
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<PublicacionesController>(context, listen: false);
      controller.loadPublicaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PublicacionesController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mis Publicaciones',
          style: TextStyle(
              color: AppColors.blue,
              fontFamily: 'GothamMedium',
              fontSize: 14.sp),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: AppColors.blue,
              size: 24.r,
            ),
            onPressed: controller.loadPublicaciones,
          ),
        ],
      ),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(PublicacionesController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage.isNotEmpty && controller.publicaciones.isEmpty) {
      return Center(child: Text(controller.errorMessage));
    }

    if (!controller.hasPublications) {
      return PublicacionEmptyState.initial();
    }

    return Column(
      children: [
        PublicacionTabs(
          selectedIndex: controller.selectedIndex,
          onTabChanged: controller.setSelectedIndex,
        ),
        Expanded(
          child: PublicacionListView(
            filter: controller.selectedIndex,
          ),
        ),
      ],
    );
  }
}