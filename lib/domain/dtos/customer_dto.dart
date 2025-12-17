class CustomerData {
  final String name;
  final String email;
  final String? phone;

  CustomerData({
    required this.name,
    required this.email,
    this.phone,
  });
}