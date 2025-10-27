import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PretratamientoScreen extends StatelessWidget {
  final Map<String, dynamic>? datosAnalisis;

  const PretratamientoScreen({
    super.key,
    this.datosAnalisis,
  });

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final bool isTablet = constraints.maxWidth < 1200;
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(
            isMobile ? AppSpacing.screenPadding : AppSpacing.large,
          ),
          child: Column(
            children: [
              // Header informativo
              _buildHeader(isMobile, isTablet),
              
              const SizedBox(height: AppSpacing.large),
              
              // Grid de datos recibidos
              if (datosAnalisis != null) _buildDatosRecibidos(isMobile, isTablet),
              
              // Contenido principal del módulo
              _buildMainContent(isMobile, isTablet),
              
              // Sección de próximas características
              _buildProximamenteSection(isMobile, isTablet),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isMobile, bool isTablet) {
    return Card(
      elevation: 2,
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
          padding: EdgeInsets.all(isMobile ? AppSpacing.medium : AppSpacing.large),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.medium),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.settings_input_component,
                  size: isMobile ? 40 : 48,
                  color: AppColors.secondaryLight,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pretratamiento",
                      style: isMobile 
                          ? AppTextStyles.heading2.copyWith(color: AppColors.secondaryLight)
                          : AppTextStyles.heading1.copyWith(color: AppColors.secondaryLight),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      "Módulo de condicionamiento inicial y preprocesamiento",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatosRecibidos(bool isMobile, bool isTablet) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.large),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? AppSpacing.medium : AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: AppColors.info, size: 20),
                const SizedBox(width: AppSpacing.small),
                Text(
                  'Datos Recibidos del Análisis',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            
            // Grid responsivo de datos
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: _getCrossAxisCount(isMobile, isTablet),
              crossAxisSpacing: AppSpacing.medium,
              mainAxisSpacing: AppSpacing.medium,
              childAspectRatio: _getAspectRatio(isMobile, isTablet),
              children: [
                _buildDataCard(
                  'TDS',
                  '${_getDoubleValue(datosAnalisis!['tdsPpm']).toStringAsFixed(2)} ppm',
                  AppColors.success,
                  Icons.water_drop,
                ),
                _buildDataCard(
                  'Conductividad (25°C)',
                  '${_getDoubleValue(datosAnalisis!['kappa25']).toStringAsFixed(2)} µS/cm',
                  AppColors.secondary,
                  Icons.speed,
                ),
                _buildDataCard(
                  'pH',
                  '${_getDoubleValue(datosAnalisis!['ph']).toStringAsFixed(1)}',
                  AppColors.accent,
                  Icons.science,
                ),
                _buildDataCard(
                  'Temperatura',
                  '${_getDoubleValue(datosAnalisis!['temperatura']).toStringAsFixed(1)} °C',
                  AppColors.warning,
                  Icons.thermostat,
                ),
                if (!isMobile) _buildDataCard(
                  'Constante de Celda',
                  '${_getDoubleValue(datosAnalisis!['kCell']).toStringAsFixed(4)} cm⁻¹',
                  AppColors.primary,
                  Icons.straighten,
                ),
                if (!isMobile) _buildDataCard(
                  'Conductividad (T)',
                  '${_getDoubleValue(datosAnalisis!['kappaT']).toStringAsFixed(2)} µS/cm',
                  AppColors.info,
                  Icons.electrical_services,
                ),
              ],
            ),
            
            // Mostrar datos adicionales en lista para móviles
            if (isMobile) ...[
              const SizedBox(height: AppSpacing.medium),
              Column(
                children: [
                  _buildMobileDataItem('Constante de Celda', '${_getDoubleValue(datosAnalisis!['kCell']).toStringAsFixed(4)} cm⁻¹'),
                  _buildMobileDataItem('Conductividad (T)', '${_getDoubleValue(datosAnalisis!['kappaT']).toStringAsFixed(2)} µS/cm'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile, bool isTablet) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.large),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? AppSpacing.medium : AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Análisis de Condiciones Iniciales",
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            
            // Indicadores de estado
            _buildEstadoIndicators(isMobile, isTablet),
            
            const SizedBox(height: AppSpacing.large),
            
            // Recomendaciones basadas en datos
            _buildRecomendaciones(),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoIndicators(bool isMobile, bool isTablet) {
    final tds = _getDoubleValue(datosAnalisis?['tdsPpm']);
    final ph = _getDoubleValue(datosAnalisis?['ph']);
    final conductividad = _getDoubleValue(datosAnalisis?['kappa25']);
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: _getCrossAxisCount(isMobile, isTablet),
      crossAxisSpacing: AppSpacing.medium,
      mainAxisSpacing: AppSpacing.medium,
      children: [
        _buildEstadoCard(
          'Calidad TDS',
          _evaluarTDS(tds),
          _getColorByEstado(_evaluarTDS(tds)),
          Icons.assignment_turned_in,
        ),
        _buildEstadoCard(
          'Nivel de pH',
          _evaluarPH(ph),
          _getColorByEstado(_evaluarPH(ph)),
          Icons.phishing,
        ),
        _buildEstadoCard(
          'Conductividad',
          _evaluarConductividad(conductividad),
          _getColorByEstado(_evaluarConductividad(conductividad)),
          Icons.bolt,
        ),
      ],
    );
  }

  Widget _buildRecomendaciones() {
    final tds = _getDoubleValue(datosAnalisis?['tdsPpm']);
    final ph = _getDoubleValue(datosAnalisis?['ph']);
    final conductividad = _getDoubleValue(datosAnalisis?['kappa25']);

    String recomendacion = _generarRecomendacion(tds, ph, conductividad);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.backgroundVariant,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.warning, size: 20),
              const SizedBox(width: AppSpacing.small),
              Text(
                'Recomendaciones Iniciales',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            recomendacion,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProximamenteSection(bool isMobile, bool isTablet) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.secondaryLight.withOpacity(0.1), AppColors.accent.withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? AppSpacing.medium : AppSpacing.large),
          child: Column(
            children: [
              Icon(
                Icons.construction,
                size: isMobile ? 48 : 64,
                color: AppColors.secondaryLight,
              ),
              const SizedBox(height: AppSpacing.medium),
              Text(
                "Módulo en Desarrollo",
                style: isMobile 
                    ? AppTextStyles.heading2.copyWith(color: AppColors.secondaryLight)
                    : AppTextStyles.heading1.copyWith(color: AppColors.secondaryLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                "Próximamente: Funcionalidades completas de pretratamiento",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.medium),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.large,
                  vertical: AppSpacing.small,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
                child: Text(
                  "Próximamente",
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.secondaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widgets auxiliares
  Widget _buildDataCard(String titulo, String valor, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.small),
          Text(
            titulo,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            valor,
            style: AppTextStyles.heading3.copyWith(
              color: color,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDataItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.extraSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoCard(String titulo, String estado, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.small),
          Text(
            titulo,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.small),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Text(
              estado,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares
  int _getCrossAxisCount(bool isMobile, bool isTablet) {
    if (isMobile) return 2;
    if (isTablet) return 3;
    return 4;
  }

  double _getAspectRatio(bool isMobile, bool isTablet) {
    if (isMobile) return 1.0;
    if (isTablet) return 1.2;
    return 1.4;
  }

  double _getDoubleValue(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  String _evaluarTDS(double tds) {
    if (tds < 50) return 'Excelente';
    if (tds < 200) return 'Buena';
    if (tds < 500) return 'Regular';
    return 'Mala';
  }

  String _evaluarPH(double ph) {
    if (ph >= 6.5 && ph <= 7.5) return 'Óptimo';
    if (ph >= 6.0 && ph <= 8.0) return 'Aceptable';
    return 'Ajustar';
  }

  String _evaluarConductividad(double conductividad) {
    if (conductividad < 100) return 'Baja';
    if (conductividad < 500) return 'Media';
    return 'Alta';
  }

  Color _getColorByEstado(String estado) {
    switch (estado) {
      case 'Excelente':
      case 'Óptimo':
        return AppColors.success;
      case 'Buena':
      case 'Aceptable':
      case 'Baja':
        return AppColors.info;
      case 'Regular':
      case 'Media':
        return AppColors.warning;
      case 'Mala':
      case 'Ajustar':
      case 'Alta':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _generarRecomendacion(double tds, double ph, double conductividad) {
    List<String> recomendaciones = [];

    // Recomendaciones basadas en TDS
    if (tds > 500) {
      recomendaciones.add('TDS elevado: considerar filtración por ósmosis inversa');
    } else if (tds > 200) {
      recomendaciones.add('TDS moderado: posible filtración con carbón activado');
    } else {
      recomendaciones.add('TDS dentro de rangos aceptables');
    }

    // Recomendaciones basadas en pH
    if (ph < 6.0) {
      recomendaciones.add('pH bajo: considerar corrección con carbonato de sodio');
    } else if (ph > 8.0) {
      recomendaciones.add('pH alto: considerar corrección con ácido cítrico');
    } else {
      recomendaciones.add('pH dentro de rango óptimo');
    }

    // Recomendaciones basadas en conductividad
    if (conductividad > 500) {
      recomendaciones.add('Conductividad alta: posible alto contenido de minerales');
    } else if (conductividad < 100) {
      recomendaciones.add('Conductividad baja: agua con bajo contenido mineral');
    }

    return recomendaciones.join('. ');
  }
}