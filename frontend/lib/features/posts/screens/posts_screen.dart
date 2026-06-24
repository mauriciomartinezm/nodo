import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/publicaciones_controller.dart';
import '../widgets/post_empty_state.dart';
import '../widgets/post_tabs.dart';
import '../widgets/post_list_view.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar publicaciones cuando el widget se inicializa
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<PostsController>(context, listen: false);
      controller.loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PostsController>(context);

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
            onPressed: controller.loadPosts,
          ),
        ],
      ),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(PostsController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage.isNotEmpty && controller.posts.isEmpty) {
      return Center(child: Text(controller.errorMessage));
    }

    if (!controller.hasPublications) {
      return PostEmptyState.initial();
    }

    return Column(
      children: [
        PostTabs(
          selectedIndex: controller.selectedIndex,
          onTabChanged: controller.setSelectedIndex,
        ),
        Expanded(
          child: PostListView(
            filter: controller.selectedIndex,
          ),
        ),
      ],
    );
  }
}