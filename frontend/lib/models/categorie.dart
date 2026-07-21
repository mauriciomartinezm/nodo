class Categorie {
  final String id;
  final String name;

  Categorie({required this.id, required this.name});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id'].toString(),
      name: json['name'],
    );
  }

  @override
  String toString() => name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
