class Trabajador {
  final String id;
  final String idUsuario;
  final String habilidad;
  final String experiencia;
  final double calificacionPromedio;
  final bool disponibilidad;
  final String ubicacion;
  final bool verificado;

  Trabajador({
    required this.id,
    required this.idUsuario,
    required this.habilidad,
    required this.experiencia,
    required this.calificacionPromedio,
    required this.disponibilidad,
    required this.ubicacion,
    required this.verificado,
  });

  factory Trabajador.fromJson(Map<String, dynamic> json) {
    return Trabajador(
      id: json['id'],
      idUsuario: json['id_usuario'],
      habilidad: json['habilidad'],
      experiencia: json['experiencia'],
      calificacionPromedio: (json['calificacion_promedio'] as num).toDouble(),
      disponibilidad: json['disponibilidad'],
      ubicacion: json['ubicacion'],
      verificado: json['verificado'],
    );
  }
}
