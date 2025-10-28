import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';

class PretratamientoScreen extends StatefulWidget {
  final Map<String, dynamic>? datosAnalisis;

  const PretratamientoScreen({
    super.key,
    this.datosAnalisis,
  });

  @override
  State<PretratamientoScreen> createState() => _PretratamientoScreenState();
}

class _PretratamientoScreenState extends State<PretratamientoScreen> {
  // Controladores para los nuevos inputs
  final TextEditingController _voltajeController = TextEditingController();
  final TextEditingController _volumenController = TextEditingController();

  // Variables para resultados calculados
  double _corrienteSimulada = 0.0;
  double _masaContaminante = 0.0;
  double _cargaRequerida = 0.0;
  double _tiempoTratamientoSegundos = 0.0;
  bool _calculosRealizados = false;

  // Método para validar datos recibidos
  bool get _hasValidData {
    return widget.datosAnalisis != null && widget.datosAnalisis!.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    // Establecer valores por defecto
    _voltajeController.text = '12.0';
    _volumenController.text = '5.0';
    _cargarCalculosExistentes();
  }

  void _cargarCalculosExistentes() {
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
    final datosCalculados = dashboardVM.datosTratamientoCalculado;
    
    if (datosCalculados != null && datosCalculados.isNotEmpty) {
      setState(() {
        _corrienteSimulada = _getDoubleValue(datosCalculados['corrienteSimulada']);
        _masaContaminante = _getDoubleValue(datosCalculados['masaContaminante']);
        _cargaRequerida = _getDoubleValue(datosCalculados['cargaRequerida']);
        _tiempoTratamientoSegundos = _getDoubleValue(datosCalculados['tiempoTratamientoSegundos']);
        _calculosRealizados = true;
      });
      
      // También cargar los valores de entrada si están disponibles
      if (datosCalculados.containsKey('voltajeDiseño')) {
        _voltajeController.text = datosCalculados['voltajeDiseño'].toString();
      }
      if (datosCalculados.containsKey('volumenAgua')) {
        _volumenController.text = datosCalculados['volumenAgua'].toString();
      }
    }
  }

