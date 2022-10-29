import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../main.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<SetDarkMode>(_setDarkMode);
  }

  void _setDarkMode(SetDarkMode event, Emitter<SettingsState> emit) {
    event.darkMode.changeMode();
  }
}
