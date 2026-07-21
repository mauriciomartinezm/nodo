import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/posts_controller.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<PostsController>(context, listen: false);
      controller.loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PostsController>(context);

    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(PostsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(controller),
        Expanded(child: _buildContent(controller)),
      ],
    );
  }

  Widget _buildHeader(PostsController controller) {
    final total = controller.posts.length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, MediaQuery.of(context).padding.top + 16.h, 16.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mis Publicaciones',
                  style: AppTypography.title.copyWith(color: AppColors.white),
                ),
                SizedBox(height: 4.h),
                Text(
                  total == 0
                      ? 'Aún no tienes publicaciones'
                      : total == 1
                          ? '1 publicación en total'
                          : '$total publicaciones en total',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: controller.isLoading
                ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: const CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(Icons.refresh_rounded, color: AppColors.white, size: 22.r),
            onPressed: controller.isLoading ? null : controller.loadPosts,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(PostsController controller) {
    if (controller.isLoading && controller.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage.isNotEmpty && controller.posts.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_outlined,
                  size: 48.r, color: AppColors.slateGrey),
              SizedBox(height: 12.h),
              Text(
                controller.errorMessage,
                style:
                    AppTypography.body.copyWith(color: AppColors.slateGrey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (!controller.hasPublications) {
      return PostEmptyState.initial();
    }

    return Column(
      children: [
        PostTabs(
          selectedIndex: controller.selectedIndex,
          onTabChanged: controller.setSelectedIndex,
          counts: [
            controller.countByStatus('pending'),
            controller.countByStatus('in_progress'),
            controller.countByStatus('finished'),
          ],
        ),
        Expanded(
          child: PostListView(filter: controller.selectedIndex),
        ),
      ],
    );
  }
}
