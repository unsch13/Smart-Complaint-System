import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _progressController;
  late Animation<double> _iconAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _iconController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    );

    _iconAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _iconController.repeat(reverse: true);
    _progressController.forward();

    // Navigate to home screen after 7 seconds
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) {
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: Curves.easeInOut),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 800),
    ));
  }

  @override
  void dispose() {
    _iconController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('🔄 Building LoadingScreen...');
    try {
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;

      return Scaffold(
          body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      theme.colorScheme.surfaceVariant,
                      theme.colorScheme.tertiaryContainer,
                    ]
                  : [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.surfaceVariant,
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Icon
                AnimatedBuilder(
                  animation: _iconAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (_iconAnimation.value * 0.4),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? theme.colorScheme.tertiaryContainer
                              : theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.verified_user_rounded,
                          size: 80,
                          color: isDarkMode
                              ? theme.colorScheme.onTertiaryContainer
                              : theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                // App Title
                Text(
                  'Smart Complaint System',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? theme.colorScheme.onTertiaryContainer
                        : theme.colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Empowering University Communities',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDarkMode
                        ? theme.colorScheme.onTertiaryContainer.withOpacity(0.8)
                        : theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // Progress Bar
                Container(
                  width: 200,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? theme.colorScheme.onTertiaryContainer.withOpacity(0.2)
                        : theme.colorScheme.onPrimaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _progressAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Loading Text
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Text(
                      'Loading... ${(_progressAnimation.value * 100).toInt()}%',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? theme.colorScheme.onTertiaryContainer
                                .withOpacity(0.7)
                            : theme.colorScheme.onPrimaryContainer
                                .withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                // Features Preview
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? theme.colorScheme.surface.withOpacity(0.3)
                        : theme.colorScheme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode
                          ? theme.colorScheme.outline.withOpacity(0.2)
                          : theme.colorScheme.outline.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'System Features',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? theme.colorScheme.onTertiaryContainer
                              : theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _FeatureItem(
                            icon: Icons.security,
                            label: 'Secure',
                            theme: theme,
                            isDarkMode: isDarkMode,
                          ),
                          _FeatureItem(
                            icon: Icons.speed,
                            label: 'Fast',
                            theme: theme,
                            isDarkMode: isDarkMode,
                          ),
                          _FeatureItem(
                            icon: Icons.people,
                            label: 'User-Friendly',
                            theme: theme,
                            isDarkMode: isDarkMode,
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
      );
    } catch (e, stackTrace) {
      print('❌ Error building LoadingScreen: $e');
      print('Stack trace: $stackTrace');
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Loading Screen Error',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('$e'),
            ],
          ),
        ),
      );
    }
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;
  final bool isDarkMode;

  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.theme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: isDarkMode
              ? theme.colorScheme.onTertiaryContainer
              : theme.colorScheme.onPrimaryContainer,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDarkMode
                ? theme.colorScheme.onTertiaryContainer.withOpacity(0.8)
                : theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
