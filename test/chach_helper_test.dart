// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:civiceye/core/storage/cache_helper.dart';

// class MockSecureStorage extends Mock implements FlutterSecureStorage {}

// void main() {
//   late MockSecureStorage mockStorage;

//   setUp(() {
//     mockStorage = MockSecureStorage();
//     LocalStorageHelper.overrideStorage(mockStorage); // لازم تضيف الطريقة دي في Helper
//   });

//   tearDown(() {
//     reset(mockStorage);
//   });

//   test('Should save and read employee data correctly', () async {
//     final testData = {
//       'employeeId': '123',
//       'fullName': 'John Doe',
//       'email': 'john@example.com',
//       'department': 'IT',
//       'cityName': 'Cairo',
//       'governorateName': 'Cairo',
//       'username': 'john@example.com',
//     };

//     for (var entry in testData.entries) {
//       when(() => mockStorage.write(key: entry.key, value: entry.value)).thenAnswer((_) async {});
//       when(() => mockStorage.read(key: entry.key)).thenAnswer((_) async => entry.value);
//     }

//     await LocalStorageHelper.saveEmployeeData(testData);
//     final result = await LocalStorageHelper.readEmployeeData();

//     expect(result, testData);
//   });

//   test('Should save and retrieve login state', () async {
//     when(() => mockStorage.write(key: 'isLoggedIn', value: 'true')).thenAnswer((_) async {});
//     when(() => mockStorage.read(key: 'isLoggedIn')).thenAnswer((_) async => 'true');

//     await LocalStorageHelper.saveLoginState(true);
//     final state = await LocalStorageHelper.getLoginState();

//     expect(state, isTrue);
//   });

//   test('Should save and retrieve last visited page', () async {
//     const route = '/dashboard';

//     when(() => mockStorage.write(key: 'last_page', value: route)).thenAnswer((_) async {});
//     when(() => mockStorage.read(key: 'last_page')).thenAnswer((_) async => route);

//     await LocalStorageHelper.saveLastPage(route);
//     final result = await LocalStorageHelper.getLastPage();

//     expect(result, route);
//   });
// }
