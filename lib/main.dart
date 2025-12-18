import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/supabase_config.dart';
import 'config/theme_data.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/admin_dashboard/admin_dashboard.dart';
import 'screens/student_dashboard.dart';
import 'screens/hod_dashboard.dart';
import 'screens/batch_advisor_dashboard.dart';
import 'screens/home_screen.dart';
import 'screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable better error reporting
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Flutter Error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };
  
  try {
    print('🚀 Starting app initialization...');
    
    // Try to load .env file, but don't fail if it doesn't exist
    try {
      await dotenv.load(fileName: '.env');
      print('✓ .env file loaded successfully');
      print('✓ SUPABASE_URL: ${dotenv.env['SUPABASE_URL']?.substring(0, 30)}...');
    } catch (e) {
      print('⚠ Warning: .env file not found. Some features may not work.');
      print('Error: $e');
    }
    
    // Try to initialize Supabase, but allow app to run without it for testing
    bool supabaseInitialized = false;
    try {
      await SupabaseConfig.initialize();
      print('✓ Supabase initialized successfully');
      supabaseInitialized = true;
    } catch (e, stackTrace) {
      print('⚠ Warning: Supabase initialization failed: $e');
      print('Stack trace: $stackTrace');
      print('⚠ App will continue but Supabase features will not work');
    }
    
    print('✓ Running MyApp...');
    runApp(MyApp(supabaseInitialized: supabaseInitialized));
  } catch (e, stackTrace) {
    print('❌ Fatal initialization error: $e');
    print('Stack trace: $stackTrace');
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Initialization Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Initialization Error',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '$e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  final bool supabaseInitialized;
  
  const MyApp({super.key, this.supabaseInitialized = false});

  @override
  Widget build(BuildContext context) {
    print('🏗️ Building MyApp widget...');
    try {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Complaint System',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/loading',
        routes: {
          '/loading': (context) => const LoadingScreen(),
          '/home': (context) => const HomeScreen(),
          '/signup': (context) => const SignupScreen(),
          '/login': (context) => const LoginScreen(),
          '/admin_dashboard': (context) => const AdminDashboard(),
          '/student_dashboard': (context) => const StudentDashboard(),
          '/hod_dashboard': (context) => const HODDashboard(),
          '/batch_advisor_dashboard': (context) => const BatchAdvisorDashboard(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text('Route ${settings.name} not found'),
              ),
            ),
          );
        },
        builder: (context, child) {
          // Add error boundary
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child ?? const SizedBox(),
          );
        },
      );
    } catch (e, stackTrace) {
      print('❌ Error building MyApp: $e');
      print('Stack trace: $stackTrace');
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'App Build Error',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('$e'),
              ],
            ),
          ),
        ),
      );
    }
  }
}
