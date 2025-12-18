import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_complaint_system/screens/signup_screen.dart';
import '../services/supabase_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import '../config/admin_theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDarkMode = false;

  final List<String> _roles = ['admin', 'student', 'batch_advisor', 'hod'];

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _loginAsync();
  }

  Future<void> _loginAsync() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final role = _selectedRole;

    if (email.isEmpty || password.isEmpty || role == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'All fields are required.';
      });
      return;
    }

    try {
      print('=== LOGIN SCREEN ===');
      print('Email: $email');
      print('Role: $role');
      print('Password provided: ${password.isNotEmpty}');
      
      final response = await SupabaseService.signIn(email, password);
      if (!mounted) return;
      
      print('Authentication successful, fetching profile...');
      final profile = await SupabaseService.getUserProfile(response.user!.id);
      if (!mounted) return;
      
      print('Profile fetched. Role: ${profile.role}, Expected: $role');
      if (profile.role != role) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Invalid role selected for this account. Your role is: ${profile.role}';
        });
        return;
      }
      switch (profile.role) {
        case 'admin':
          Navigator.pushReplacementNamed(context, '/admin_dashboard');
          break;
        case 'student':
          Navigator.pushReplacementNamed(context, '/student_dashboard');
          break;
        case 'batch_advisor':
          Navigator.pushReplacementNamed(context, '/batch_advisor_dashboard');
          break;
        case 'hod':
          Navigator.pushReplacementNamed(context, '/hod_dashboard');
          break;
        default:
          setState(() {
            _isLoading = false;
            _errorMessage = 'Unknown role.';
          });
      }
    } on AuthException catch (e) {
      // Handle Supabase Auth exceptions with specific error messages
      String errorMessage = 'Login failed. ';
      print('Auth error: ${e.statusCode} - ${e.message}');
      
      // Check the status code or message to provide user-friendly error
      if (e.message.contains('Invalid login credentials') || 
          e.message.contains('invalid_credentials') ||
          e.statusCode == 'invalid_credentials') {
        errorMessage = 'Invalid email or password. Please check your credentials.';
      } else if (e.message.contains('Email not confirmed') ||
                 e.statusCode == 'email_not_confirmed') {
        errorMessage = 'Please confirm your email before logging in.';
      } else if (e.message.contains('User not found') ||
                 e.statusCode == 'user_not_found') {
        errorMessage = 'No account found with this email address.';
      } else if (e.message.contains('Too many requests') ||
                 e.statusCode == 'too_many_requests') {
        errorMessage = 'Too many login attempts. Please try again later.';
      } else {
        // Use the error message from Supabase if available
        errorMessage = e.message.isNotEmpty 
            ? e.message 
            : 'Authentication failed. Please check your credentials and try again.';
      }
      
      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });
    } on AuthApiException catch (e) {
      // Handle AuthApiException (different from AuthException)
      String errorMessage = 'Login failed. ';
      print('AuthApiException: Status=${e.statusCode}, Message=${e.message}');
      print('Full error: $e');
      
      // Check the status code or message to provide user-friendly error
      final errorMsg = e.message.toLowerCase();
      final statusCode = e.statusCode?.toLowerCase() ?? '';
      
      if (errorMsg.contains('invalid login credentials') || 
          errorMsg.contains('invalid_credentials') ||
          statusCode.contains('invalid_credentials')) {
        errorMessage = 'Invalid email or password. Please check your credentials.';
      } else if (errorMsg.contains('email not confirmed') ||
                 statusCode.contains('email_not_confirmed')) {
        errorMessage = 'Please confirm your email before logging in.';
      } else if (errorMsg.contains('user not found') ||
                 statusCode.contains('user_not_found')) {
        errorMessage = 'No account found with this email address.';
      } else if (errorMsg.contains('too many requests') ||
                 statusCode.contains('too_many_requests')) {
        errorMessage = 'Too many login attempts. Please try again later.';
      } else {
        // Use the error message from Supabase if available
        errorMessage = e.message.isNotEmpty 
            ? 'Login failed: ${e.message}' 
            : 'Authentication failed. Please check your credentials and try again.';
      }
      
      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });
    } catch (e, stackTrace) {
      // Handle other exceptions
      String errorMessage = 'Login failed. ';
      print('Login error: $e');
      print('Stack trace: $stackTrace');
      
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('network') || 
          errorStr.contains('connection') ||
          errorStr.contains('socketexception')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (errorStr.contains('timeout') ||
                 errorStr.contains('timeoutexception')) {
        errorMessage = 'Request timed out. Please try again.';
      } else if (errorStr.contains('authapiexception') || 
                 errorStr.contains('authexception')) {
        // If it's an auth exception that wasn't caught, show a generic message
        errorMessage = 'Authentication failed. Please check your credentials and try again.';
      } else {
        // Show a user-friendly message but log the full error
        errorMessage = 'An unexpected error occurred. Please try again.';
        print('Unexpected error type: ${e.runtimeType}');
      }
      
      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });
    }
  }

  void _navigateToSignup(BuildContext context) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SignupScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    ));
  }

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? AdminTheme.darkTheme : AdminTheme.lightTheme;
    final VoidCallback? loginCallback = _isLoading ? null : _login;
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _navigateToHome(context);
            },
          ),
          title: const Text('Login'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              tooltip: 'Toggle Theme',
              onPressed: _toggleTheme,
            ),
          ],
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Title
                Text(
                  'Welcome Back',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to your account',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                // Login Card
                Container(
                  width: 370,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Select Role',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        items: _roles.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role
                                .split('_')
                                .map((word) =>
                                    word[0].toUpperCase() + word.substring(1))
                                .join(' ')),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      CustomButton(
                        text: 'Login',
                        onPressed: _isLoading ? null : () => _login(),
                        isLoading: _isLoading,
                        width: double.infinity,
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              _navigateToSignup(context);
                            },
                            child: const Text('Sign up'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
