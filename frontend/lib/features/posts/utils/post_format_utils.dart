/// Helpers compartidos para mostrar datos de una publicación,
/// usados tanto en la tarjeta de la grilla como en el detalle.

List<String> parsePostImages(dynamic photos) {
  if (photos is List) {
    return photos.map((url) => url.toString()).toList();
  }
  return [];
}

String formatPostDate(String? dateString) {
  if (dateString == null) return '';
  try {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  } catch (_) {
    return dateString;
  }
}
