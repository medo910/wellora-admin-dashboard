import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/recent_activity_entity.dart';

class ActionModel extends ActionEntity {
  ActionModel({
    required super.adminName,
    required super.actionType,
    required super.targetEntity,
    required super.timestamp,
  });

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
      adminName: json['adminName'] ?? '',
      actionType: json['actionType'] ?? '',
      targetEntity: json['targetEntity'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
