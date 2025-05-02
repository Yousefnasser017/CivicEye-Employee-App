import 'package:civiceye/widgets/custom_AppBar.dart';
import 'package:civiceye/widgets/custom_Drawer.dart';


import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomAppBar(),
        drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                      Image.asset(
                      isDarkMode 
                          ? 'assets/images/logo-white.png' 
                          : 'assets/images/logo-black.png',
                      height: 100,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Infrastructure Issue Reporting App',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'تطبيق متابعة مشكلات البنية التحتية',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Text(
                  'يساعد التطبيق الفنيين في استقبال وتنفيذ البلاغات من الجهات الحكومية بشكل سلس وسريع، ويعزز من كفاءة العمل الميداني عبر تقديم بيانات محدثة وحلول فورية.',
                  style: textTheme.bodyMedium?.copyWith(height: 1.6),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  'مميزات التطبيق:',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('واجهة بسيطة وسهلة الاستخدام'),
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications_active, color: Colors.green),
                      title: Text('تنبيهات فورية عند استلام بلاغات جديدة'),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.green),
                      title: Text('عرض الخريطة لتحديد الموقع والتنقل'),
                    ),
                    ListTile(
                      leading: Icon(Icons.security, color: Colors.green),
                      title: Text('تسجيل دخول آمن باستخدام JWT'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text('الدعم الفني:',  style:TextStyle(
                        color: isDarkMode? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                        fontSize: 16,
                      ),),
                    const SizedBox(height: 4),
                    Text(
                      'لأي استفسار تقني يمكنك التواصل معنا:',
                      style:TextStyle(
                        color: isDarkMode? Colors.white : Colors.black,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                        fontSize: 14,
                      ),
                      
                    

                    ),
                    const SizedBox(height: 6),
                    TextButton.icon(
                      icon: const Icon(Icons.email_outlined),
                      onPressed: () {
                        launchUrl(Uri.parse('mailto:support@example.com'));
                      },
                      label:  Text('support@example.com' ,
                          style: TextStyle(
                            color: isDarkMode? Colors.white :colorScheme.primary,
                            fontSize: 16,
                          )),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                child: Center(
                  child:  Text(
                    'تم تطوير هذا التطبيق كجزء من مشروع تخرج\nكلية الحاسبات والذكاء الاصطناعي - جامعة بنها',
                    style: TextStyle(
                      color: isDarkMode? Colors.white : Colors.black,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}