import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/foundation.dart';
import 'package:wallet_app/core/entropy_generator.dart';
import 'package:wallet_app/core/hasher.dart';
import 'package:wallet_app/core/storage.dart';
import 'package:wallet_app/pages/state.dart';

class ViewModel extends ChangeNotifier {
  ViewModel(this._entropyGenerator, this._storage, this._hasher);

  State _state = State();
  final EntropyGenerator _entropyGenerator;
  final Hasher _hasher;
  final Storage _storage;

  State get state => _state;

  Future<void> generateEntropy() async {
    final entropy = await _entropyGenerator.generate(16);

    _state = _state.copyWith(entropy: entropy);
    notifyListeners();
  }

  Future<void> generateChecksum() async {
    final hash = _hasher.hash(_state.entropy);

    // 체크섬: 해시 첫 바이트의 앞 4비트
    final checksum = hash.bytes[0]
        .toRadixString(2)
        .padLeft(8, '0')
        .substring(0, 4);

    // 엔트로피 → 비트 문자열 (128비트)
    final entropyBits = _state.entropy
        .map((b) => b.toRadixString(2).padLeft(8, '0'))
        .join();

    // 엔트로피 + 체크섬 (132비트)
    final entropyWithChecksum = entropyBits + checksum;

    _state = _state.copyWith(
      checksum: checksum,
      entropyWithChecksum: entropyWithChecksum,
    );
    notifyListeners();
  }

  Future<void> generateMnemonic() async {
    // 엔트로피 → hex 문자열
    final entropyHex = _state.entropy
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

    // 니모닉 생성 (체크섬, 분할, 단어 변환 다 해줌)
    final mnemonicString = bip39.entropyToMnemonic(entropyHex);

    _state = _state.copyWith(mnemonic: mnemonicString.split(' '));
    notifyListeners();
  }
}
