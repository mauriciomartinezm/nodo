import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nodo/core/theme/app_theme.dart';
import 'package:nodo/features/trabajos/screens/job_detail_screen.dart';
import 'package:nodo/features/trabajos/screens/category_filter_screen.dart';
import 'package:nodo/features/trabajos/logic/job_filter.dart';
import 'package:nodo/features/trabajos/logic/job_service.dart';
import 'package:nodo/features/trabajos/widgets/joblist.dart';
import 'package:nodo/shared/providers/user_provider.dart';
import 'package:provider/provider.dart';

class JobsScreen2 extends StatefulWidget {
  const JobsScreen2({super.key});

  @override
  State<JobsScreen2> createState() => _JobsScreen2State();
}

class _JobsScreen2State extends State<JobsScreen2> {
  List<dynamic> _publicaciones = [];
  Map<String, String> _nombresClientes = {};
  bool _isLoading = true;
  String _errorMessage = '';
  List<dynamic> _postulaciones = [];
  bool _isLoadingPostulaciones = true;
  String _errorMessagePostulaciones = '';
  int _selectedTab = 0;
  JobFilter _filter = const JobFilter();

  static const _tabs = [
    (label: 'Explorar',  icon: Icons.search_rounded),
    (label: 'Activos',   icon: Icons.bolt_rounded),
    (label: 'Historial', icon: Icons.history_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    await _loadData();
    await _loadPostulaciones();
  }

  Future<void> _loadData() async {
    final currentId =
        Provider.of<UserProvider>(context, listen: false).user?.id;
    if (currentId == null) return;
    try {
      final publicaciones = await JobService.fetchPostsForWorker(currentId);
      final nombres = await JobService.fetchClientNames(publicaciones);
      if (!mounted) return;
      setState(() {
        _publicaciones = publicaciones;
        _nombresClientes = nombres;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> _loadPostulaciones() async {
    final currentId =
        Provider.of<UserProvider>(context, listen: false).user?.id;
    if (currentId == null) return;
    try {
      final postulaciones =
          await JobService.fetchApplicationsByUser(currentId);
      if (!mounted) return;
      final extraNames = <String, String>{};
      for (final p in postulaciones) {
        final post = p['post'] as Map?;
        if (post != null) {
          final clientId = post['clientId']?.toString();
          final firstName = post['client']?['firstName'] as String?;
          if (clientId != null && firstName != null) {
            extraNames[clientId] = firstName;
          }
        }
      }
      setState(() {
        _postulaciones = postulaciones;
        _nombresClientes = {...extraNames, ..._nombresClientes};
        _isLoadingPostulaciones = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingPostulaciones = false;
        _errorMessagePostulaciones = 'Error: $e';
      });
    }
  }

  // ── Filtros ───────────────────────────────────────────────────────────────

  List<dynamic> _applyFilter(List<dynamic> posts) {
    if (!_filter.isActive) return posts;
    return posts.where((pub) {
      if (_filter.categoryIds.isNotEmpty) {
        final cats = (pub['categories'] as List?) ?? [];
        final ids =
            cats.map((c) => c['specificCategoryId'].toString()).toSet();
        if (!_filter.categoryIds.any((id) => ids.contains(id))) return false;
      }
      if (_filter.location != null) {
        final loc = (pub['location'] ?? '').toString().toLowerCase();
        if (!loc.contains(_filter.location!.toLowerCase())) return false;
      }
      final budget = (pub['budget'] as num?)?.toDouble() ?? 0;
      if (_filter.minPrice != null && budget < _filter.minPrice!) return false;
      if (_filter.maxPrice != null &&
          _filter.maxPrice! > 0 &&
          budget > _filter.maxPrice!) {
        return false;
      }
      if (_filter.timeFilter != null) {
        final postDate = DateTime.tryParse(pub['postDate'] ?? '');
        if (postDate != null) {
          final now = DateTime.now();
          switch (_filter.timeFilter) {
            case 'Última Hora':
              if (now.difference(postDate).inHours >= 1) return false;
              break;
            case 'Hoy':
              if (!_isSameDay(postDate, now)) return false;
              break;
            case 'Esta semana':
              if (now.difference(postDate).inDays >= 7) return false;
              break;
          }
        }
      }
      if (_filter.dateRange != null) {
        final deadline = DateTime.tryParse(pub['deadline'] ?? '');
        if (deadline == null) return false;
        if (deadline.isBefore(_filter.dateRange!.start)) return false;
        if (deadline.isAfter(
              _filter.dateRange!.end.add(const Duration(days: 1)))) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ── Navegación ────────────────────────────────────────────────────────────

  void _mostrarDetalleTrabajo(
    dynamic pub,
    String nombreCliente,
    Map<String, dynamic>? postulacion,
    bool desdePostulaciones,
  ) {
    final categories = (pub['categories'] as List?) ?? [];
    final firstCategoryId = categories.isNotEmpty
        ? (categories[0]['specificCategoryId']?.toString() ?? '')
        : '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailScreen(
          job: {
            "id": pub['id'],
            "title": pub['title'],
            "description": pub['description'],
            "price": "\$${pub['budget']}",
            "location": "${pub['location']}",
            "user": "Nombre del cliente: $nombreCliente",
            "time":
                "${JobService.formatTimeAgo(pub['postDate'] ?? '')} · ${pub['status'] ?? ''}",
            "image": JobService.getIconForCategory(firstCategoryId),
            "images": _parseImages(pub['photos']),
          },
          postulacion: postulacion,
          desdePostulaciones: desdePostulaciones,
          onPostulacionCambiada: _loadAllData,
        ),
      ),
    );
  }

  List<String> _parseImages(dynamic photos) {
    if (photos is List && photos.isNotEmpty) {
      return photos
          .map<String>((e) {
            if (e is String) return e;
            if (e is Map) return (e['url'] as String?) ?? '';
            return '';
          })
          .where((url) => url.isNotEmpty)
          .toList();
    }
    return [];
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final disponiblesRaw = _publicaciones
        .where((pub) => !_postulaciones.any((p) => p['postId'] == pub['id']))
        .toList();
    final disponiblesCount = _applyFilter(disponiblesRaw).length;

    final activosCount = _postulaciones.where((p) {
      if (p['status'] == 'pending') return true;
      if (p['status'] == 'accepted' &&
          p['service']?['status'] != 'completed' &&
          p['service']?['status'] != 'cancelled') {
        return true;
      }
      return false;
    }).length;

    final counts = [disponiblesCount, activosCount, 0];

    return Scaffold(
      backgroundColor:
          Color.alphaBlend(AppColors.blue.withValues(alpha: 0.03), Colors.white),
      body: Column(
        children: [
          _buildHeader(context),
          _buildTabs(counts),
          Expanded(child: _buildTabBody()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isLoadingAny = _isLoading || _isLoadingPostulaciones;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          20.w, MediaQuery.of(context).padding.top + 16.h, 16.w, 20.h),
      decoration: const BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trabajos',
                    style:
                        AppTypography.title.copyWith(color: AppColors.white)),
                SizedBox(height: 4.h),
                Text(
                  'Encuentra oportunidades cerca de ti',
                  style: AppTypography.caption.copyWith(
                      color: AppColors.white.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.filter_alt_outlined,
                    color: AppColors.white, size: 22.r),
                onPressed: () async {
                  final result = await showModalBottomSheet<JobFilter>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) =>
                        CategoryFilterScreen(initialFilter: _filter),
                  );
                  if (result != null && mounted) {
                    setState(() => _filter = result);
                  }
                },
              ),
              if (_filter.isActive)
                Positioned(
                  top: 8.r,
                  right: 8.r,
                  child: Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: const BoxDecoration(
                      color: AppColors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: isLoadingAny
                ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: const CircularProgressIndicator(
                        color: AppColors.white, strokeWidth: 2),
                  )
                : Icon(Icons.refresh_rounded,
                    color: AppColors.white, size: 22.r),
            onPressed: isLoadingAny ? null : _loadAllData,
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(List<int> counts) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final isSelected = _selectedTab == i;
          final count = counts[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.blue.withValues(alpha: 0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          _tabs[i].icon,
                          size: 18.r,
                          color: isSelected
                              ? AppColors.white
                              : AppColors.blue.withValues(alpha: 0.5),
                        ),
                        if (count > 0 && i != 0)
                          Positioned(
                            top: -4,
                            right: -8,
                            child: Container(
                              padding: EdgeInsets.all(2.r),
                              constraints: BoxConstraints(
                                  minWidth: 14.r, minHeight: 14.r),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.orange
                                    : AppColors.blue.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontFamily: 'GothamBold',
                                  fontSize: 8.sp,
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.blue,
                                  height: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      _tabs[i].label,
                      style: AppTypography.caption.copyWith(
                        color: isSelected
                            ? AppColors.white
                            : AppColors.blue.withValues(alpha: 0.6),
                        fontFamily:
                            isSelected ? 'GothamMedium' : 'GothamBook',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabBody() {
    return IndexedStack(
      index: _selectedTab,
      children: [
        _buildExplorarList(),
        _buildActivosList(),
        _buildHistorialList(),
      ],
    );
  }

  // ── Tab: Explorar ─────────────────────────────────────────────────────────

  Widget _buildExplorarList() {
    final disponibles = _applyFilter(
      _publicaciones
          .where(
              (pub) => !_postulaciones.any((p) => p['postId'] == pub['id']))
          .toList(),
    );

    return RefreshIndicator(
      onRefresh: _loadAllData,
      color: AppColors.orange,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? _errorState(_errorMessage)
              : disponibles.isEmpty
                  ? _emptyState(
                      Icons.search_off_outlined,
                      _filter.isActive
                          ? 'Sin resultados'
                          : 'Sin trabajos disponibles',
                      _filter.isActive
                          ? 'Ningún trabajo coincide con los filtros. Prueba ajustándolos.'
                          : 'No hay solicitudes publicadas en este momento.',
                    )
                  : JobList(
                      publicaciones: disponibles,
                      nombresClientes: _nombresClientes,
                      onVerDetalles: (pub, nombre) =>
                          _mostrarDetalleTrabajo(pub, nombre, null, false),
                    ),
    );
  }

  // ── Tab: Activos ──────────────────────────────────────────────────────────

  Widget _buildActivosList() {
    final pendientes = _postulaciones
        .where((p) => p['status'] == 'pending')
        .toList();

    final enCurso = _postulaciones
        .where((p) =>
            p['status'] == 'accepted' &&
            p['service']?['status'] != 'completed' &&
            p['service']?['status'] != 'cancelled')
        .toList();

    return RefreshIndicator(
      onRefresh: _loadAllData,
      color: AppColors.orange,
      child: _isLoadingPostulaciones
          ? const Center(child: CircularProgressIndicator())
          : _errorMessagePostulaciones.isNotEmpty
              ? _errorState(_errorMessagePostulaciones)
              : (pendientes.isEmpty && enCurso.isEmpty)
                  ? _emptyState(
                      Icons.bolt_outlined,
                      'Sin actividad',
                      'Tus postulaciones y trabajos activos aparecerán aquí.',
                    )
                  : ListView(
                      padding: EdgeInsets.all(16.r),
                      children: [
                        if (pendientes.isNotEmpty) ...[
                          _buildSectionLabel('Esperando respuesta'),
                          ...pendientes.map(
                              (p) => _buildStatusRow(p, _RowTipo.pending)),
                        ],
                        if (enCurso.isNotEmpty) ...[
                          _buildSectionLabel('En progreso'),
                          ...enCurso.map(
                              (p) => _buildStatusRow(p, _RowTipo.inProgress)),
                        ],
                      ],
                    ),
    );
  }

  // ── Tab: Historial ────────────────────────────────────────────────────────

  Widget _buildHistorialList() {
    final completados = _postulaciones
        .where((p) =>
            p['status'] == 'accepted' &&
            p['service']?['status'] == 'completed')
        .toList();

    final rechazados = _postulaciones
        .where((p) =>
            p['status'] == 'rejected' || p['status'] == 'withdrawn')
        .toList();

    return RefreshIndicator(
      onRefresh: _loadAllData,
      color: AppColors.orange,
      child: _isLoadingPostulaciones
          ? const Center(child: CircularProgressIndicator())
          : _errorMessagePostulaciones.isNotEmpty
              ? _errorState(_errorMessagePostulaciones)
              : (completados.isEmpty && rechazados.isEmpty)
                  ? _emptyState(
                      Icons.history_rounded,
                      'Sin historial',
                      'Los trabajos completados y rechazados aparecerán aquí.',
                    )
                  : ListView(
                      padding: EdgeInsets.all(16.r),
                      children: [
                        if (completados.isNotEmpty) ...[
                          _buildSectionLabel('Completados'),
                          ...completados.map(
                              (p) => _buildStatusRow(p, _RowTipo.completed)),
                        ],
                        if (rechazados.isNotEmpty) ...[
                          _buildSectionLabel('Rechazados'),
                          ...rechazados.map(
                              (p) => _buildStatusRow(p, _RowTipo.rejected)),
                        ],
                      ],
                    ),
    );
  }

  // ── Status row ────────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: AppColors.slateGrey,
          fontFamily: 'GothamMedium',
        ),
      ),
    );
  }

  Widget _buildStatusRow(dynamic p, _RowTipo tipo) {
    final pub = _publicaciones.firstWhere(
      (pub) => pub['id'] == p['postId'],
      orElse: () => p['post'],
    );
    if (pub == null) return const SizedBox.shrink();

    final clientId = pub['clientId']?.toString() ?? '';
    final nombre = _nombresClientes[clientId] ?? 'Cliente';
    final titulo = (pub['title'] ?? 'Sin título') as String;
    final tiempo = JobService.formatTimeAgo(pub['postDate'] ?? '');

    final IconData rowIcon;
    final Color iconBg;
    final Color iconColor;
    final String pillLabel;
    final Color pillBg;
    final Color pillText;

    switch (tipo) {
      case _RowTipo.pending:
        rowIcon = Icons.send_outlined;
        iconBg = AppColors.orange.withValues(alpha: 0.10);
        iconColor = AppColors.orange;
        pillLabel = 'Pendiente';
        pillBg = AppColors.orange.withValues(alpha: 0.11);
        pillText = AppColors.orange;
        break;
      case _RowTipo.inProgress:
        rowIcon = Icons.construction_outlined;
        iconBg = AppColors.blue.withValues(alpha: 0.08);
        iconColor = AppColors.blue;
        pillLabel = 'En curso';
        pillBg = AppColors.blue.withValues(alpha: 0.09);
        pillText = AppColors.blue;
        break;
      case _RowTipo.completed:
        rowIcon = Icons.check_circle_outline_rounded;
        iconBg = AppColors.success.withValues(alpha: 0.09);
        iconColor = AppColors.success;
        pillLabel = 'Completado';
        pillBg = AppColors.success.withValues(alpha: 0.10);
        pillText = AppColors.success;
        break;
      case _RowTipo.rejected:
        rowIcon = Icons.cancel_outlined;
        iconBg = AppColors.error.withValues(alpha: 0.08);
        iconColor = AppColors.error;
        pillLabel = 'Rechazado';
        pillBg = AppColors.error.withValues(alpha: 0.08);
        pillText = AppColors.error;
        break;
    }

    return GestureDetector(
      onTap: () => _mostrarDetalleTrabajo(
        pub,
        nombre,
        p as Map<String, dynamic>?,
        true,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: AppColors.blue.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(rowIcon, size: 18.sp, color: iconColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: AppTypography.body.copyWith(color: AppColors.blue),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$nombre · $tiempo',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.slateGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: pillBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                pillLabel,
                style: AppTypography.caption.copyWith(
                  color: pillText,
                  fontFamily: 'GothamMedium',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Estados vacíos / error ────────────────────────────────────────────────

  Widget _emptyState(IconData icon, String title, String description) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 60.h),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon,
                      size: 52.r,
                      color: AppColors.blue.withValues(alpha: 0.3)),
                ),
                SizedBox(height: 20.h),
                Text(title,
                    style: AppTypography.subtitle.copyWith(
                        color: AppColors.blue.withValues(alpha: 0.7)),
                    textAlign: TextAlign.center),
                SizedBox(height: 10.h),
                Text(description,
                    style:
                        AppTypography.body.copyWith(color: AppColors.slateGrey),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _errorState(String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 60.h),
        Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              children: [
                Icon(Icons.cloud_off_outlined,
                    size: 48.r, color: AppColors.slateGrey),
                SizedBox(height: 12.h),
                Text(message,
                    style:
                        AppTypography.body.copyWith(color: AppColors.slateGrey),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum _RowTipo { pending, inProgress, completed, rejected }
