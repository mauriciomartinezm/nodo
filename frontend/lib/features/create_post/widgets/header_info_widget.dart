import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/user_provider.dart';
import 'package:nodo/core/theme/app_theme.dart';

class HeaderInfoWidget extends StatefulWidget {
  const HeaderInfoWidget({super.key});

  @override
  State<HeaderInfoWidget> createState() => _HeaderInfoWidgetState();
}

class _HeaderInfoWidgetState extends State<HeaderInfoWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final nombre =
        '${userProvider.user?.nombres ?? ''} ${userProvider.user?.primerApellido ?? ''}'
            .trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.r),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$nombre,',
                style: AppTypography.subtitle.copyWith(color: AppColors.blue),
              ),
              // if (_loadingCategoria)
              //   SizedBox(
              //     width: 20.r,
              //     height: 20.r,
              //     child: CircularProgressIndicator(
              //       strokeWidth: 2.r,
              //       color: AppColors.blue,
              //     ),
              //   )
              // else if (_profesion.isNotEmpty)
              // Text(
              //   _profesion,
              //   style: AppTypography.label.copyWith(
              //     color: AppColors.blue,
              //     fontWeight: FontWeight.w100,
              //   ),
              // ),
              Text(
                "describe lo que necesitas y deja que los mejores trabajadores te contacten",
                style: AppTypography.label.copyWith(color: AppColors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
