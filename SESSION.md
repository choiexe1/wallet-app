# Session Summary — Wallet App

## Date: 2026-02-09

---

## Completed Work

### 1. BLoC Pattern Setup
- Created `WalletBloc` (load/view) and `CreateWalletBloc` (create) with full event/state
- Wired BLoC with GetIt (factory registration) and GoRouter (BlocProvider per route)
- Applied `BlocBuilder` with Dart 3 sealed class pattern matching in pages

### 2. Feature Structure Reorganization
- Initially separated `wallet/` and `create_wallet/` features
- Merged back into single `wallet/` feature — shared `WalletRepository` with two BLoCs
- Moved `Wallet` entity to `core/entities/` for cross-feature sharing

### 3. UI Foundation
- Created `AppButton` (Toss-style CTA button) — `core/widgets/app_button.dart`
  - Scale-down press animation, flat design, rounded corners (16px)
  - Loading spinner + disabled state support
- Created `AppColor` — `core/constants/app_color.dart`
  - Toss blue primary, 5-level grayscale, semantic colors, text colors
- Created `AppTheme` — `core/theme/app_theme.dart`
  - Softer text colors (gray900 instead of pure black)
  - Clean AppBar (white bg, no elevation)
  - Applied via `MaterialApp.router(theme: AppTheme.light)`

### 4. BIP39 Mnemonic Generation (Hand-implemented)
- Entropy generation (128-bit) → hex conversion
- SHA-256 checksum extraction (first hex char = 4 bits)
- Entropy + checksum concatenation → binary string (132 bits)
- 11-bit chunking → BIP39 English wordlist lookup → 12 mnemonic words
- Location: `core/crypto/wallet/wallet_generator_impl.dart` → `_bip39()`

### 5. PBKDF2 Key Derivation (Hand-implemented)
- HMAC-SHA512 based, 2048 iterations
- Salt: `"mnemonic" + passphrase`
- XOR accumulation across iterations → 64-byte (512-bit) seed output
- Location: `core/crypto/wallet/wallet_generator_impl.dart` → `_pbkdf2()`

---

## Current Project Structure

```
lib/
├── main.dart
├── injector.dart
├── core/
│   ├── constants/
│   │   └── app_color.dart
│   ├── crypto/
│   │   ├── bip39/
│   │   │   └── words.dart              # BIP39 English wordlist (2048 words)
│   │   ├── entropy/
│   │   │   ├── entropy_generator.dart
│   │   │   └── entropy_generator_impl.dart
│   │   └── wallet/
│   │       ├── wallet_generator.dart
│   │       └── wallet_generator_impl.dart  # BIP39 + PBKDF2 implementation
│   ├── entities/
│   │   └── wallet.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── app_routes.dart
│   ├── storage/
│   │   ├── storage.dart
│   │   └── secure_storage.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── widgets/
│   │   └── app_button.dart             # Toss-style CTA button
│   ├── address_generator.dart
│   └── hasher.dart
└── features/
    └── wallet/
        ├── domain/repositories/
        │   └── wallet_repository.dart      # createWallet() + loadWallet()
        ├── data/repositories/
        │   └── wallet_repository_impl.dart # TODO: implement
        └── presentation/
            ├── bloc/
            │   ├── wallet_bloc.dart        # View wallet
            │   ├── wallet_event.dart
            │   ├── wallet_state.dart
            │   ├── create_wallet_bloc.dart # Create wallet
            │   ├── create_wallet_event.dart
            │   └── create_wallet_state.dart
            └── pages/
                ├── wallet_page.dart
                └── create_wallet_page.dart
```

---

## Remaining (Not Started)

- [ ] BIP32: Seed → Master Key (HMAC-SHA512)
- [ ] BIP44: Key derivation path (m/44'/60'/0'/0/0)
- [ ] Private Key → Public Key → EVM Address
- [ ] `WalletRepositoryImpl` — actual storage integration
- [ ] Connect `WalletGeneratorImpl` to `CreateWalletBloc` flow
- [ ] `generate()` method completion (currently returns dummy address)
- [ ] Tests for BIP39 / PBKDF2 implementation
