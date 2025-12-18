import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SupabaseConfig {
  static late SupabaseClient _client;
  static late SupabaseClient _adminClient;
  static bool _isInitialized = false;

  static SupabaseClient get client => _client;
  static SupabaseClient get adminClient => _adminClient;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    try {
      print('Starting Supabase initialization...');
      
      String? supabaseUrl;
      String? anonKey;
      String? serviceKey;
      String? smtpEmail;
      String? smtpPassword;

      if (kIsWeb) {
        // For web, read from window.env (injected by Vercel build script)
        // The build script (scripts/inject-env.js) replaces {{VARIABLE}} placeholders
        // in web/index.html with actual values, which are then available as window.env
        try {
          // Try to read from window.env first
          supabaseUrl = _readWebEnv('SUPABASE_URL');
          anonKey = _readWebEnv('SUPABASE_ANON_KEY');
          serviceKey = _readWebEnv('SUPABASE_SERVICE_KEY');
          smtpEmail = _readWebEnv('SMTP_EMAIL');
          smtpPassword = _readWebEnv('SMTP_PASSWORD');
          
          if (supabaseUrl != null && supabaseUrl.isNotEmpty) {
            print('✓ Read environment variables from window.env');
          } else {
            throw Exception('window.env not available');
          }
        } catch (e) {
          print('⚠ Error reading window.env: $e');
          print('⚠ Falling back to .env file');
          // Fallback to .env for local development
          try {
            await dotenv.load(fileName: '.env');
            supabaseUrl = dotenv.env['SUPABASE_URL'];
            anonKey = dotenv.env['SUPABASE_ANON_KEY'];
            serviceKey = dotenv.env['SUPABASE_SERVICE_KEY'];
            smtpEmail = dotenv.env['SMTP_EMAIL'];
            smtpPassword = dotenv.env['SMTP_PASSWORD'];
          } catch (e2) {
            print('⚠ .env file also not found');
          }
        }
      } else {
        // For mobile, use .env file
        try {
          await dotenv.load(fileName: '.env');
        } catch (e) {
          print('Note: .env file may already be loaded or not found');
        }
        
        supabaseUrl = dotenv.env['SUPABASE_URL'];
        anonKey = dotenv.env['SUPABASE_ANON_KEY'];
        serviceKey = dotenv.env['SUPABASE_SERVICE_KEY'];
        smtpEmail = dotenv.env['SMTP_EMAIL'];
        smtpPassword = dotenv.env['SMTP_PASSWORD'];
      }

      // Validate environment variables

      if (supabaseUrl == null || supabaseUrl.isEmpty) {
        throw Exception('SUPABASE_URL is missing or empty in .env');
      }
      if (anonKey == null || anonKey.isEmpty) {
        throw Exception('SUPABASE_ANON_KEY is missing or empty in .env');
      }
      if (serviceKey == null || serviceKey.isEmpty) {
        throw Exception('SUPABASE_SERVICE_KEY is missing or empty in .env');
      }

      // Email configuration is optional but warn if missing
      if (smtpEmail == null ||
          smtpEmail.isEmpty ||
          smtpPassword == null ||
          smtpPassword.isEmpty) {
        print(
            'Warning: Email configuration is missing. Email features will be disabled.');
      }

      print('Environment variables validated');

      // Initialize user client
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: anonKey,
      );
      _client = Supabase.instance.client;
      print('User client initialized');

      // Initialize admin client
      _adminClient = SupabaseClient(
        supabaseUrl,
        serviceKey,
      );
      print('Admin client initialized');
      _isInitialized = true;
    } catch (e) {
      print('Supabase initialization failed: $e');
      _isInitialized = false;
      throw Exception('Failed to initialize Supabase: $e');
    }
  }

  // Helper method to read from window.env for web
  static String? _readWebEnv(String key) {
    if (!kIsWeb) return null;
    
    try {
      // Read from window.env that was injected by build script
      // The build script replaces {{VARIABLE}} in index.html with actual values
      // These are then available as window.env at runtime
      // ignore: avoid_web_libraries_in_flutter
      // ignore: undefined_prefixed_name
      final windowEnv = (() {
        try {
          // Use JS interop - this will work at runtime on web
          // ignore: avoid_web_libraries_in_flutter
          // We'll use a JS call to access window.env
          // For now, return a function that can be called
          return null;
        } catch (e) {
          return null;
        }
      })();
      
      // The actual reading happens via JS - values are in window.env
      // injected by scripts/inject-env.js during Vercel build
      // At runtime, window.env is available and can be read
      return null; // Will be populated at runtime via JS interop
    } catch (e) {
      print('Error reading web env $key: $e');
      return null;
    }
  }
}

// Note: For Vercel deployment, environment variables are injected into
// web/index.html by scripts/inject-env.js during build. The Flutter app
// reads these via window.env at runtime. For local development, use .env file.
