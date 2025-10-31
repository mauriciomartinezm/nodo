class Categorie {
  final String id;
  final String nombre;
  final String descripcion;

  Categorie({required this.id, required this.nombre, required this.descripcion});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion']
    );
  }

  @override
  String toString() => nombre;
  
  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
      };
}
