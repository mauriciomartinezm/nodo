class ApiConstants {
  static const String baseUrl = "http://192.168.0.102:3000/api";
  static const String createPublicacionEndpoint = "$baseUrl/createPublicacion";
  static const String loginEndpoint = "$baseUrl/loginUsuario";
  static const String getTrabajadorByUserId = "$baseUrl/getTrabajadorByUserId";
  static const String getCategoriasEndpoint = "$baseUrl/getCategorias";
  static const String getPublicacionesByUserId = "$baseUrl/getPublicacionesByUserId";
  static const String createUsuarioEndpoint = "$baseUrl/createUsuario";
  static const String getPublicacionesEndpoint = "$baseUrl/getPublicaciones"; // ← NUEVO
  static String getClienteById(String id) => "$baseUrl/getCliente/$id";       // ← NUEVO
  static const String guardarToken = "$baseUrl/saveToken";       // ← NUEVO
  
  static String updateUsuarioEndpoint(String cedula) =>
    "$baseUrl/updateUsuario/$cedula";
}
