import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  final _storage = const FlutterSecureStorage();

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Animation duration
    final username = await _storage.read(key: 'username');
    final isLoggedIn = await _storage.read(key: 'isLoggedIn');

    if (username != null && isLoggedIn == 'true') {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToLogin());
    }
  }
}