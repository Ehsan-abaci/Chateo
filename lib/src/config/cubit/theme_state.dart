// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  ThemeData theme;
  ThemeState(this.theme);

  @override
  List<Object> get props => [theme];

  ThemeState copyWith({
    ThemeData? theme,
  }) {
    return ThemeState(
      theme ?? this.theme,
    );
  }
}
