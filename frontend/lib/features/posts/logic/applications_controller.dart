import 'package:flutter/material.dart';
import 'package:nodo/features/posts/models/job_application.dart';
import 'applications_service.dart';

class ApplicationsController extends ChangeNotifier {
  final ApplicationsService _service;
  final String postId;

  List<JobApplication> _applications = [];
  bool _isLoading = true;
  String _errorMessage = '';

  ApplicationsController(this._service, this.postId) {
    loadApplications();
  }

  List<JobApplication> get applications => _applications;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  bool get hasAcceptedApplication =>
      _applications.any((a) => a.status == 'accepted');

  Future<void> loadApplications() async {
    try {
      _setLoading(true);
      _applications = await _service.getApplicationsByPostId(postId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _applications = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> acceptApplication(String applicationId) =>
      _updateStatus(applicationId, 'accepted');

  Future<bool> rejectApplication(String applicationId) =>
      _updateStatus(applicationId, 'rejected');

  Future<bool> _updateStatus(String applicationId, String newStatus) async {
    final success =
        await _service.updateApplicationStatus(applicationId, newStatus);
    if (success) {
      await loadApplications();
    }
    return success;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
