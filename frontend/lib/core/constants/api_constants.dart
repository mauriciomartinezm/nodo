import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['API_BASE_URL']!;

  static String get login => "$baseUrl/loginUsuario";
  static String get createUsuario => "$baseUrl/createUsuario";
  static String updateUsuario(String id) => "$baseUrl/updateUsuario/$id";
  static String getUsuario(String id) => "$baseUrl/getUsuario/$id";
  static String get getTrabajadorByUserId =>
      "$baseUrl/getTrabajadorByUserId";

  static String get createPublicacion => "$baseUrl/createPublicacion";
  static String get getPublicaciones => "$baseUrl/getPublicaciones";
  static String get getPublicacionesByUserId =>
      "$baseUrl/getPublicacionesByUserId";
  static String updatePublicacion(String id) =>
      "$baseUrl/updatePublicacion/$id";
  static String deletePublicacion(String id) =>
      "$baseUrl/deletePublicacion/$id";

  static String get getCategorias => "$baseUrl/getCategorias";
  static String getCategoria(String id) => "$baseUrl/getCategoria/$id";
  static String get createUsuarioCategoria =>
      "$baseUrl/createUsuarioCategoria";

  static String get postularse => "$baseUrl/postularse";
  static String get finalizarTrabajo => "$baseUrl/finalizarTrabajo";
  static String getPostulacionesByPostId(String id) =>
      "$baseUrl/getPostulacionesByPostId/$id";
  static String getPostulacionesByUserId(String id) =>
      "$baseUrl/getPostulacionesByUserId/$id";
  static String updatePostulacion(String id) =>
      "$baseUrl/updatePostulacion/$id";
  static String deletePostulacion(String id) =>
      "$baseUrl/deletePostulacion/$id";

  static String getNotificacionesByUserId(String id) =>
      "$baseUrl/getNotificacionesByUserId/$id";
  static String get saveToken => "$baseUrl/saveToken";
  static String get deleteToken => "$baseUrl/deleteToken";

  static String get createReporte => "$baseUrl/createReporte";
}
