import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = const FlutterSecureStorage();
  String fullName = '';
  String department = '';
  String address = '';

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final name = await _storage.read(key: 'fullName') ?? '';
    final dept = await _storage.read(key: 'department') ?? '';
    final city = await _storage.read(key: 'city') ?? '';
    final gov = await _storage.read(key: 'gov') ?? '';
    setState(() {
      fullName = name;
      department = dept;
      address = '$city - $gov';
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/images/user.png')),
            const SizedBox(height: 20),
            Text('الاسم: $fullName', style: textTheme.bodyLarge),
            Text('القسم: $department', style: textTheme.bodyLarge),
            Text('العنوان: $address', style: textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
