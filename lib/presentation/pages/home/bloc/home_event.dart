part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeInit extends HomeEvent {}

class AddImage extends HomeEvent {
  final XFile image;

  const AddImage({required this.image});
}
