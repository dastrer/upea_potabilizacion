import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';

class AnalisisScreen extends StatefulWidget {
  const AnalisisScreen({super.key});

  @override
  State<AnalisisScreen> createState() => _AnalisisScreenState();
}

class _AnalisisScreenState extends State<AnalisisScreen> {
  // Controladores para los campos de entrada
  final TextEditingController _longitudController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _resistenciaController = TextEditingController();
  final TextEditingController _temperaturaController = TextEditingController();
  final TextEditingController _phController = TextEditingController();

  // Variables para resultados
  double _kCell = 0.0;
  double _kappaT = 0.0;
  double _kappa25 = 0.0;
  double _tdsPpm = 0.0;
  bool _calculado = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosExistentes();
  }

  void _cargarDatosExistentes() {
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
    final datosExistentes = dashboardVM.datosPretratamiento;
    
    if (datosExistentes != null) {
      // Cargar valores de entrada si están disponibles
      if (datosExistentes.containsKey('longitud')) {
        _longitudController.text = datosExistentes['longitud'].toString();
      }
      if (datosExistentes.containsKey('area')) {
        _areaController.text = datosExistentes['area'].toString();
      }
      if (datosExistentes.containsKey('resistencia')) {
        _resistenciaController.text = datosExistentes['resistencia'].toString();
      }
      if (datosExistentes.containsKey('temperatura')) {
        _temperaturaController.text = datosExistentes['temperatura'].toString();
      }
      if (datosExistentes.containsKey('ph')) {
        _phController.text = datosExistentes['ph'].toString();
      }
      
      // Cargar resultados calculados
      setState(() {
        _kCell = _getDoubleValue(datosExistentes['kCell']);
        _kappaT = _getDoubleValue(datosExistentes['kappaT']);
        _kappa25 = _getDoubleValue(datosExistentes['kappa25']);
        _tdsPpm = _getDoubleValue(datosExistentes['tdsPpm']);
        _calculado = true;
      });
    }
  }

  void _calcularEcuaciones() {
    final double L = double.tryParse(_longitudController.text) ?? 0.0;
    final double A = double.tryParse(_areaController.text) ?? 0.0;
    final double R = double.tryParse(_resistenciaController.text) ?? 0.0;
    final double T = double.tryParse(_temperaturaController.text) ?? 0.0;
    final double pH = double.tryParse(_phController.text) ?? 0.0;

    // Ecuación 0: κ_cell = L / A
    _kCell = A > 0 ? L / A : 0.0;

    // Convertir resistencia de kΩ a Ω y calcular Ecuación 1: κ_T = k_cell / R
    final double resistenciaOhm = R * 1000; // Conversión kΩ a Ω
    _kappaT = resistenciaOhm > 0 ? _kCell / resistenciaOhm : 0.0;

    // CORRECCIÓN: Convertir de S/cm a µS/cm multiplicando por 1,000,000
    _kappaT = _kappaT * 1000000;

    // Ecuación 2: κ_25 = κ_T / [1 + 0.02(T - 25)]
    final double factorTemp = 1 + 0.02 * (T - 25);
    _kappa25 = factorTemp != 0 ? _kappaT / factorTemp : 0.0;

    // Ecuación 3: TDS_ppm = κ_25 × 0.67
    _tdsPpm = _kappa25 * 0.67;

    // Preparar datos COMPLETOS para pretratamiento (incluyendo valores de entrada)
    final datosCalculados = {
      // Valores de entrada
      'longitud': L,
      'area': A,
      'resistencia': R,
      'temperatura': T,
      'ph': pH,
      // Resultados calculados
      'kCell': _kCell,
      'kappaT': _kappaT,
      'kappa25': _kappa25,
      'tdsPpm': _tdsPpm,
    };

    // Guardar datos inmediatamente en el ViewModel
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
    dashboardVM.setDatosPretratamiento(datosCalculados);

    setState(() {
      _calculado = true;
    });
  }

  void _limpiarCampos() {
    _longitudController.clear();
    _areaController.clear();
    _resistenciaController.clear();
    _temperaturaController.clear();
    _phController.clear();
    
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
    dashboardVM.limpiarDatosPretratamiento(); // Limpiar datos del ViewModel también
    
    setState(() {
      _calculado = false;
    });
  }

  void _analizarCondicionesIniciales() {
    final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
    // Solo cambiar de página, los datos ya están guardados en el ViewModel
    dashboardVM.goToPretratamiento();
  }

  double _getDoubleValue(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

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

  Widget _buildResultCard(String titulo, String valor, String unidad, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            titulo,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            valor,
            style: AppTextStyles.heading3.copyWith(
              color: color,
              fontSize: 18,
            ),
          ),
          Text(
            unidad,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta de entrada de datos
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.input, color: AppColors.primary, size: 24),
                      const SizedBox(width: AppSpacing.small),
                      Text(
                        'Datos de Entrada',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.large),
                  
                  _buildInputField(
                    label: 'Longitud de Separación (L)',
                    hintText: 'Ingrese la longitud',
                    controller: _longitudController,
                    unidad: 'cm',
                    icon: Icons.straighten,
                  ),
                  
                  _buildInputField(
                    label: 'Área de Conductores (A)',
                    hintText: 'Ingrese el área',
                    controller: _areaController,
                    unidad: 'cm²',
                    icon: Icons.area_chart,
                  ),
                  
                  _buildInputField(
                    label: 'Resistencia Medida (R)',
                    hintText: 'Ingrese la resistencia',
                    controller: _resistenciaController,
                    unidad: 'kΩ',
                    icon: Icons.electrical_services,
                  ),
                  
                  _buildInputField(
                    label: 'Temperatura (T)',
                    hintText: 'Ingrese la temperatura',
                    controller: _temperaturaController,
                    unidad: '°C',
                    icon: Icons.thermostat,
                  ),
                  
                  _buildInputField(
                    label: 'pH Medido',
                    hintText: 'Ingrese el pH',
                    controller: _phController,
                    unidad: 'pH',
                    icon: Icons.water_drop,
                  ),
                  
                  const SizedBox(height: AppSpacing.large),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _calcularEcuaciones,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.button),
                            ),
                          ),
                          child: Text(
                            'Calcular',
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _limpiarCampos,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.button),
                            ),
                            side: BorderSide(color: AppColors.primary),
                          ),
                          child: Text(
                            'Limpiar',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.large),
          
          // Sección de resultados
          if (_calculado) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics, color: AppColors.secondary, size: 24),
                        const SizedBox(width: AppSpacing.small),
                        Text(
                          'Resultados del Análisis',
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.large),
                    
                    // Grid de resultados
                    GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.medium,
                        mainAxisSpacing: AppSpacing.medium,
                        childAspectRatio: 1.2,
                      ),
                      children: [
                        _buildResultCard(
                          'Constante de Celda',
                          _kCell.toStringAsFixed(4),
                          'cm⁻¹',
                          AppColors.primary,
                        ),
                        _buildResultCard(
                          'Conductividad (T)',
                          _kappaT.toStringAsFixed(4),
                          'µS/cm',
                          AppColors.secondary,
                        ),
                        _buildResultCard(
                          'Conductividad (25°C)',
                          _kappa25.toStringAsFixed(4),
                          'µS/cm',
                          AppColors.accent,
                        ),
                        _buildResultCard(
                          'TDS',
                          _tdsPpm.toStringAsFixed(2),
                          'ppm',
                          AppColors.success,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppSpacing.medium),
                    
                    // Información adicional
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.medium),
                      decoration: BoxDecoration(
                        color: AppColors.infoLight.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: AppColors.info, size: 20),
                          const SizedBox(width: AppSpacing.small),
                          Expanded(
                            child: Text(
                              'pH registrado: ${_phController.text.isNotEmpty ? _phController.text : "No ingresado"}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.large),

                    // Botón Analizar Condiciones Iniciales
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _analizarCondicionesIniciales,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
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
                            Icon(Icons.arrow_forward, size: 20),
                            const SizedBox(width: AppSpacing.small),
                            Text(
                              'Analizar Condiciones Iniciales',
                              style: AppTextStyles.button,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Placeholder cuando no hay cálculos
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxLarge),
              child: Column(
                children: [
                  Icon(
                    Icons.science,
                    size: 64,
                    color: AppColors.textDisabled,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    'Ingrese los datos y presione Calcular',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _longitudController.dispose();
    _areaController.dispose();
    _resistenciaController.dispose();
    _temperaturaController.dispose();
    _phController.dispose();
    super.dispose();
  }
}