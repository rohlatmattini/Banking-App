abstract class AccountComponent {
  String publicId();
  String type();
  String state();
  String balance(); // This component's balance only
  String totalBalance(); // Aggregate balance
  List<AccountComponent> children();
}