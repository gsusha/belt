import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';

part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<XFile> imageList = [];

  HomeBloc() : super(HomeInitial()) {
    on<HomeInit>(_init);
    on<AddImage>(_addImage);
  }

  void _init(HomeInit event, Emitter<HomeState> emit) async {}

  void _addImage(AddImage event, Emitter<HomeState> emit) async {
    imageList.add(event.image);
    emit(HomeSuccess(imageList));
  }
}
