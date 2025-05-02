// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:civiceye/core/storage/token_storage.dart';

// // إنشاء Mock لـ FlutterSecureStorage باستخدام Mocktail
// class MockSecureStorage extends Mock implements FlutterSecureStorage {}

// void main() {
//   late MockSecureStorage mockStorage;

//   setUp(() {
//     mockStorage = MockSecureStorage();
//     TokenStorage.overrideStorage(mockStorage); // تفعيل الـ Mock بدلًا من الـ Default
//   });

//   group('TokenStorage', () {
//     test('should save token', () async {
//       const testToken = 'test_token';
      
//       // تحديد سلوك mock عند استخدام write
//       when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
//           .thenAnswer((_) async {});

//       // اختبار حفظ التوكن
//       await TokenStorage.saveToken(testToken);

//       verify(() => mockStorage.write(key: 'token', value: testToken)).called(1);
//     });

//     test('should get token', () async {
//       const testToken = 'stored_token';
      
//       // تحديد سلوك mock عند استخدام read
//       when(() => mockStorage.read(key: any(named: 'key')))
//           .thenAnswer((_) async => testToken);

//       // اختبار استرجاع التوكن
//       final token = await TokenStorage.getToken();

//       expect(token, testToken);
//       verify(() => mockStorage.read(key: 'token')).called(1);
//     });

//     test('should delete token', () async {
//       // تحديد سلوك mock عند استخدام delete
//       when(() => mockStorage.delete(key: any(named: 'key')))
//           .thenAnswer((_) async {});

//       // اختبار حذف التوكن
//       await TokenStorage.deleteToken();

//       verify(() => mockStorage.delete(key: 'token')).called(1);
//     });
//   });
// }
