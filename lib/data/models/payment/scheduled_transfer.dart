class ScheduledTransfer {
  final String publicId;
  final int ownerUserId;
  final String type; // 'transfer', 'withdraw', 'deposit'
  final double amount;
  final String currency;
  final String description;
  final String frequency; // 'monthly', 'weekly', 'daily'
  final int interval;
  final int? dayOfMonth;
  final String runTime;
  final String status; // 'active', 'paused', 'cancelled'
  final DateTime? nextRunAt;
  final DateTime? lastRunAt;
  final DateTime createdAt;
  final String? sourceAccountId;
  final String? destinationAccountId;

  ScheduledTransfer({
    required this.publicId,
    required this.ownerUserId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.description,
    required this.frequency,
    required this.interval,
    this.dayOfMonth,
    required this.runTime,
    required this.status,
    this.nextRunAt,
    this.lastRunAt,
    required this.createdAt,
    this.sourceAccountId,
    this.destinationAccountId,
  });

  factory ScheduledTransfer.fromJson(Map<String, dynamic> json) {
    return ScheduledTransfer(
      publicId: json['public_id'],
      ownerUserId: json['owner_user_id'],
      type: json['type'],
      amount: double.parse(json['amount'].toString()),
      currency: json['currency'],
      description: json['description'],
      frequency: json['frequency'],
      interval: json['interval'],
      dayOfMonth: json['day_of_month'],
      runTime: json['run_time'],
      status: json['status'],
      nextRunAt: json['next_run_at'] != null
          ? DateTime.parse(json['next_run_at']).toLocal()
          : null,
      lastRunAt: json['last_run_at'] != null
          ? DateTime.parse(json['last_run_at']).toLocal()
          : null,
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      sourceAccountId: json['source_account_public_id'],
      destinationAccountId: json['destination_account_public_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source_account_public_id': sourceAccountId,
      'destination_account_public_id': destinationAccountId,
      'amount': amount,
      'description': description,
      'frequency': frequency,
      'interval': interval,
      'day_of_month': dayOfMonth,
      'run_time': runTime,
    };
  }
}
