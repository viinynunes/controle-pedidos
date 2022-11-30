class Client {
  String id;
  String name;
  String phone;
  String email;
  String address;
  bool enabled;

  Client(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.address,
      required this.enabled});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Client && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
