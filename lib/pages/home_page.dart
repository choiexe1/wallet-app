import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_app/pages/wallet_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.vm, super.key});

  final WalletViewModel vm;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final entropy = TextEditingController();
  final checksum = TextEditingController();
  final entropyWithChecksum = TextEditingController();
  final mnemonic = TextEditingController();
  final address = TextEditingController();
  final indexController = TextEditingController(text: '0');

  int get _currentIndex => int.tryParse(indexController.text) ?? 0;

  @override
  void dispose() {
    entropy.dispose();
    checksum.dispose();
    entropyWithChecksum.dispose();
    mnemonic.dispose();
    address.dispose();
    indexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 엔트로피
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '엔트로피',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(entropy.text, style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    await widget.vm.generateEntropy();
                    setState(() {
                      entropy.text = widget.vm.state.entropy.toString();
                    });
                  },
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '엔트로피 생성',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // 2. 체크섬
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '체크섬',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        checksum.text,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),

                // 3. 엔트로피 + 체크섬
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '엔트로피 + 체크섬',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        entropyWithChecksum.text,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    await widget.vm.generateChecksum();
                    setState(() {
                      checksum.text = widget.vm.state.checksum;
                      entropyWithChecksum.text =
                          widget.vm.state.entropyWithChecksum;
                    });
                  },
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '체크섬 생성',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // 4. 니모닉
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '니모닉',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        mnemonic.text,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    InkWell(
                      onTap: () async {
                        await widget.vm.generateMnemonic();
                        setState(() {
                          mnemonic.text = widget.vm.state.mnemonic.join(' ');
                        });
                      },
                      child: Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '니모닉 생성',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (mnemonic.text.isNotEmpty) {
                          Clipboard.setData(ClipboardData(text: mnemonic.text));
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('니모닉 복사됨')));
                        }
                      },
                      child: Container(
                        color: Colors.grey,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '복사',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // 5. 파생 경로
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '파생 경로',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "m/44'/60'/0'/0/",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            controller: indexController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) async {
                              if (mnemonic.text.isNotEmpty) {
                                await widget.vm.generateKey(
                                  index: _currentIndex,
                                );
                                widget.vm.generateAddress();
                                setState(() {
                                  address.text = widget.vm.state.address;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // 6. 지갑 주소
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '지갑 주소',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SelectableText(
                        address.text,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    InkWell(
                      onTap: () async {
                        await widget.vm.generateKey(index: _currentIndex);
                        widget.vm.generateAddress();
                        setState(() {
                          address.text = widget.vm.state.address;
                        });
                      },
                      child: Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '주소 생성',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (address.text.isNotEmpty) {
                          Clipboard.setData(ClipboardData(text: address.text));
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('주소 복사됨')));
                        }
                      },
                      child: Container(
                        color: Colors.grey,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '복사',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
