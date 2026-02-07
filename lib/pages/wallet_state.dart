import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class WalletState {
  WalletState({
    List<int> entropy = const [],
    List<int> words = const [],
    this.checksum = '',
    this.entropyWithChecksum = '',
    List<String> mnemonic = const [],
    this.privateKey,
    this.address = '',
  }) : entropy = List.unmodifiable(entropy),
       words = List.unmodifiable(words),
       mnemonic = List.unmodifiable(mnemonic);

  final List<int> entropy;
  final List<int> words;
  final String checksum;
  final String entropyWithChecksum;
  final List<String> mnemonic;
  final Uint8List? privateKey;
  final String address;

  WalletState copyWith({
    List<int>? entropy,
    List<int>? words,
    String? checksum,
    String? entropyWithChecksum,
    List<String>? mnemonic,
    Uint8List? privateKey,
    String? address,
  }) {
    return WalletState(
      entropy: entropy ?? this.entropy,
      words: words ?? this.words,
      checksum: checksum ?? this.checksum,
      entropyWithChecksum: entropyWithChecksum ?? this.entropyWithChecksum,
      mnemonic: mnemonic ?? this.mnemonic,
      privateKey: privateKey ?? this.privateKey,
      address: address ?? this.address,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletState &&
          runtimeType == other.runtimeType &&
          listEquals(entropy, other.entropy) &&
          listEquals(words, other.words) &&
          checksum == other.checksum &&
          entropyWithChecksum == other.entropyWithChecksum &&
          listEquals(mnemonic, other.mnemonic) &&
          _uint8ListEquals(privateKey, other.privateKey) &&
          address == other.address;

  static bool _uint8ListEquals(Uint8List? a, Uint8List? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(entropy),
    Object.hashAll(words),
    checksum,
    entropyWithChecksum,
    Object.hashAll(mnemonic),
    privateKey != null ? Object.hashAll(privateKey!) : null,
    address,
  );
}
