import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StaggeredGrid.count(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            ClipRect(
              child: Image.network('https://source.unsplash.com/random/1'),
            ),
            ClipRect(
              child: Image.network('https://source.unsplash.com/random/2'),
            ),
            ClipRect(
              child: Image.network('https://source.unsplash.com/random/4'),
            ),
            ClipRect(
              child: Image.network('https://source.unsplash.com/random/5'),
            ),
          ],
        ),
      ),
    );
  }
}
