import 'package:bloc/bloc.dart';

import '../../../cache_manager/user_cache.dart';
import '../../../core/utils/resources/config.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState()) {
    init();
  }

  void init() async {
    try {
      await UserCacheManager.checkLogin();

      if (UserCacheManager.isUserLoggedIn) {
        Config.me = UserCacheManager.getUserData();

        emit(state.copyWith(isLogged: true));
      } else {
        emit(state.copyWith(isLogged: false));
      }
    } catch (e) {
      emit(state.copyWith(isLogged: false));
    }
  }
}
