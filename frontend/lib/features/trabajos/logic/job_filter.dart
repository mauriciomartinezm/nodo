import 'package:flutter/material.dart';

class JobFilter {
  final List<String> categoryIds;
  final String? location;
  final double? minPrice;
  final double? maxPrice;
  final String? timeFilter;
  final DateTimeRange? dateRange;

  const JobFilter({
    this.categoryIds = const [],
    this.location,
    this.minPrice,
    this.maxPrice,
    this.timeFilter,
    this.dateRange,
  });

  bool get isActive =>
      categoryIds.isNotEmpty ||
      location != null ||
      minPrice != null ||
      maxPrice != null ||
      timeFilter != null ||
      dateRange != null;

  int get activeCount {
    int c = 0;
    if (categoryIds.isNotEmpty) c++;
    if (location != null) c++;
    if (minPrice != null || maxPrice != null) c++;
    if (timeFilter != null) c++;
    if (dateRange != null) c++;
    return c;
  }
}
