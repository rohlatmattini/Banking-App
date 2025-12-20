// lib/domain/dtos/approval_decision_dto.dart
class ApprovalDecisionData {
  final String decision; // 'approve' or 'reject'
  final String? note;

  ApprovalDecisionData({
    required this.decision,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'decision': decision,
      'note': note,
    };
  }
}