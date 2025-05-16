class Cliente {
  final String id;
  final String nombre;
  final String contrasena;
  final DateTime fechaRegistro;
  final String fotoPerfil;
  final String telefono;
  final bool verificado;
  final DateTime? fechaNacimiento;

  Cliente({
    required this.id,
    required this.nombre,
    required this.contrasena,
    required this.fechaRegistro,
    required this.fotoPerfil,
    required this.telefono,
    required this.verificado,
    this.fechaNacimiento,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nombre: json['nombre'],
      contrasena: json['contraseña'],
      fechaRegistro: DateTime.parse(json['fecha_registro']),
      fotoPerfil: json['foto_perfil'],
      telefono: json['telefono'],
      verificado: json['verificado'],
      fechaNacimiento: json['fecha_nacimiento'] != null
          ? DateTime.tryParse(json['fecha_nacimiento'])
          : null,
    );
  }
}
