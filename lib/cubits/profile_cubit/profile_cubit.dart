import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final _storage = const FlutterSecureStorage();

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final fullName = await _storage.read(key: 'fullName') ?? '';
      final department = await _storage.read(key: 'department') ?? '';
      final cityName = await _storage.read(key: 'cityName') ?? '';
      final governorateName = await _storage.read(key: 'governorateName') ?? '';
      final email = await _storage.read(key: 'username') ?? '';
      
      emit(ProfileLoaded(
        fullName: fullName,
        email: email,
        department: department,
        address: '$cityName - $governorateName',

      ));
    } catch (e) {
      emit(ProfileError('Failed to load profile data.'));
    }
  }
}
