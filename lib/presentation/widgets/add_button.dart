import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../styles.dart';
import '../pages/home/bloc/home_bloc.dart';

class AddButton extends StatelessWidget {
  AddButton({super.key});

  final picker = ImagePicker();

  void pickImage(BuildContext context, ImageSource source) async {
    final image = await picker.pickImage(source: source);
    if (image != null) {
      context.read<HomeBloc>().add(AddImage(image: image));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Styles.red,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => pickImage(context, ImageSource.gallery),
            child: const Icon(
              Icons.image_outlined,
              color: Styles.textLight,
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 2,
            height: 20,
            color: Styles.textLight,
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () => pickImage(context, ImageSource.camera),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Styles.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
