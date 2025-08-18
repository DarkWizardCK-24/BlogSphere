import 'package:bloggg_app/core/secrets/app_secrets.dart';
import 'package:bloggg_app/core/theme/theme.dart';
import 'package:bloggg_app/pages/home_page.dart';
import 'package:bloggg_app/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  final supabase = Supabase.instance.client;
  try {
    await supabase.rpc('create_blogs_table');
    print('Blogs table checked/created successfully.');
  } catch (e) {
    print('Error creating blogs table: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;
    return MaterialApp(
      title: 'Blogg App',
      theme: AppTheme.darkThemeMode,
      debugShowCheckedModeBanner: false,
      home: session != null ? const HomePage() : const SignInPage(),
    );
  }
}