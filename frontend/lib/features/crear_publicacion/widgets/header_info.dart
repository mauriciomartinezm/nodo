import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../core/theme/app_colors.dart';
import '../../../providers/userprovider.dart';
import '../../../core/constants/api_constants.dart';

class HeaderInfoWidget extends StatefulWidget {
  const HeaderInfoWidget({super.key});

  @override
  State<HeaderInfoWidget> createState() => _HeaderInfoWidgetState();
}

class _HeaderInfoWidgetState extends State<HeaderInfoWidget> {
  String _profesion = '';
  bool _loadingCategoria = false;

  @override
  void initState() {
    super.initState();
    _loadCategoria();
  }

  Future<void> _loadCategoria() async {
    final userProvider = context.read<UserProvider>();
    final idCategoria = userProvider.usuario?.idCategoria;

    if (idCategoria == null || idCategoria.isEmpty) {
      return;
    }

    setState(() => _loadingCategoria = true);

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getCategoriaEndpoint(idCategoria)),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _profesion = data['nombre_cat'] ?? '');
      } else {
        setState(() => _profesion = 'Profesional');
      }
    } catch (e) {
      setState(() => _profesion = 'Profesional');
      debugPrint('Error cargando categoría: $e');
    } finally {
      setState(() => _loadingCategoria = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final nombre = '${userProvider.usuario?.nombres ?? ''} ${userProvider.usuario?.primerApellido ?? ''}'.trim();
    final fotoPerfil = userProvider.usuario?.fotoPerfil;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: fotoPerfil != null && fotoPerfil.isNotEmpty
                    ? NetworkImage(fotoPerfil) as ImageProvider
                    : const AssetImage('assets/images/default_profile.jpg'),
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
                  if (_loadingCategoria)
                    SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.r,
                        color: AppColors.primaryColor,
                      ),
                    )
                  else if (_profesion.isNotEmpty)
                    Text(
                      _profesion,
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