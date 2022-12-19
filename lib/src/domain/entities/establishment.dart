class Establishment {
  String id;
  String name;
  DateTime registrationDate;
  bool enabled;

  Establishment(
      {required this.id,
      required this.name,
      required this.registrationDate,
      required this.enabled});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Establishment &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
