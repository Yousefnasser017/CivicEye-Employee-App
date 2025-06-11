import 'package:civiceye/core/storage/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); 
    final isLoggedIn = await LocalStorageHelper.getLoginState();
    final employee = await LocalStorageHelper.getEmployee();

    if (isLoggedIn && employee != null) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToLogin());
    }
  }
}
