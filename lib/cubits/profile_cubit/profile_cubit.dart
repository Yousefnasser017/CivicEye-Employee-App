import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:civiceye/core/api/report_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final _storage = const FlutterSecureStorage();

  // Load the user's profile data
  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final fullName = await _storage.read(key: 'fullName') ?? '';
      final department = await _storage.read(key: 'department') ?? '';
      final cityName = await _storage.read(key: 'cityName') ?? '';
      final governorateName = await _storage.read(key: 'governorateName') ?? '';
      final email = await _storage.read(key: 'username') ?? '';
      final empId = int.tryParse(await _storage.read(key: 'employeeId') ?? '0') ?? 0;

      // Fetch reports for progress calculation
      final reports = await ReportApi.getReportsByEmployee(empId);
      final totalReports = reports.length;
      final solvedReports = reports.where((r) => r.currentStatus == "Resolved").length;
      final progress = totalReports > 0 ? solvedReports / totalReports : 0.0;

      emit(ProfileLoaded(
        fullName: fullName,
        email: email,
        department: department,
        address: '$cityName, $governorateName',
        progress: progress,
        solvedReports: solvedReports,
        totalReports: totalReports,
      ));
    } catch (e) {
      emit(ProfileError( 'Failed to load profile data.'));
    }
  }
}
