part of 'navbar_controller_cubit.dart';

@immutable
class NavbarControllerState extends Equatable {
  int index;
  NavbarControllerState(this.index);
  @override
  List<Object?> get props => [index];
}
