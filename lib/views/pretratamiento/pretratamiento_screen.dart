import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PretratamientoScreen extends StatelessWidget {
  final Map<String, dynamic>? datosAnalisis;

  const PretratamientoScreen({
    super.key,
    this.datosAnalisis,
  });

  // Método para validar datos recibidos
  bool get _hasValidData {
    return datosAnalisis != null && datosAnalisis!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pretratamiento'),
        backgroundColor: AppColors.primary,
      ),
      body: _buildContent(),
    );
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
              // Mostrar datos o mensaje de no datos
              if (_hasValidData) 
                _buildDatosRecibidos(isMobile, isTablet)
              else
                _buildNoDataMessage(isMobile),
              
              // Contenido principal del módulo
              _buildMainContent(isMobile, isTablet),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoDataMessage(bool isMobile) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          children: [
            Icon(
              Icons.warning_amber,
              size: 48,
              color: AppColors.warning,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              'No hay datos de análisis',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              'Realice un análisis primero para ver los datos aquí',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
}