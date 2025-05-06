import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/widgets/subir_foto_widget.dart';

class CrearPublicacion extends StatelessWidget {
  const CrearPublicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            //height: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              margin: EdgeInsets.all(15.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        clipBehavior:
                            Clip.antiAlias, // Esto recorta el contenido
                        child: Image.asset(
                          'assets/images/diomedes_joven.jpg',
                          height: 60.r,
                          width: 60.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Diomedes Diaz",
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontFamily: "GothamMedium",
                                  fontSize: 14.r)),
                          Text(
                            "Periquero",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontFamily: "GothamBook",
                                fontSize: 14.r),
                          )
                        ],
                      )
                    ],
                  ),
                  AutoSizeText(
                      "Publica tu solicitud y encuentra al profesional ideal",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontFamily: "GothamMedium",
                        fontSize: 17.r,
                      ),
                      maxLines: 3, //
                      minFontSize: 5,
                      maxFontSize: 22),
                  AutoSizeText(
                      "Describe lo que necesitas y deja que los mejores trabajadores te contacten",
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontFamily: "GothamBook",
                        fontSize: 14.r,
                      ),
                      maxLines: 3, //
                      minFontSize: 5,
                      maxFontSize: 22),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 25.w, right: 25.w),
            child: Column(
              children: [
                buildCustomTextField(
                    "Título (Ejemplo: reparación de tubería)", context),
                SizedBox(height: 10.h),
                buildCustomTextField(
                    "Categoría (Selecciona la categoría del servicio)",
                    context),
                SizedBox(height: 10.h),
                buildCustomTextField("Ubicación", context),
                SizedBox(height: 10.h),
                buildCustomTextField(
                    "Presupuesto: (Define cuánto estás dispuesto a pagar)",
                    context),
                SizedBox(height: 10.h),
                buildCustomTextField(
                    "Fecha límite: (¿Cuándo necesitas que se realice el trabajo?)",
                    context),
                SizedBox(height: 10.h),
                TextField(
                  maxLines:
                      3, // Esto hace que el campo sea "grande" como para una descripción
                  decoration: InputDecoration(
                    labelText:
                        'Descripción: (Explica los detalles de tu solicitud)',
                    alignLabelWithHint:
                        true, // Alinea el label arriba dentro del cuadro
                    labelStyle: TextStyle(
                      fontSize: 12.r,
                      color: AppColors.aux,
                      fontFamily: "GothamBook",
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 2.r, color: AppColors.aux),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 2.r, color: AppColors.aux),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                SubirFotoWidget(),
                Text(
                  "Publica ahora y recibe ofertas en minutos. ¡Es rápido y fácil!",
                  style: TextStyle(
                      color: AppColors.aux,
                      fontFamily: "GothamBook",
                      fontSize: 9.sp),
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
                  //heightFactor: 0.1,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      minimumSize:
                          Size(50, MediaQuery.of(context).size.height * 0.06),
                    ),
                    child: Center(
                      child: Text(
                        "Publicar",
                        style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontFamily: "GothamMedium",
                            fontSize: 10.sp),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget buildCustomTextField(String label, BuildContext context) {
  return SizedBox(
    height: 30.h, 
    child: TextField(
      style: TextStyle(
        fontSize: 9.sp, // Tamaño del texto que escribe el usuario (responsive)
        color: Colors.black, // Color del texto
        fontFamily: "GothamBook", 
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            fontSize: 9.sp, color: AppColors.aux, fontFamily: "GothamBook"),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2.r, color: AppColors.aux),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2.r, color: AppColors.aux),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 12.w,
        ),
      ),
    ),
  );
}

}
