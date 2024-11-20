// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'splash_cubit.dart';

class SplashState {
  bool isLogged;
  SplashState({
    this.isLogged = false,
  });

  SplashState copyWith({
    bool? isLogged,
  }) {
    return SplashState(
      isLogged: isLogged ?? this.isLogged,
    );
  }
}
