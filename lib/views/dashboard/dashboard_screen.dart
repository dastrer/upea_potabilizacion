import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import '../../../utils/constants.dart';

// Importar todas las views
import '../analisis/analisis_screen.dart';
import '../pretratamiento/pretratamiento_screen.dart';
import '../postratamiento/postratamiento_screen.dart';
import '../inicio/inicio_screen.dart';
import '../resultados/resultados_screen.dart';
import '../fundamentos/fundamentos_screen.dart';
import '../soporte/soporte_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardVM = Provider.of<DashboardViewModel>(context);

    final List<Widget> pages = [
      const AnalisisScreen(),           // 0 - Análisis de Calidad
      PretratamientoScreen(             // 1 - Condiciones Iniciales  
    datosAnalisis: dashboardVM.datosPretratamiento,
  ),     // 1 - Condiciones Iniciales  
      const PostratamientoScreen(),     // 2 - Tratamiento de Pureza
      const InicioScreen(),             // 3 - Panel Principal
      const ResultadosScreen(),         // 4 - Resultados y Reportes
      const FundamentosScreen(),        // 5 - Base Científica y Referencias
      const SoporteScreen(),            // 6 - Guía y Asistencia
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
      drawer: _buildDrawer(context, dashboardVM),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.backgroundVariant],
          ),
        ),
        child: pages[dashboardVM.selectedIndex],
      ),
      bottomNavigationBar: _buildResponsiveBottomNavigationBar(
        dashboardVM,
        context,
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, DashboardViewModel dashboardVM) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              accountName: Text(
                "Usuario Ejemplo",
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text(
                "usuario@correo.com",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.8),
                ),
              ),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.textOnPrimary,
                    width: 2,
                  ),
                  gradient: AppColors.secondaryGradient,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.person, 
                    size: 40, 
                    color: AppColors.textOnPrimary
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDrawerItem(context, Icons.dashboard, "Panel Principal", 3, dashboardVM, AppColors.primary),
                    _buildDrawerItem(
                      context,
                      Icons.analytics,
                      "Análisis de Calidad",
                      0,
                      dashboardVM,
                      AppColors.secondary,
                    ),
                    _buildDrawerItem(
                      context,
                      Icons.settings_input_component,
                      "Condiciones Iniciales",
                      1,
                      dashboardVM,
                      AppColors.secondaryLight,
                    ),
                    _buildDrawerItem(
                      context,
                      Icons.verified_user,
                      "Tratamiento de Pureza",
                      2,
                      dashboardVM,
                      AppColors.accent,
                    ),
                    _buildDrawerItem(
                      context,
                      Icons.assignment_turned_in,
                      "Resultados y Reportes",
                      4,
                      dashboardVM,
                      AppColors.info,
                    ),
                    _buildDrawerItem(
                      context,
                      Icons.science,
                      "Base Científica y Referencias",
                      5,
                      dashboardVM,
                      AppColors.accentLight,
                    ),
                    _buildDrawerItem(
                      context,
                      Icons.help_center,
                      "Guía y Asistencia",
                      6,
                      dashboardVM,
                      AppColors.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: AppColors.surface,
            child: Column(
              children: [
                const Divider(height: 1, color: AppColors.border),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Icon(Icons.logout, color: AppColors.error),
                  ),
                  title: Text(
                    AppStrings.logout,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    // TODO: Implementar logout
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    DashboardViewModel dashboardVM,
    Color color,
  ) {
    final bool isSelected = dashboardVM.selectedIndex == index;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : color,
          size: 20,
        ),
      ),
      title: Text(
        label,
        style: AppTextStyles.body.copyWith(
          color: isSelected ? color : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: color.withOpacity(0.05),
      onTap: () {
        dashboardVM.changeIndex(index);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildResponsiveBottomNavigationBar(
    DashboardViewModel dashboardVM,
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return _buildMobileBottomNavigationBar(dashboardVM, context);
    } else if (screenWidth < 1200) {
      return _buildTabletBottomNavigationBar(dashboardVM, context);
    } else {
      return _buildDesktopBottomNavigationBar(dashboardVM, context);
    }
  }

  Widget _buildMobileBottomNavigationBar(
    DashboardViewModel dashboardVM,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.medium,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavItem(Icons.analytics, "Análisis Calidad", 0, dashboardVM, AppColors.secondary, isMobile: true),
              _buildNavItem(Icons.settings_input_component, "Condiciones", 1, dashboardVM, AppColors.secondaryLight, isMobile: true),
              _buildNavItem(Icons.verified_user, "Tratamiento", 2, dashboardVM, AppColors.accent, isMobile: true),
              _buildNavItemInicio(dashboardVM, isMobile: true),
              _buildNavItem(Icons.assignment_turned_in, "Resultados", 4, dashboardVM, AppColors.info, isMobile: true),
              _buildNavItem(Icons.science, "Base Cient.", 5, dashboardVM, AppColors.accentLight, isMobile: true),
              _buildNavItem(Icons.help_center, "Soporte", 6, dashboardVM, AppColors.secondary, isMobile: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletBottomNavigationBar(
    DashboardViewModel dashboardVM,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.medium,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.analytics, "Análisis\nCalidad", 0, dashboardVM, AppColors.secondary, isTablet: true),
                    _buildNavItem(Icons.settings_input_component, "Condiciones\nIniciales", 1, dashboardVM, AppColors.secondaryLight, isTablet: true),
                    _buildNavItem(Icons.verified_user, "Tratamiento", 2, dashboardVM, AppColors.accent, isTablet: true),
                  ],
                ),
              ),
              _buildNavItemInicio(dashboardVM, isTablet: true),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.assignment_turned_in, "Resultados", 4, dashboardVM, AppColors.info, isTablet: true),
                    _buildNavItem(Icons.science, "Base\nCientífica", 5, dashboardVM, AppColors.accentLight, isTablet: true),
                    _buildNavItem(Icons.help_center, "Soporte", 6, dashboardVM, AppColors.secondary, isTablet: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopBottomNavigationBar(
    DashboardViewModel dashboardVM,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.medium,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(Icons.analytics, "Análisis de Calidad", 0, dashboardVM, AppColors.secondary, isDesktop: true),
                    _buildNavItem(Icons.settings_input_component, "Condiciones Iniciales", 1, dashboardVM, AppColors.secondaryLight, isDesktop: true),
                    _buildNavItem(Icons.verified_user, "Tratamiento", 2, dashboardVM, AppColors.accent, isDesktop: true),
                  ],
                ),
              ),
              _buildNavItemInicio(dashboardVM, isDesktop: true),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(Icons.assignment_turned_in, "Resultados", 4, dashboardVM, AppColors.info, isDesktop: true),
                    _buildNavItem(Icons.science, "Base Científica", 5, dashboardVM, AppColors.accentLight, isDesktop: true),
                    _buildNavItem(Icons.help_center, "Soporte", 6, dashboardVM, AppColors.secondary, isDesktop: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    DashboardViewModel dashboardVM,
    Color color, {
    bool isMobile = false,
    bool isTablet = false,
    bool isDesktop = false,
  }) {
    final bool isSelected = dashboardVM.selectedIndex == index;

    return MaterialButton(
      minWidth: isMobile ? 40 : isTablet ? 60 : 80,
      onPressed: () => dashboardVM.changeIndex(index),
      padding: const EdgeInsets.all(AppSpacing.small),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isSelected ? color : color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: isMobile ? 16 : isTablet ? 20 : 24,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? color : AppColors.textSecondary,
                fontSize: isMobile ? 10 : isTablet ? 11 : 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: isTablet ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItemInicio(
    DashboardViewModel dashboardVM, {
    bool isMobile = false,
    bool isTablet = false,
    bool isDesktop = false,
  }) {
    final bool isSelected = dashboardVM.selectedIndex == 3;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? AppSpacing.medium : AppSpacing.large,
      ),
      child: GestureDetector(
        onTap: () => dashboardVM.changeIndex(3),
        child: Container(
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : AppColors.secondaryGradient,
            shape: BoxShape.circle,
            boxShadow: AppShadows.small,
          ),
          width: isMobile ? 56 : isTablet ? 64 : 72,
          height: isMobile ? 56 : isTablet ? 64 : 72,
          child: Icon(
            Icons.dashboard,
            color: Colors.white,
            size: isMobile ? 24 : isTablet ? 28 : 32,
          ),
        ),
      ),
    );
  }
}