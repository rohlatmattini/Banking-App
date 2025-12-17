enum AccountStateEnum {
  ACTIVE('active'),
  FROZEN('frozen'),
  SUSPENDED('suspended'),
  CLOSED('closed');

  final String value;

  const AccountStateEnum(this.value);

  static AccountStateEnum fromValue(String value) {
    return values.firstWhere(
          (e) => e.value == value,
      orElse: () => ACTIVE,
    );
  }
}