final class Wallet {
  Wallet({required this.address, required this.name});

  final String address;
  final String name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Wallet) return false;
    return other.address == address && other.name == name;
  }

  @override
  int get hashCode => Object.hash(address, name);

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      address: json['address'] as String,
      name: json['name'] as String,
    );
  }
  Map<String, String> toJson() => {'address': address, 'name': name};
}
