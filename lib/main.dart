import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'injection.dart';
import 'presentation/pages/auth/auth_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/home/bloc/home_bloc.dart';
import 'styles.dart';

void main() {
  configureDependencies();
  runApp(ChangeNotifierProvider(
    create: (context) => DarkMode(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<DarkMode>(context);
    return MaterialApp(
      title: 'Belt',
      theme: Styles.theme(themeMode.darkMode),
      home: BlocProvider(
        create: (context) => sl<HomeBloc>(),
        // child: const AuthPage(),
        child: const HomePage(),
      ),
    );
  }
}

class DarkMode with ChangeNotifier {
  bool darkMode = false;

  void changeMode() {
    darkMode = !darkMode;
    notifyListeners();
  }
}
