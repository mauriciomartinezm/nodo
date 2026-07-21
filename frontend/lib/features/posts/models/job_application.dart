/// Postulación de un trabajador a una publicación, con los datos del
/// trabajador ya incluidos (el backend los trae en una sola consulta).
class JobApplication {
  final String id;
  final String workerId;
  final String status;
  final String workerName;
  final String workerEmail;
  final String workerPhone;
  final String workerLocation;
  final String? workerPhoto;
  final String? workerDescription;
  final String workerCategory;

  JobApplication({
    required this.id,
    required this.workerId,
    required this.status,
    required this.workerName,
    required this.workerEmail,
    required this.workerPhone,
    required this.workerLocation,
    required this.workerCategory,
    this.workerPhoto,
    this.workerDescription,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    final worker = json['worker'] as Map<String, dynamic>?;
    final user = worker?['user'] as Map<String, dynamic>?;
    final categories = (worker?['workerCategories'] as List?) ?? [];
    final categoryName = categories.isNotEmpty
        ? categories
            .map((wc) => wc['generalCategory']?['name'])
            .where((name) => name != null)
            .join(', ')
        : 'Sin rubro';

    return JobApplication(
      id: json['id'],
      workerId: json['workerId'],
      status: json['status'],
      workerName: '${user?['firstName'] ?? ''} ${user?['lastName'] ?? ''}'.trim(),
      workerEmail: user?['email'] ?? 'Sin correo',
      workerPhone: user?['phone'] ?? 'Sin teléfono',
      workerLocation: user?['location'] ?? 'Sin ubicación',
      workerPhoto: user?['profilePhoto'],
      workerDescription: worker?['description'],
      workerCategory: categoryName,
    );
  }
}
