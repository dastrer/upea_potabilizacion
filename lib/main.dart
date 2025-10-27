import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModels
import 'viewmodels/dashboard_viewmodel.dart';

// Utils
import 'utils/constants.dart';

// Screens
import '../views/dashboard/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
      ],
      child: MaterialApp(
        title: 'Dashboard App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            elevation: 2,
            centerTitle: true,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
        ),
        themeMode: ThemeMode.light,
        home: const DashboardScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// Widget de carga inicial
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    _controller.forward();
    
    // Navegar al dashboard después del splash
    _navigateToDashboard();
  }

  void _navigateToDashboard() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
                child: const Icon(
                  Icons.dashboard,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              Text(
                'Dashboard App',
                style: AppTextStyles.heading1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              Text(
                'Cargando módulos...',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: AppSpacing.xxLarge),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.accent.withOpacity(0.8),
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para manejar errores
class ErrorScreen extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorScreen({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.large),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.xxLarge),
              Text(
                'Oops! Algo salió mal',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.medium),
              Text(
                error,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxLarge),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxLarge,
                    vertical: AppSpacing.medium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.round),
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

// Widget para cuando no hay conexión
class NoConnectionScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NoConnectionScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.large),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off,
                  size: 64,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: AppSpacing.xxLarge),
              Text(
                'Sin conexión',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.warning,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.medium),
              Text(
                'Por favor, verifica tu conexión a internet e intenta nuevamente.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxLarge),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.wifi),
                label: const Text('Reintentar conexión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxLarge,
                    vertical: AppSpacing.medium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.round),
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