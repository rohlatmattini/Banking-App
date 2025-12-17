enum AccountTypeEnum {
  GROUP('group', 'مجموعة', '#009688'),
  SAVINGS('savings', 'توفير', '#4CAF50'),
  CHECKING('checking', 'جاري', '#2196F3'),
  LOAN('loan', 'قرض', '#FF9800'),
  INVESTMENT('investment', 'استثمار', '#9C27B0');

  final String value;
  final String arabicName;
  final String colorHex;

  const AccountTypeEnum(this.value, this.arabicName, this.colorHex);

  static AccountTypeEnum fromValue(String value) {
    return values.firstWhere(
          (e) => e.value == value,
      orElse: () => SAVINGS,
    );
  }
}