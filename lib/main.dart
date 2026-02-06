import 'package:flutter/material.dart';
import 'package:wallet_app/injector.dart';
import 'package:wallet_app/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await injection();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallet MVP',
      home: HomePage(vm: sl.get()),
    );
  }
}
