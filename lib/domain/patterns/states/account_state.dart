abstract class AccountState {
  // Basic properties
  String get name; // 'active', 'frozen', etc.
  String get arabicName;
  String get colorHex;

  // Transition validation (matching backend)
  bool canTransitionTo(String targetState);
  String transitionError(String targetState);

  // Operations permissions
  bool get canDeposit;
  bool get canWithdraw;
  bool get canTransfer;
  bool get canModify;
  bool get canClose;
  bool get canDelete;
  bool get canChangeState;
}