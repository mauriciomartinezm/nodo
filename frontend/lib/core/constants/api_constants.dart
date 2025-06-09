class ApiConstants {
  static const String baseUrl = "http://192.168.1.7:3001/api"; //descomenta esto y cambia la ip por localhost si la api la abriste localmente
  // static const String baseUrl = "https://nodo-unv8.onrender.com/api"; //ruta para api en la nube en render

  static const String createPublicacionEndpoint = "$baseUrl/createPublicacion";
  static const String loginEndpoint = "$baseUrl/loginUsuario";
  static const String getTrabajadorByUserId = "$baseUrl/getTrabajadorByUserId";
  static const String getCategoriasEndpoint = "$baseUrl/getCategorias";
  static const String getPublicacionesByUserId = "$baseUrl/getPublicacionesByUserId";
  static const String createUsuarioEndpoint = "$baseUrl/createUsuario";
  static const String getPublicacionesEndpoint = "$baseUrl/getPublicaciones"; // ← NUEVO
  static String getClienteById(String id) => "$baseUrl/getCliente/$id";       // ← NUEVO
  static const String saveToken = "$baseUrl/saveToken";       // ← NUEVO
  static const String deleteToken= "$baseUrl/deleteToken";       // ← NUEVO
  static String getNotificacionesByUserId(String id) => "$baseUrl/getNotificacionesByUserId/$id";       // ← NUEVO
  
  static String updateUsuarioEndpoint(String cedula) =>
    "$baseUrl/updateUsuario/$cedula";
}
