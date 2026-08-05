import 'package:flutter/material.dart';
import '../permissions/app_permission_service.dart';

class PermissionsProvider extends ChangeNotifier {
  final Map<PermissionType, AppPermissionStatus> _statuses = {
    PermissionType.location: AppPermissionStatus.denied,
    PermissionType.notifications: AppPermissionStatus.granted,
    PermissionType.camera: AppPermissionStatus.denied,
    PermissionType.microphone: AppPermissionStatus.denied,
    PermissionType.gallery: AppPermissionStatus.granted,
    PermissionType.biometric: AppPermissionStatus.denied,
    PermissionType.contacts: AppPermissionStatus.denied,
    PermissionType.storage: AppPermissionStatus.granted,
  };

  Map<PermissionType, AppPermissionStatus> get statuses => Map.unmodifiable(_statuses);

  AppPermissionStatus getStatus(PermissionType type) =>
      _statuses[type] ?? AppPermissionStatus.denied;

  bool isGranted(PermissionType type) =>
      _statuses[type] == AppPermissionStatus.granted;

  Future<bool> requestPermissionWithRationale({
    required BuildContext context,
    required PermissionType type,
    required String title,
    required String icon,
    required String description,
    required List<String> benefits,
    required String confirmText,
    required String cancelText,
  }) async {
    if (isGranted(type)) return true;

    final accepted = await AppPermissionService.showRationaleModal(
      context: context,
      title: title,
      icon: icon,
      description: description,
      benefits: benefits,
      confirmText: confirmText,
      cancelText: cancelText,
    );

    if (accepted) {
      _statuses[type] = AppPermissionStatus.granted;
      notifyListeners();
      return true;
    } else {
      _statuses[type] = AppPermissionStatus.denied;
      notifyListeners();
      return false;
    }
  }

  void updatePermissionStatus(PermissionType type, AppPermissionStatus newStatus) {
    _statuses[type] = newStatus;
    notifyListeners();
  }
}
