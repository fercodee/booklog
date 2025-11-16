import 'package:book_log/configs/dependencies.dart';
import 'package:book_log/routing/router.dart';
import 'package:book_log/ui/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: '.env');
  final url = dotenv.env['SUPABASE_URL']!;
  final key = dotenv.env['SUPABASE_ANON_KEY']!;
  await Supabase.initialize(url: url, anonKey: key);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providersRemote,
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Book Log',
            theme: AppTheme.lightTheme,
            routerConfig: router(context.read()),
          );
        },
      ),
    );
  }
}
