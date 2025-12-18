import 'dart:js' as js;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Web-specific configuration that reads from window.env
class SupabaseConfigWeb {
  static late SupabaseClient _client;
  static late SupabaseClient _adminClient;
  static bool _isInitialized = false;

  static SupabaseClient get client => _client;
  static SupabaseClient get adminClient => _adminClient;
  static bool get isInitialized => _isInitialized;

  static String? _getEnvVar(String key) {
    try {
      final windowEnv = js.context['env'];
      if (windowEnv != null) {
        final value = js.context.callMethod('[]', [key]);
        return value?.toString();
      }
    } catch (e) {
      print('Error reading env var $key: $e');
    }
    return null;
  }

  static Future<void> initialize() async {
    try {
      print('Starting Supabase initialization (Web)...');

      // Read from window.env (injected by Vercel)
      final supabaseUrl = _getEnvVar('SUPABASE_URL');
      final anonKey = _getEnvVar('SUPABASE_ANON_KEY');
      final serviceKey = _getEnvVar('SUPABASE_SERVICE_KEY');
      final smtpEmail = _getEnvVar('SMTP_EMAIL');
      final smtpPassword = _getEnvVar('SMTP_PASSWORD');

      if (supabaseUrl == null || supabaseUrl.isEmpty) {
        throw Exception('SUPABASE_URL is missing. Set it in Vercel environment variables.');
      }
      if (anonKey == null || anonKey.isEmpty) {
        throw Exception('SUPABASE_ANON_KEY is missing. Set it in Vercel environment variables.');
      }
      if (serviceKey == null || serviceKey.isEmpty) {
        throw Exception('SUPABASE_SERVICE_KEY is missing. Set it in Vercel environment variables.');
      }

      // Email configuration is optional
      if (smtpEmail == null || smtpEmail.isEmpty || smtpPassword == null || smtpPassword.isEmpty) {
        print('Warning: Email configuration is missing. Email features will be disabled.');
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
}

