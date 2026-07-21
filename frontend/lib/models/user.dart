import 'package:nodo/models/categorie.dart';

class User {
  final String id;
  final String nombres;
  final String primerApellido;
  final String segundoApellido;
  final String email;
  final String telefono;
  final String fechaNacimiento;
  final String fechaRegistro;
  final String fotoPerfil;
  final bool verificado;
  final String tipoUsuario;
  final List<Categorie> categorias;
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
    required this.fechaRegistro,
    required this.fotoPerfil,
    required this.verificado,
    required this.tipoUsuario,
    required this.categorias,
    required this.ubicacion,
    required this.descripcion,
    this.calificacionPromedio,
    this.trabajosCompletados,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final worker = json['worker'] as Map<String, dynamic>?;
    final workerCategories = (worker?['workerCategories'] as List?) ?? [];

    return User(
      id: json['id'],
      nombres: json['firstName'] ?? '',
      primerApellido: json['lastName'] ?? '',
      segundoApellido: json['secondLastName'] ?? '',
      email: json['email'],
      telefono: json['phone'],
      fechaNacimiento: json['birthDate'] ?? '',
      fechaRegistro: json['registrationDate'] ?? '',
      fotoPerfil: json['profilePhoto'] ?? '',
      verificado: json['verified'] ?? false,
      tipoUsuario: worker != null ? 'trabajador' : 'cliente',
      categorias: workerCategories
          .map((wc) => Categorie.fromJson(wc['generalCategory']))
          .toList(),
      ubicacion: json['location'],
      descripcion: worker?['description'],
      // No son columnas reales (son agregados calculables), por ahora el
      // backend no los expone.
      calificacionPromedio: null,
      trabajosCompletados: null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': nombres,
        'lastName': primerApellido,
        'secondLastName': segundoApellido,
        'email': email,
        'phone': telefono,
        'birthDate': fechaNacimiento,
        'registrationDate': fechaRegistro,
        'profilePhoto': fotoPerfil,
        'verified': verificado,
        'location': ubicacion,
      };
}
