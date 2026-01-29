import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/iphone_16_pro_wrapper.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/health/presentation/pages/health_page.dart';
import 'features/search/presentation/pages/search_page.dart';
import 'services/test_websocket.dart';
// import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // TODO: Uncomment when Supabase is configured
  // Initialize Supabase
  // await SupabaseService.initialize();

  runApp(const TreeLawZooApp());
}

class TreeLawZooApp extends StatelessWidget {
  const TreeLawZooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tree Law Zoo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/health': (context) => const HealthPage(),
        '/test': (context) => const TestWebSocketWidget(),
      },
      onGenerateRoute: (settings) {
        // Handle routes with arguments
        switch (settings.name) {
          case '/search':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => SearchPage(
                hintText: args?['hintText'] as String?,
                initialQuery: args?['initialQuery'] as String?,
                category: args?['category'] as String?,
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}
