import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../styles.dart';
import '../../widgets/switch.dart';
import 'bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<DarkMode>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки', style: Styles.titleStyle)),
      body: Column(
        children: [
          TextSwitch(
            label: 'Тёмная тема',
            initial: themeMode.darkMode,
            onTap: (v) =>
                context.read<SettingsBloc>().add(SetDarkMode(v, themeMode)),
          ),
        ],
      ),
    );
  }
}
