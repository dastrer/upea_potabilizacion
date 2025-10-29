import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../utils/constants.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';

class ResultadosScreen extends StatelessWidget {
  const ResultadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardVM = Provider.of<DashboardViewModel>(context);
    
    final bool tieneDatosCompletos = dashboardVM.tieneDatosPretratamiento && 
                                    dashboardVM.tieneDatosTratamientoCalculado && 
                                    dashboardVM.tieneDatosPostratamiento;

    if (tieneDatosCompletos) {
      return _buildResultadosCompletos(context, dashboardVM);
    } else {
      return _buildWaitingScreen(context, dashboardVM);
    }
  }

  Widget _buildResultadosCompletos(BuildContext context, DashboardViewModel dashboardVM) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados Finales'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.5),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _mostrarDialogoReinicio(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background.withOpacity(0.8),
              AppColors.backgroundVariant.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.all(isMobile ? AppSpacing.screenPadding : AppSpacing.large),
            child: Column(
              children: [
                // Header de resultados con gradiente
                _buildHeaderResultados(isMobile),
                
                const SizedBox(height: AppSpacing.large),
                
                // Proceso completo con diseño mejorado
                _buildProcesoCompleto(context, dashboardVM, isMobile),
                
                const SizedBox(height: AppSpacing.large),
                
                // Resumen ejecutivo con métricas coloridas
                _buildResumenEjecutivo(dashboardVM, isMobile),
                
                const SizedBox(height: AppSpacing.large),
                
                // Botones de acción mejorados
                _buildBotonesAccion(context, dashboardVM, isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderResultados(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success.withOpacity(0.9),
            AppColors.info.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? AppSpacing.medium : AppSpacing.large),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? AppSpacing.medium : AppSpacing.large),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified_user_rounded,
                color: Colors.white,
                size: isMobile ? 30 : 40,
              ),
            ),
            SizedBox(width: isMobile ? AppSpacing.medium : AppSpacing.large),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Proceso Completado!',
                    style: AppTextStyles.heading2.copyWith(
                      color: Colors.white,
                      fontSize: isMobile ? 20 : 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.small),
                  Text(
                    'Todos los módulos del tratamiento electroquímico han sido ejecutados exitosamente',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: isMobile ? 14 : 16,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.celebration_rounded,
              color: Colors.white,
              size: isMobile ? 30 : 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcesoCompleto(BuildContext context, DashboardViewModel dashboardVM, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? AppSpacing.medium : AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.timeline_rounded, color: AppColors.info, size: 20),
                ),
                SizedBox(width: AppSpacing.small),
                Text(
                  'Flujo de Trabajo Completado',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.medium),
            
            // Pasos del proceso con diseño mejorado
            _buildPasoProceso(
              '1. Análisis Inicial',
              'Caracterización del agua',
              Icons.analytics_rounded,
              [Color(0xFF667EEA), Color(0xFF764BA2)],
              _buildDatosAnalisis(dashboardVM),
              true,
              isMobile
            ),
            
            _buildConectorProceso(isMobile, [Color(0xFF764BA2), Color(0xFFF093FB)]),
            
            _buildPasoProceso(
              '2. Pretratamiento',
              'Diagnóstico y cálculos',
              Icons.design_services_rounded,
              [Color(0xFFF093FB), Color(0xFFF5576C)],
              _buildDatosPretratamiento(dashboardVM),
              true,
              isMobile
            ),
            
            _buildConectorProceso(isMobile, [Color(0xFFF5576C), Color(0xFF4FACFE)]),
            
            _buildPasoProceso(
              '3. Tratamiento Electroquímico',
              'Proceso de electrocoagulación',
              Icons.electrical_services_rounded,
              [Color(0xFF4FACFE), Color(0xFF00F2FE)],
              _buildDatosTratamiento(dashboardVM),
              true,
              isMobile
            ),
            
            _buildConectorProceso(isMobile, [Color(0xFF00F2FE), Color(0xFF43E97B)]),
            
            _buildPasoProceso(
              '4. Postratamiento',
              'Validación y resultados',
              Icons.assignment_turned_in_rounded,
              [Color(0xFF43E97B), Color(0xFF38F9D7)],
              _buildDatosPostratamiento(dashboardVM),
              true,
              isMobile
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasoProceso(String titulo, String subtitulo, IconData icon, 
                          List<Color> gradientColors, List<Widget> datos, 
                          bool completado, bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(isMobile ? AppSpacing.medium : AppSpacing.large),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: gradientColors.map((color) => color.withOpacity(0.1)).toList(),
        ),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: gradientColors.first.withOpacity(0.3),
          width: 1
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? AppSpacing.small : AppSpacing.medium),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: gradientColors.first.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isMobile ? 18 : 22,
            ),
          ),
          SizedBox(width: isMobile ? AppSpacing.small : AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        titulo,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: gradientColors.first,
                          fontSize: isMobile ? 15 : 17,
                        ),
                      ),
                    ),
                    if (completado)
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check_rounded, color: Colors.white, size: 14),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  subtitulo,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (datos.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.small),
                  Container(
                    padding: EdgeInsets.all(AppSpacing.small),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: datos,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConectorProceso(bool isMobile, List<Color> gradientColors) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 25 : 35),
      child: Column(
        children: [
          Container(
            width: 3,
            height: 15,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: gradientColors.first,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_downward_rounded, color: Colors.white, size: 12),
          ),
          Container(
            width: 3,
            height: 15,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors.reversed.toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDatosAnalisis(DashboardViewModel dashboardVM) {
    final tds = dashboardVM.getDatoPretratamiento('tdsPpm') ?? 0.0;
    final ph = dashboardVM.getDatoPretratamiento('ph') ?? 0.0;
    final temperatura = dashboardVM.getDatoPretratamiento('temperatura') ?? 0.0;
    
    return [
      _buildDatoItem('TDS: ${tds.toStringAsFixed(2)} ppm', Icons.water_drop_rounded),
      _buildDatoItem('pH: ${ph.toStringAsFixed(1)}', Icons.phishing_rounded),
      _buildDatoItem('Temperatura: ${temperatura.toStringAsFixed(1)}°C', Icons.thermostat_rounded),
    ];
  }

  List<Widget> _buildDatosPretratamiento(DashboardViewModel dashboardVM) {
    final voltaje = dashboardVM.getDatoTratamientoCalculado('voltajeDiseño') ?? 0.0;
    final volumen = dashboardVM.getDatoTratamientoCalculado('volumenAgua') ?? 0.0;
    final tiempo = dashboardVM.getDatoTratamientoCalculado('tiempoTratamientoSegundos') ?? 0;
    
    return [
      _buildDatoItem('Voltaje: ${voltaje.toStringAsFixed(1)} V', Icons.bolt_rounded),
      _buildDatoItem('Volumen: ${volumen.toStringAsFixed(1)} L', Icons.invert_colors_rounded),
      _buildDatoItem('Tiempo calculado: ${_formatearTiempo(tiempo.toInt())}', Icons.timer_rounded),
    ];
  }

  List<Widget> _buildDatosTratamiento(DashboardViewModel dashboardVM) {
    final corriente = dashboardVM.getDatoTratamientoCalculado('corrienteSimulada') ?? 0.0;
    final carga = dashboardVM.getDatoTratamientoCalculado('cargaRequerida') ?? 0.0;
    
    return [
      _buildDatoItem('Corriente: ${corriente.toStringAsFixed(4)} A', Icons.power_rounded),
      _buildDatoItem('Carga requerida: ${carga.toStringAsFixed(2)} C', Icons.battery_charging_full_rounded),
    ];
  }

  List<Widget> _buildDatosPostratamiento(DashboardViewModel dashboardVM) {
    final horas = dashboardVM.getDatoPostratamiento('tiempoHoras') ?? 0;
    final minutos = dashboardVM.getDatoPostratamiento('tiempoMinutos') ?? 0;
    final segundos = dashboardVM.getDatoPostratamiento('tiempoSegundos') ?? 0;
    final voltaje = dashboardVM.getDatoPostratamiento('voltajeTratamiento') ?? 0.0;
    
    return [
      _buildDatoItem('Tiempo ejecutado: ${horas}h ${minutos}m ${segundos}s', Icons.schedule_rounded),
      _buildDatoItem('Voltaje aplicado: ${voltaje.toStringAsFixed(1)} V', Icons.flash_on_rounded),
    ];
  }

  Widget _buildDatoItem(String texto, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.info, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenEjecutivo(DashboardViewModel dashboardVM, bool isMobile) {
    final tdsInicial = dashboardVM.getDatoPretratamiento('tdsPpm') ?? 0.0;
    final tiempoTotal = dashboardVM.getDatoPostratamiento('tiempoTotalSegundos') ?? 0;
    final voltaje = dashboardVM.getDatoPostratamiento('voltajeTratamiento') ?? 0.0;
    final ph = dashboardVM.getDatoPretratamiento('ph') ?? 0.0;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.backgroundVariant.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? AppSpacing.medium : AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.summarize_rounded, color: Colors.white, size: 20),
                ),
                SizedBox(width: AppSpacing.small),
                Text(
                  'Resumen Ejecutivo',
                  style: AppTextStyles.heading3.copyWith(
                    color: Color(0xFFB76E00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.medium),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isMobile ? 2 : 3,
              crossAxisSpacing: AppSpacing.medium,
              mainAxisSpacing: AppSpacing.medium,
              childAspectRatio: isMobile ? 1.1 : 1.3,
              children: [
                _buildMetricaResumen(
                  'TDS Inicial', 
                  '${tdsInicial.toStringAsFixed(2)} ppm', 
                  Icons.water_drop_rounded,
                  [Color(0xFF4FACFE), Color(0xFF00F2FE)]
                ),
                _buildMetricaResumen(
                  'Tiempo Total', 
                  _formatearTiempo(tiempoTotal.toInt()), 
                  Icons.timer_rounded,
                  [Color(0xFF43E97B), Color(0xFF38F9D7)]
                ),
                _buildMetricaResumen(
                  'Voltaje', 
                  '${voltaje.toStringAsFixed(1)} V', 
                  Icons.bolt_rounded,
                  [Color(0xFF667EEA), Color(0xFF764BA2)]
                ),
                _buildMetricaResumen(
                  'pH Inicial', 
                  ph.toStringAsFixed(1), 
                  Icons.phishing_rounded,
                  [Color(0xFFF093FB), Color(0xFFF5576C)]
                ),
                _buildMetricaResumen(
                  'Estado', 
                  'Completado', 
                  Icons.check_circle_rounded,
                  [Color(0xFF4CD964), Color(0xFF5AC8FA)]
                ),
                _buildMetricaResumen(
                  'Eficiencia', 
                  '100%', 
                  Icons.speed_rounded,
                  [Color(0xFFFFD700), Color(0xFFFF9500)]
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricaResumen(String titulo, String valor, IconData icon, List<Color> gradientColors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          SizedBox(height: AppSpacing.small),
          Text(
            titulo,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.small),
          Text(
            valor,
            style: AppTextStyles.heading3.copyWith(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBotonesAccion(BuildContext context, DashboardViewModel dashboardVM, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.medium),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.circular(AppRadius.button),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  _exportarResultadosPDF(context, dashboardVM);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: isMobile ? AppSpacing.medium : AppSpacing.large),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.picture_as_pdf_rounded, size: isMobile ? 18 : 20),
                    SizedBox(width: AppSpacing.small),
                    Text(
                      'Exportar PDF',
                      style: AppTextStyles.button.copyWith(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: isMobile ? AppSpacing.small : AppSpacing.medium),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF5576C), Color(0xFFF093FB)],
                ),
                borderRadius: BorderRadius.circular(AppRadius.button),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF5576C).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  _mostrarDialogoReinicio(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: isMobile ? AppSpacing.medium : AppSpacing.large),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restart_alt_rounded, size: isMobile ? 18 : 20),
                    SizedBox(width: AppSpacing.small),
                    Text(
                      'Nuevo Proceso',
                      style: AppTextStyles.button.copyWith(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportarResultadosPDF(BuildContext context, DashboardViewModel dashboardVM) async {
    try {
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.info),
                ),
                SizedBox(height: 16),
                Text(
                  'Generando PDF...',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Crear el documento PDF
      final pdf = pw.Document();

      // Agregar página
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return _buildPDFContent(dashboardVM);
          },
        ),
      );

      // Cerrar el diálogo de carga
      Navigator.of(context).pop();

      // Mostrar el PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF generado exitosamente', style: AppTextStyles.body),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al generar PDF: $e', style: AppTextStyles.body),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  pw.Widget _buildPDFContent(DashboardViewModel dashboardVM) {
    final tdsInicial = dashboardVM.getDatoPretratamiento('tdsPpm') ?? 0.0;
    final ph = dashboardVM.getDatoPretratamiento('ph') ?? 0.0;
    final temperatura = dashboardVM.getDatoPretratamiento('temperatura') ?? 0.0;
    final voltaje = dashboardVM.getDatoTratamientoCalculado('voltajeDiseño') ?? 0.0;
    final volumen = dashboardVM.getDatoTratamientoCalculado('volumenAgua') ?? 0.0;
    final tiempoCalculado = dashboardVM.getDatoTratamientoCalculado('tiempoTratamientoSegundos') ?? 0;
    final corriente = dashboardVM.getDatoTratamientoCalculado('corrienteSimulada') ?? 0.0;
    final carga = dashboardVM.getDatoTratamientoCalculado('cargaRequerida') ?? 0.0;
    final tiempoTotal = dashboardVM.getDatoPostratamiento('tiempoTotalSegundos') ?? 0;
    final voltajeAplicado = dashboardVM.getDatoPostratamiento('voltajeTratamiento') ?? 0.0;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header del PDF
        pw.Container(
          width: double.infinity,
          padding: pw.EdgeInsets.all(20),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromInt(AppColors.primary.value),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            children: [
              pw.Text(
                'REPORTE DE TRATAMIENTO ELECTROQUÍMICO',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Sistema de Electrocoagulación - Resultados Finales',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.white,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(
                'Fecha: ${DateTime.now().toString().split(' ')[0]}',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.white,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Resumen Ejecutivo
        pw.Container(
          width: double.infinity,
          padding: pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.blue400, width: 1),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'RESUMEN EJECUTIVO',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TDS Inicial:', style: pw.TextStyle(fontSize: 12)),
                  pw.Text('${tdsInicial.toStringAsFixed(2)} ppm', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('pH Inicial:', style: pw.TextStyle(fontSize: 12)),
                  pw.Text(ph.toStringAsFixed(1), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Tiempo Total:', style: pw.TextStyle(fontSize: 12)),
                  pw.Text(_formatearTiempo(tiempoTotal.toInt()), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Voltaje Aplicado:', style: pw.TextStyle(fontSize: 12)),
                  pw.Text('${voltajeAplicado.toStringAsFixed(1)} V', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Detalles del Proceso
        pw.Text(
          'DETALLES DEL PROCESO',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 10),
        
        // Análisis Inicial
        pw.Container(
          width: double.infinity,
          padding: pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '1. ANÁLISIS INICIAL',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.purple600,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('TDS: ${tdsInicial.toStringAsFixed(2)} ppm', style: pw.TextStyle(fontSize: 11)),
              pw.Text('pH: ${ph.toStringAsFixed(1)}', style: pw.TextStyle(fontSize: 11)),
              pw.Text('Temperatura: ${temperatura.toStringAsFixed(1)}°C', style: pw.TextStyle(fontSize: 11)),
            ],
          ),
        ),
        
        pw.SizedBox(height: 10),
        
        // Pretratamiento
        pw.Container(
          width: double.infinity,
          padding: pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '2. PRETRATAMIENTO',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.pink600,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Voltaje de Diseño: ${voltaje.toStringAsFixed(1)} V', style: pw.TextStyle(fontSize: 11)),
              pw.Text('Volumen de Agua: ${volumen.toStringAsFixed(1)} L', style: pw.TextStyle(fontSize: 11)),
              pw.Text('Tiempo Calculado: ${_formatearTiempo(tiempoCalculado.toInt())}', style: pw.TextStyle(fontSize: 11)),
            ],
          ),
        ),
        
        pw.SizedBox(height: 10),
        
        // Tratamiento
        pw.Container(
          width: double.infinity,
          padding: pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '3. TRATAMIENTO ELECTROQUÍMICO',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue600,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Corriente Simulada: ${corriente.toStringAsFixed(4)} A', style: pw.TextStyle(fontSize: 11)),
              pw.Text('Carga Requerida: ${carga.toStringAsFixed(2)} C', style: pw.TextStyle(fontSize: 11)),
            ],
          ),
        ),
        
        pw.SizedBox(height: 10),
        
        // Postratamiento
        pw.Container(
          width: double.infinity,
          padding: pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '4. POSTRATAMIENTO',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green600,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Tiempo Ejecutado: ${_formatearTiempo(tiempoTotal.toInt())}', style: pw.TextStyle(fontSize: 11)),
              pw.Text('Voltaje Aplicado: ${voltajeAplicado.toStringAsFixed(1)} V', style: pw.TextStyle(fontSize: 11)),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Footer
        pw.Container(
          width: double.infinity,
          padding: pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            'Reporte generado automáticamente por el Sistema de Tratamiento Electroquímico',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _mostrarDialogoReinicio(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reiniciar Proceso', style: AppTextStyles.heading3),
        content: Text('¿Está seguro de que desea reiniciar todo el proceso? Se perderán los datos actuales.', 
          style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar', style: AppTextStyles.body),
          ),
          ElevatedButton(
            onPressed: () {
              final dashboardVM = Provider.of<DashboardViewModel>(context, listen: false);
              dashboardVM.limpiarTodosDatosTratamiento();
              dashboardVM.limpiarDatosPostratamiento();
              dashboardVM.limpiarDatosPretratamiento();
              dashboardVM.goToInicio();
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Proceso reiniciado exitosamente', style: AppTextStyles.body),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text('Reiniciar', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  String _formatearTiempo(int segundosTotales) {
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

  // Mantener el método de espera para cuando no hay datos completos
  Widget _buildWaitingScreen(BuildContext context, DashboardViewModel dashboardVM) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.background, AppColors.backgroundVariant],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.all(isMobile ? AppSpacing.screenPadding : AppSpacing.large),
            child: Center(
              child: Card(
                margin: EdgeInsets.all(isMobile ? AppSpacing.medium : AppSpacing.large),
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
                    padding: EdgeInsets.all(isMobile ? AppSpacing.large : AppSpacing.xxLarge),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isMobile ? AppSpacing.medium : AppSpacing.large),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.assignment_turned_in,
                            size: isMobile ? 48 : 64,
                            color: AppColors.info,
                          ),
                        ),
                        SizedBox(height: isMobile ? AppSpacing.medium : AppSpacing.large),
                        Text(
                          "Resultados",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.info,
                            fontSize: isMobile ? 24 : 32,
                          ),
                        ),
                        SizedBox(height: isMobile ? AppSpacing.small : AppSpacing.medium),
                        Text(
                          "Complete el flujo de trabajo",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: isMobile ? 16 : 20,
                          ),
                        ),
                        SizedBox(height: isMobile ? AppSpacing.medium : AppSpacing.large),
                        
                        // Flujo de trabajo paso a paso
                        _buildWorkflowStep("1. Análisis", "Realice el análisis inicial del agua", Icons.analytics, isMobile),
                        SizedBox(height: isMobile ? AppSpacing.small : AppSpacing.medium),
                        _buildWorkflowStep("2. Cálculos de Condiciones Iniciales", "Configure parámetros en Pretratamiento", Icons.calculate, isMobile),
                        SizedBox(height: isMobile ? AppSpacing.small : AppSpacing.medium),
                        _buildWorkflowStep("3. Tratamiento", "Ejecute el proceso electroquímico", Icons.electrical_services, isMobile),
                        
                        SizedBox(height: isMobile ? AppSpacing.medium : AppSpacing.large),
                        Container(
                          margin: EdgeInsets.only(top: isMobile ? AppSpacing.small : AppSpacing.medium),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? AppSpacing.medium : AppSpacing.large,
                            vertical: isMobile ? AppSpacing.small : AppSpacing.medium,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppRadius.round),
                          ),
                          child: Text(
                            "Esperando datos del tratamiento...",
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.info,
                              fontWeight: FontWeight.w600,
                              fontSize: isMobile ? 12 : 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkflowStep(String step, String description, IconData icon, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? AppSpacing.medium : AppSpacing.large),
      decoration: BoxDecoration(
        color: AppColors.backgroundVariant,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? AppSpacing.small : AppSpacing.medium),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.info,
              size: isMobile ? 18 : 24,
            ),
          ),
          SizedBox(width: isMobile ? AppSpacing.small : AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: isMobile ? 12 : 14,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}