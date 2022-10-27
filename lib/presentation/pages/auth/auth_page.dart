import 'package:flutter/material.dart';

import '../../../styles.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            const Text('Введите пароль', style: Styles.titleStyle),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                PassIndicator(isActive: true),
                PassIndicator(isActive: true),
                PassIndicator(isActive: false),
                PassIndicator(isActive: false),
              ],
            ),
            const SizedBox(height: 40),
            const Keyboard(),
          ],
        ),
      ),
    );
  }
}

class PassIndicator extends StatelessWidget {
  final bool isActive;

  const PassIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isActive ? Styles.greyExtraLight : Styles.greyDark,
        shape: BoxShape.circle,
      ),
    );
  }
}

class KeyboardButton extends StatelessWidget {
  final int value;

  const KeyboardButton(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Styles.greyDark,
          shape: BoxShape.circle,
        ),
        child: Text(
          value.toString(),
          style: const TextStyle(
            color: Styles.textLight,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class Keyboard extends StatelessWidget {
  const Keyboard({super.key});

  Widget valueMapper(int value) => KeyboardButton(value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        children: [
          ...[1, 2, 3, 4, 5, 6, 7, 8, 9].map(valueMapper).toList(),
          const Icon(Icons.fingerprint, size: 30),
          const KeyboardButton(0),
          const Icon(Icons.backspace_outlined, size: 30),
        ],
      ),
    );
  }
}
