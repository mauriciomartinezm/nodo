class User {
  final String id;
  final String nombres;
  final String primerApellido;
  final String segundoApellido;
  final String email;
  final String telefono;
  final String fechaNacimiento;
  final String contrasena;
  final String fechaRegistro;
  final String fotoPerfil;
  final bool verificado;
  final String tipoUsuario;
  final dynamic idCategoria;
  final dynamic ubicacion;
  final dynamic descripcion;
  final dynamic calificacionPromedio;
  final dynamic trabajosCompletados;

  User({
    required this.id,
    required this.nombres,
    required this.primerApellido,
    required this.segundoApellido,
    required this.email,
    required this.telefono,
    required this.fechaNacimiento,
    required this.contrasena,
    required this.fechaRegistro,
    required this.fotoPerfil,
    required this.verificado,
    required this.tipoUsuario,
    required this.idCategoria,
    required this.ubicacion,
    required this.descripcion,
    this.calificacionPromedio,
    this.trabajosCompletados,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nombres: json['nombres'],
      primerApellido: json['primer_apellido'],
      segundoApellido: json['segundo_apellido'],
      email: json['email'],
      telefono: json['telefono'],
      fechaNacimiento: json['fecha_nacimiento'] ?? '',
      contrasena: json['contrasena'] ?? '',
      fechaRegistro: json['fecha_registro'] ?? '',
      fotoPerfil: json['foto_perfil'] ?? '',
      verificado: json['verificado'] ?? false,
      tipoUsuario: json['tipo_usuario'] ?? 'cliente',
      idCategoria: json['id_categoria'],
      ubicacion: json['ubicacion'],
      descripcion: json['descripcion'],
      calificacionPromedio: json['calificacion_promedio'],
      trabajosCompletados: json['trabajos_completados'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombres': nombres,
        'primer_apellido': primerApellido,
        'segundo_apellido': segundoApellido,
        'email': email,
        'telefono': telefono,
        'fecha_nacimiento': fechaNacimiento,
        'contrasena': contrasena,
        'fecha_registro': fechaRegistro,
        'foto_perfil': fotoPerfil,
        'verificado': verificado,
        'tipo_usuario': tipoUsuario,
        'id_categoria': idCategoria,
        'ubicacion': ubicacion,
        'descripcion': descripcion,
        'calificacion_promedio': calificacionPromedio,
        'trabajos_completados': trabajosCompletados,
      };
}