  // ========== SECCIÓN ORIGINAL (SIN MODIFICAR) ==========
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
                  '${_getDoubleValue(widget.datosAnalisis!['tdsPpm']).toStringAsFixed(2)} ppm',
                  AppColors.success,
                  Icons.water_drop,
                ),
                _buildDataCard(
                  'Conductividad (25°C)',
                  '${_getDoubleValue(widget.datosAnalisis!['kappa25']).toStringAsFixed(2)} µS/cm',
                  AppColors.secondary,
                  Icons.speed,
                ),
                _buildDataCard(
                  'pH',
                  '${_getDoubleValue(widget.datosAnalisis!['ph']).toStringAsFixed(1)}',
                  AppColors.accent,
                  Icons.science,
                ),
                _buildDataCard(
                  'Temperatura',
                  '${_getDoubleValue(widget.datosAnalisis!['temperatura']).toStringAsFixed(1)} °C',
                  AppColors.warning,
                  Icons.thermostat,
                ),
                if (!isMobile) _buildDataCard(
                  'Constante de Celda',
                  '${_getDoubleValue(widget.datosAnalisis!['kCell']).toStringAsFixed(4)} cm⁻¹',
                  AppColors.primary,
                  Icons.straighten,
                ),
                if (!isMobile) _buildDataCard(
                  'Conductividad (T)',
                  '${_getDoubleValue(widget.datosAnalisis!['kappaT']).toStringAsFixed(2)} µS/cm',
                  AppColors.info,
                  Icons.electrical_services,
                ),
              ],
            ),
            
            if (isMobile) ...[
              const SizedBox(height: AppSpacing.medium),
              Column(
                children: [
                  _buildMobileDataItem('Constante de Celda', '${_getDoubleValue(widget.datosAnalisis!['kCell']).toStringAsFixed(4)} cm⁻¹'),
                  _buildMobileDataItem('Conductividad (T)', '${_getDoubleValue(widget.datosAnalisis!['kappaT']).toStringAsFixed(2)} µS/cm'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pretratamiento'),
        backgroundColor: AppColors.primary,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
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
              // Mostrar datos recibidos del análisis (SIN MODIFICAR)
              if (_hasValidData) 
                _buildDatosRecibidos(isMobile, isTablet)
              else
                _buildNoDataMessage(isMobile),
              
              const SizedBox(height: AppSpacing.large),
              
              // FLUJO COMPLETO DE PRETRATAMIENTO
              _buildFlujoPretratamiento(context, isMobile, isTablet),
            ],
          ),
        );
      },
    );
  }

  // ========== NUEVO FLUJO DE PRETRATAMIENTO ==========
  Widget _buildFlujoPretratamiento(BuildContext context, bool isMobile, bool isTablet) {
    return Column(
      children: [
        // Paso 2: Diagnóstico de Cumplimiento OMS
        _buildDiagnosticoOMS(isMobile),
        
        const SizedBox(height: AppSpacing.large),
        
        // Paso 3: Entrada de Parámetros de Diseño
        _buildParametrosDiseno(context, isMobile),
        
        const SizedBox(height: AppSpacing.large),
        
        // Pasos 4-8: Cálculos y Resultados
        if (_calculosRealizados) _buildCalculosResultados(isMobile),
      ],
    );
  }

  Widget _buildDiagnosticoOMS(bool isMobile) {
    final double tds = _getDoubleValue(widget.datosAnalisis?['tdsPpm']);
    final double ph = _getDoubleValue(widget.datosAnalisis?['ph']);
    
    final bool phOptimo = ph >= 6.0 && ph <= 8.5;
    final bool tdsCumple = tds < 1000;
    final String nivelContaminacion = _evaluarNivelContaminacion(tds);
    
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
            Row(
              children: [
                Icon(Icons.medical_services, color: AppColors.warning, size: 20),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    isMobile 
                        ? 'Diagnóstico OMS\nEstándares de Calidad'
                        : 'Diagnóstico OMS - Estándares de Calidad',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.warning,
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            
            // Indicadores de cumplimiento
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isMobile ? 1 : 2,
              crossAxisSpacing: AppSpacing.medium,
              mainAxisSpacing: AppSpacing.medium,
              childAspectRatio: isMobile ? 1.5 : 2.0,
              children: [
                _buildIndicadorOMS(
                  'Nivel de pH',
                  ph.toStringAsFixed(1),
                  phOptimo ? 'ÓPTIMO' : 'FUERA DE RANGO',
                  phOptimo ? AppColors.success : AppColors.error,
                  Icons.phishing,
                ),
                _buildIndicadorOMS(
                  'TDS Total',
                  '${tds.toStringAsFixed(2)} ppm',
                  tdsCumple ? 'CUMPLE OMS' : 'EXCEDE LÍMITE',
                  tdsCumple ? AppColors.success : AppColors.error,
                  Icons.water_drop,
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.medium),
            
            // Información detallada
            Container(
              padding: const EdgeInsets.all(AppSpacing.medium),
              decoration: BoxDecoration(
                color: AppColors.backgroundVariant,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluación de Condiciones:',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    '• pH ${phOptimo ? 'dentro del rango óptimo (6.0-8.5)' : 'fuera del rango recomendado'}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: phOptimo ? AppColors.success : AppColors.error,
                    ),
                  ),
                  Text(
                    '• TDS ${tdsCumple ? 'cumple con estándares OMS (<1000 ppm)' : 'excede el límite OMS de 1000 ppm'}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: tdsCumple ? AppColors.success : AppColors.error,
                    ),
                  ),
                  Text(
                    '• Nivel de contaminación: $nivelContaminacion',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParametrosDiseno(BuildContext context, bool isMobile) {
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
            Row(
              children: [
                Icon(Icons.design_services, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    isMobile 
                        ? 'Parámetros de Diseño\nDel Tratamiento'
                        : 'Parámetros de Diseño del Tratamiento',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            
            Text(
              'Configure los parámetros para simular el tratamiento electroquímico:',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: AppSpacing.medium),
            
            // Inputs de parámetros
            _buildInputField(
              label: 'Voltaje de Diseño (V_diseño)',
              hintText: 'Ingrese el voltaje',
              controller: _voltajeController,
              unidad: 'V',
              icon: Icons.bolt,
            ),
            
            _buildInputField(
              label: 'Volumen de Agua (V_agua)',
              hintText: 'Ingrese el volumen',
              controller: _volumenController,
              unidad: 'L',
              icon: Icons.water,
            ),
            
            const SizedBox(height: AppSpacing.medium),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _calcularTratamiento(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
                child: Text(
                  'Calcular Tratamiento',
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculosResultados(bool isMobile) {
    String tiempoFormateado = _formatearTiempoCompleto(_tiempoTratamientoSegundos);
    
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
            Row(
              children: [
                Icon(Icons.calculate, color: AppColors.accent, size: 20),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    isMobile 
                        ? 'Resultados del\nTratamiento'
                        : 'Resultados del Tratamiento',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.accent,
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            
            // Grid de resultados calculados
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: _getCrossAxisCount(isMobile, false),
              crossAxisSpacing: AppSpacing.medium,
              mainAxisSpacing: AppSpacing.medium,
              childAspectRatio: _getAspectRatio(isMobile, false),
              children: [
                _buildResultadoCalculado(
                  'Corriente Simulada',
                  '${_corrienteSimulada.toStringAsFixed(4)} A', // 4 decimales
                  'I = V(diseño) / R',
                  AppColors.secondary,
                  Icons.electrical_services,
                ),
                _buildResultadoCalculado(
                  'Masa Contaminante',
                  '${_masaContaminante.toStringAsFixed(7)} kg',
                  'm = TDS × Vagua × 10⁻⁶',
                  AppColors.warning,
                  Icons.scale,
                ),
                _buildResultadoCalculado(
                  'Carga Requerida',
                  '${_cargaRequerida.toStringAsFixed(2)} C',
                  'Q = (m × F × n) / M',
                  AppColors.info,
                  Icons.battery_charging_full,
                ),
                _buildResultadoCalculado(
                  'Tiempo Tratamiento',
                  tiempoFormateado, // Formato hh:mm:ss
                  't = Q / I(simulada)',
                  AppColors.success,
                  Icons.timer,
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.large),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _iniciarTratamiento(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 20),
                    const SizedBox(width: AppSpacing.small),
                    Text(
                      'Iniciar Tratamiento',
                      style: AppTextStyles.button,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== WIDGETS AUXILIARES NUEVOS ==========
  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required String unidad,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.small,
            ),
            child: Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.medium),
                    child: Icon(icon, color: AppColors.textSecondary, size: 20),
                  ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.medium,
                        vertical: AppSpacing.medium,
                      ),
                    ),
                    style: AppTextStyles.body,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium,
                    vertical: AppSpacing.small,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundVariant,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(AppRadius.medium),
                    ),
                  ),
                  child: Text(
                    unidad,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicadorOMS(String titulo, String valor, String estado, Color color, IconData icon) {
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

  Widget _buildResultadoCalculado(String titulo, String valor, String formula, Color color, IconData icon) {
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
          const SizedBox(height: AppSpacing.small),
          Text(
            formula,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textDisabled,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ========== MÉTODOS DE LÓGICA ==========
  void _calcularTratamiento(BuildContext context) {
    // 1. Obtención y Conversión de Inputs
    final double voltaje = double.tryParse(_voltajeController.text) ?? 0.0;
    final double volumen = double.tryParse(_volumenController.text) ?? 0.0;
    final double tds = _getDoubleValue(widget.datosAnalisis?['tdsPpm']) ?? 0.0;
    // R: Convertir de kΩ a Ω (5 kΩ = 5000 Ω)
    final double resistencia = _getDoubleValue(widget.datosAnalisis?['resistencia']) * 1000; 

    if (voltaje <= 0 || volumen <= 0 || resistencia <= 0 || tds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingrese valores válidos para todos los parámetros de diseño y verifique el Análisis.', style: AppTextStyles.body),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Paso 4 (Ecuación 5): I_simulada = V_diseño / R
    _corrienteSimulada = voltaje / resistencia;

    // Paso 5 (Ecuación 6): m_contaminante (en kg) = TDS_ppm (mg/L) × V_agua (L) × 10⁻⁶ (kg/mg)
    _masaContaminante = tds * volumen * 0.000001; // Resultado en kg

    // Paso 6 (Ecuación 7 - Ley de Faraday): Q = (m_contaminante × F × n) / M
    const double F = 96485.0; // Constante de Faraday (C/mol)
    const double n = 3.0;     // Electrones por mol (Al³⁺)
    // CRÍTICO: Masa molar del Aluminio (kg/mol) para ser compatible con m_contaminante (kg)
    const double M = 0.02698; // 26.98 g/mol convertido a kg/mol
    
    _cargaRequerida = (_masaContaminante * F * n) / M;

    // Paso 7 (Ecuación 8): t_segundos = Q / I_simulada
    _tiempoTratamientoSegundos = _cargaRequerida / _corrienteSimulada;

    // GUARDAR EN VIEWMODEL PARA PERSISTENCIA
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
    final datosCalculados = {
      'corrienteSimulada': _corrienteSimulada,
      'masaContaminante': _masaContaminante,
      'cargaRequerida': _cargaRequerida,
      'tiempoTratamientoSegundos': _tiempoTratamientoSegundos,
      'voltajeDiseño': voltaje,
      'volumenAgua': volumen,
      'tdsInicial': tds,
      'resistencia': resistencia,
      'fechaCalculo': DateTime.now(),
    };
    
    dashboardVM.setDatosTratamientoCalculado(datosCalculados);

    setState(() {
      _calculosRealizados = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cálculos completados exitosamente.', style: AppTextStyles.body),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _iniciarTratamiento(BuildContext context) {
  final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
  
  // Preparar datos específicos para postratamiento (solo tiempo y voltaje)
  final int horas = (_tiempoTratamientoSegundos / 3600).floor();
  final int minutos = ((_tiempoTratamientoSegundos % 3600) / 60).floor();
  final int segundos = (_tiempoTratamientoSegundos % 60).round();
  final double voltaje = double.tryParse(_voltajeController.text) ?? 0.0;

  final datosPostratamiento = {
    'tiempoHoras': horas,
    'tiempoMinutos': minutos,
    'tiempoSegundos': segundos,
    'tiempoTotalSegundos': _tiempoTratamientoSegundos,
    'voltajeTratamiento': voltaje,
    'fechaInicioTratamiento': DateTime.now(),
  };

  // Guardar en ViewModel usando el nuevo método para postratamiento
  dashboardVM.setDatosPostratamiento(datosPostratamiento);
  
  // Navegar al módulo de postratamiento
  dashboardVM.goToPostratamiento();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Iniciando tratamiento electroquímico...', style: AppTextStyles.body),
      backgroundColor: AppColors.primary,
    ),
  );
}

  String _formatearTiempoCompleto(double segundosTotales) {
    int horas = (segundosTotales / 3600).floor();
    int minutos = ((segundosTotales % 3600) / 60).floor();
    int segundos = (segundosTotales % 60).round();
    
    if (horas > 0) {
      return '${horas}h ${minutos}m ${segundos}s';
    } else if (minutos > 0) {
      return '${minutos}m ${segundos}s';
    } else {
      return '${segundos}s';
    }
  }

  String _evaluarNivelContaminacion(double tds) {
    if (tds < 50) return 'Muy Baja';
    if (tds < 200) return 'Baja';
    if (tds < 500) return 'Moderada';
    if (tds < 1000) return 'Alta';
    return 'Muy Alta';
  }

  // ========== MÉTODOS AUXILIARES EXISTENTES ==========
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

  @override
  void dispose() {
    _voltajeController.dispose();
    _volumenController.dispose();
    super.dispose();
  }
}