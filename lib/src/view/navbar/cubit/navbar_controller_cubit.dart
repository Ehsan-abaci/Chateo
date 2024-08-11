import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'navbar_controller_state.dart';

class NavbarControllerCubit extends Cubit<NavbarControllerState> {
  NavbarControllerCubit() : super(NavbarControllerState(0));

  void changeIndex(int index) {
    emit(NavbarControllerState(index));
  }
}
