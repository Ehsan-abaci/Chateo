import 'package:bloc/bloc.dart';
import 'package:ehsan_chat/src/config/theme_config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(ThemeConfig.ligthTheme()));

  toggleTheme() {
    emit(
      state.copyWith(
        theme: state.theme == ThemeConfig.ligthTheme()
            ? ThemeConfig.darkTheme()
            : ThemeConfig.ligthTheme(),
      ),
    );
  }
}
