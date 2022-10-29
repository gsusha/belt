import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';

import '../../../styles.dart';
import '../../widgets/add_button.dart';
import '../auth/auth_page.dart';
import 'bloc/home_bloc.dart';
import 'photo_edit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget imageMapper(XFile file) => ImageItem(file: file);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text(
                'Добавленные изображения',
                style: Styles.titleStyle,
              ),
              actions: [
                GestureDetector(
                  child: const Icon(Icons.settings_outlined, size: 30),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeSuccess) {
                    return StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: state.imageList.map(imageMapper).toList(),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AddButton(),
    );
  }
}

class ImageItem extends StatelessWidget {
  final XFile file;

  const ImageItem({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.file(File(file.path)),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PhotoEdit(file: file))
      ),
    );
  }
}
