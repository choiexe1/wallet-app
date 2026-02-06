import 'package:flutter/foundation.dart';

class State {
  State({
    List<int> entropy = const [],
    List<int> words = const [],
    this.checksum = '',
    this.entropyWithChecksum = '',
    List<String> mnemonic = const [],
  }) : entropy = List.unmodifiable(entropy),
       words = List.unmodifiable(words),
       mnemonic = List.unmodifiable(mnemonic);

  final List<int> entropy;
  final List<int> words;
  final String checksum;
  final String entropyWithChecksum;
  final List<String> mnemonic;

  State copyWith({
    List<int>? entropy,
    List<int>? words,
    String? checksum,
    String? entropyWithChecksum,
    List<String>? mnemonic,
  }) {
    return State(
      entropy: entropy ?? this.entropy,
      words: words ?? this.words,
      checksum: checksum ?? this.checksum,
      entropyWithChecksum: entropyWithChecksum ?? this.entropyWithChecksum,
      mnemonic: mnemonic ?? this.mnemonic,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is State &&
          runtimeType == other.runtimeType &&
          listEquals(entropy, other.entropy) &&
          listEquals(words, other.words) &&
          checksum == other.checksum &&
          entropyWithChecksum == other.entropyWithChecksum &&
          listEquals(mnemonic, other.mnemonic);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(entropy),
    Object.hashAll(words),
    checksum,
    entropyWithChecksum,
    Object.hashAll(mnemonic),
  );
}
