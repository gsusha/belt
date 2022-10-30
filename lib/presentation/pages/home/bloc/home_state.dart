part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeSuccess extends HomeState {
  final List<XFile> imageList;

  const HomeSuccess(this.imageList);

  @override
  List<Object> get props => [UniqueKey()];
}