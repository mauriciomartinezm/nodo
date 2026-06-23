class ApiConstants {
  static const String baseUrl = "http://localhost:3001/api"; //descomenta esto y cambia la ip por localhost si la api la abriste localmente
  //static const String baseUrl = "https://nodo-api-d39cbf97ce57.herokuapp.com/api"; //ruta para api en la nube en railway
  static const String loginEndpoint = "$baseUrl/loginUsuario";
  static String updateUsuarioEndpoint(String id) =>
      "$baseUrl/updateUsuario/$id";
  static String getUser(String id) => "$baseUrl/getUsuario/$id"; // ← NUEVO
  static String getClienteById(String id) =>
      "$baseUrl/getUsuario/$id"; // ← NUEVO
  static const String createUsuarioEndpoint = "$baseUrl/createUsuario";
  static const String getTrabajadorByUerId = "$baseUrl/getTrabajadorByUserId";

  static String deletePublicacionEndpoint(String id) =>
      "$baseUrl/deletePublicacion/$id";
      static String updatePublicacionEndpoint(String id) =>
      "$baseUrl/updatePublicacion/$id";
  static const String createPublicacionEndpoint = "$baseUrl/createPublicacion";
  static const String getPublicacionesByUserId =
      "$baseUrl/getPublicacionesByUserId";
  static const String getPublicacionesEndpoint =
      "$baseUrl/getPublicaciones"; // ← NUEVO

  static String getCategoriaEndpoint(String id) =>
      "$baseUrl/getCategoria/$id"; // ← NUEVO
  static const String getCategoriasEndpoint = "$baseUrl/getCategorias";

  static const String postularse = "$baseUrl/postularse"; // ← NUEVO
  static const String finalizarTrabajo = "$baseUrl/finalizarTrabajo"; // ← NUEVO
  static const String createUsuarioCategoriaEndpoint = "$baseUrl/createUsuarioCategoria"; // ← NUEVO
  static String getPostulacionesByPostId(String id) =>
      "$baseUrl/getPostulacionesByPostId/$id"; // ← NUEVO
  static String getPostulacionesByUserId(String id) =>
      "$baseUrl/getPostulacionesByUserId/$id"; // ← NUEVO
  static String updatePostulacionEndpoint(String id) =>
      "$baseUrl/updatePostulacion/$id";
  static String deletePostulacionEndpoint(String id) =>
      "$baseUrl/deletePostulacion/$id";
  static String getNotificacionesByUserId(String id) =>
      "$baseUrl/getNotificacionesByUserId/$id"; // ← NUEVO
  static const String saveToken = "$baseUrl/saveToken"; // ← NUEVO
  static const String deleteToken = "$baseUrl/deleteToken"; // ← NUEVO

  static const String createReporte = "$baseUrl/createReporte"; // ← NUEVO
}
