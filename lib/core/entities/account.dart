class Account {
  const Account({
    required this.index,
    required this.address,
    required this.createdAt,
  });

  final int index;
  final String address;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          index == other.index &&
          address == other.address &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(index, address, createdAt);

  @override
  String toString() =>
      'Account(index: $index, address: $address, createdAt: $createdAt)';
}
