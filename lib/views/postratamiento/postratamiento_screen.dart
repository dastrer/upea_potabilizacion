import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PostratamientoScreen extends StatelessWidget {
  const PostratamientoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildModuleScreen(
      "Postratamiento",
      Icons.assignment_turned_in,
      AppColors.accent,
      "Módulo de resultados y reportes post-procesamiento",
    );
  }

  Widget _buildModuleScreen(String title, IconData icon, Color color, String description) {
    // Mismo patrón que los anteriores...
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.background, AppColors.backgroundVariant],
        ),
      ),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(AppSpacing.large),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, AppColors.backgroundVariant],
              ),
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxLarge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 64,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading1.copyWith(
                      color: color,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    "En Construcción",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Container(
                    margin: const EdgeInsets.only(top: AppSpacing.medium),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.large,
                      vertical: AppSpacing.small,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.round),
                    ),
                    child: Text(
                      "Próximamente",
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}