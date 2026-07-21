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
