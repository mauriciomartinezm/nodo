import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/userprovider.dart';
import 'package:provider/provider.dart';

class HeaderInfoWidget extends StatelessWidget {
  const HeaderInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final nombre = userProvider.usuario?.nombres ?? '';
    final profesion = userProvider.usuario?.categoria ?? '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: const AssetImage('assets/images/diomedes_joven.jpg'),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: "GothamMedium",
                      fontSize: 14.r,
                    ),
                  ),
                  if (profesion.isNotEmpty)
                    Text(
                      profesion,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14.r,
                        fontFamily: "GothamBook",
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            "Publica tu solicitud y encuentra al profesional ideal",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontFamily: "GothamMedium",
              fontSize: 17.r,
            ),
          ),
          Text(
            "Describe lo que necesitas y deja que los mejores trabajadores te contacten",
            style: TextStyle(
              color: AppColors.accentColor,
              fontFamily: "GothamBook",
              fontSize: 14.r,
            ),
          ),
        ],
      ),
    );
  }
}