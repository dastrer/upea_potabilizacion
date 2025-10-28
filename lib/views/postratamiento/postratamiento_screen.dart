import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import '../../utils/constants.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';

class PostratamientoScreen extends StatefulWidget {
  const PostratamientoScreen({super.key});

  @override
  State<PostratamientoScreen> createState() => _PostratamientoScreenState();
}

class _PostratamientoScreenState extends State<PostratamientoScreen> {
  Timer? _timer;
  int _tiempoRestante = 0;
  bool _cronometroActivo = false;
  bool _tratamientoCompletado = false;
  
  // Fase 2: Variables para visión artificial
  bool _mostrarValidacion = false;
  bool _validacionExitosa = false;
  bool _validacionCompletada = false;
  bool _procesandoImagen = false;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  
  // Parámetros de validación
  final double _umbralClaridad = 180.0; // Valor experimental (0-255)
  double _brilloPostEC = 0.0;

  @override
  void initState() {
    super.initState();
    _inicializarCamara();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  void _inicializarCamara() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras!.first,
          ResolutionPreset.medium,
        );
        await _cameraController!.initialize();
        if (mounted) setState(() {});
      }
    } catch (e) {
      print('Error inicializando cámara: $e');
    }
  }

  // FASE 1: Control Temporizado
  void _iniciarCronometro(int tiempoTotalSegundos) {
    if (_cronometroActivo) return;

    setState(() {
      _tiempoRestante = tiempoTotalSegundos;
      _cronometroActivo = true;
      _tratamientoCompletado = false;
      _mostrarValidacion = false;
      _validacionCompletada = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_tiempoRestante > 0) {
          _tiempoRestante--;
        } else {
          _detenerCronometro();
          _finalizarFase1();
        }
      });
    });
  }

  void _detenerCronometro() {
    _timer?.cancel();
    setState(() {
      _cronometroActivo = false;
    });
  }

  void _finalizarFase1() {
    setState(() {
      _tratamientoCompletado = true;
    });
    
    // Mostrar alerta
    _mostrarAlertaFinalizacion();
    
    // Después de 2 segundos, mostrar fase de validación
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _mostrarValidacion = true;
        });
      }
    });
  }

  void _mostrarAlertaFinalizacion() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Tratamiento completado - Proceda a validación'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // FASE 2: Validación con Visión Artificial - CORREGIDO
  void _iniciarValidacionClaridad() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Cámara no disponible'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _procesandoImagen = true;
    });

    try {
      // Capturar imagen
      final image = await _cameraController!.takePicture();
      
      // Cargar y procesar imagen
      final imageBytes = await image.readAsBytes();
      final capturedImage = img.decodeImage(imageBytes);
      
      if (capturedImage != null) {
        _brilloPostEC = _calcularBrilloPromedio(capturedImage);
        _validarClaridad(_brilloPostEC);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error al procesar imagen: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _procesandoImagen = false;
      });
    }
  }

  // FUNCIÓN CORREGIDA - Acceso correcto a componentes RGB
  double _calcularBrilloPromedio(img.Image image) {
    int totalBrillo = 0;
    int totalPixeles = 0;
    
    // Analizar región central (evitar bordes)
    final anchoCentro = (image.width * 0.6).toInt();
    final altoCentro = (image.height * 0.6).toInt();
    final inicioX = (image.width - anchoCentro) ~/ 2;
    final inicioY = (image.height - altoCentro) ~/ 2;
    
    for (int y = inicioY; y < inicioY + altoCentro; y++) {
      for (int x = inicioX; x < inicioX + anchoCentro; x++) {
        final pixel = image.getPixel(x, y);
        
        // ✅ FORMA CORRECTA - Acceso directo a los componentes
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;
        
        // Fórmula de luminosidad perceptual
        final brillo = (0.299 * r + 0.587 * g + 0.114 * b).toInt();
        totalBrillo += brillo;
        totalPixeles++;
      }
    }
    
    return totalPixeles > 0 ? totalBrillo / totalPixeles : 0.0;
  }

  void _validarClaridad(double brillo) {
    setState(() {
      _validacionExitosa = brillo >= _umbralClaridad;
      _validacionCompletada = true;
    });

    if (_validacionExitosa) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Claridad suficiente: ${brillo.toStringAsFixed(1)}'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Claridad insuficiente: ${brillo.toStringAsFixed(1)}'),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }

  // FASE 3: Control Iterativo
  void _anadir5Minutos() {
    setState(() {
      _tiempoRestante = 300; // 5 minutos en segundos
      _cronometroActivo = true;
      _mostrarValidacion = false;
      _validacionCompletada = false;
      _validacionExitosa = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_tiempoRestante > 0) {
          _tiempoRestante--;
        } else {
          _detenerCronometro();
          _finalizarFase1();
        }
      });
    });
  }

  void _finalizarYFiltrar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Tratamiento finalizado - Proceda a filtración'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _formatearTiempo(int segundosTotales) {
    final horas = segundosTotales ~/ 3600;
    final minutos = (segundosTotales % 3600) ~/ 60;
    final segundos = segundosTotales % 60;

    if (horas > 0) {
      return '${horas}h ${minutos.toString().padLeft(2, '0')}m ${segundos.toString().padLeft(2, '0')}s';
    } else if (minutos > 0) {
      return '${minutos}m ${segundos.toString().padLeft(2, '0')}s';
    } else {
      return '${segundos}s';
    }
  }

  Widget _buildTratamientoActivo(BuildContext context, Map<String, dynamic> datos) {
    final Size screenSize = MediaQuery.of(context).size;
    final double paddingValue = screenSize.width * 0.04;
    final double heading1Size = screenSize.width * 0.08;
    final double heading2Size = screenSize.width * 0.06;

    final int horas = datos['tiempoHoras'] ?? 0;
    final int minutos = datos['tiempoMinutos'] ?? 0;
    final int segundos = datos['tiempoSegundos'] ?? 0;
    final double voltaje = datos['voltajeTratamiento'] ?? 0.0;
    final int tiempoTotalSegundos = datos['tiempoTotalSegundos']?.toInt() ?? 0;

    // Si el cronómetro no ha empezado, usar el tiempo calculado
    final int tiempoActual = _cronometroActivo || _tratamientoCompletado 
        ? _tiempoRestante 
        : tiempoTotalSegundos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamiento en Progreso'),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.all(paddingValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FASE 1: Control Temporizado
              if (!_mostrarValidacion) ...[
                _buildFaseTemporizada(
                  context, 
                  datos, 
                  tiempoActual, 
                  tiempoTotalSegundos, 
                  paddingValue, 
                  heading1Size, 
                  heading2Size
                ),
              ],

              // FASE 2: Validación con Visión Artificial
              if (_mostrarValidacion) ...[
                _buildFaseValidacion(
                  context, 
                  paddingValue, 
                  heading2Size
                ),
              ],

              // Espacio adicional al final para mejor scroll
              SizedBox(height: paddingValue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaseTemporizada(
    BuildContext context, 
    Map<String, dynamic> datos, 
    int tiempoActual, 
    int tiempoTotalSegundos, 
    double paddingValue, 
    double heading1Size, 
    double heading2Size
  ) {
    final Size screenSize = MediaQuery.of(context).size;
    final double voltaje = datos['voltajeTratamiento'] ?? 0.0;

    return Column(
      children: [
        // Tiempo de tratamiento
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Column(
              children: [
                Text(
                  _tratamientoCompletado 
                      ? 'Tratamiento Completado ✅'
                      : _cronometroActivo 
                          ? 'Tiempo Restante'
                          : 'Tiempo de Tratamiento Calculado',
                  style: AppTextStyles.heading3.copyWith(
                    fontSize: heading2Size.clamp(14, 20),
                    color: _tratamientoCompletado 
                        ? AppColors.success 
                        : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: paddingValue),
                Text(
                  _formatearTiempo(tiempoActual),
                  style: TextStyle(
                    fontSize: heading1Size.clamp(24, 36),
                    fontWeight: FontWeight.bold,
                    color: _tratamientoCompletado 
                        ? AppColors.success 
                        : _cronometroActivo 
                            ? AppColors.warning 
                            : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: paddingValue * 0.5),
                Text(
                  'Total: ${tiempoTotalSegundos} segundos',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: screenSize.width * 0.032,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_cronometroActivo || _tratamientoCompletado) ...[
                  SizedBox(height: paddingValue * 0.5),
                  LinearProgressIndicator(
                    value: tiempoTotalSegundos > 0 
                        ? 1 - (_tiempoRestante / tiempoTotalSegundos)
                        : 0,
                    backgroundColor: AppColors.backgroundVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _tratamientoCompletado 
                          ? AppColors.success 
                          : AppColors.secondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        SizedBox(height: paddingValue),

        // Parámetros de operación
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Parámetros de Operación',
                  style: AppTextStyles.heading3.copyWith(
                    fontSize: heading2Size.clamp(14, 20),
                  ),
                ),
                SizedBox(height: paddingValue),
                _buildParametroItemAlineado(
                  context, 
                  'Voltaje Aplicado', 
                  '${voltaje.toStringAsFixed(1)} V', 
                  Icons.bolt
                ),
                _buildParametroItemAlineado(
                  context, 
                  'Corriente Simulada', 
                  '${(voltaje / 10).toStringAsFixed(2)} A', 
                  Icons.electrical_services
                ),
                _buildParametroItemAlineado(
                  context, 
                  'Estado', 
                  _tratamientoCompletado 
                      ? 'Validación Pendiente'
                      : _cronometroActivo 
                          ? 'En Progreso ⏱️'
                          : 'Programado', 
                  _tratamientoCompletado 
                      ? Icons.verified
                      : _cronometroActivo 
                          ? Icons.play_circle_fill
                          : Icons.schedule
                ),
                _buildParametroItemAlineado(
                  context, 
                  'Progreso', 
                  _tratamientoCompletado 
                      ? '100% completado'
                      : '${((tiempoTotalSegundos - _tiempoRestante) / tiempoTotalSegundos * 100).toStringAsFixed(1)}%', 
                  Icons.timer
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: paddingValue),

        // Controles del cronómetro - FASE 1
        if (!_tratamientoCompletado) ...[
          if (!_cronometroActivo && _tiempoRestante == 0) 
            _buildBotonIniciar(context, screenSize, paddingValue, tiempoTotalSegundos)
          else if (_cronometroActivo)
            _buildControlesEnProgreso(context, screenSize, paddingValue, tiempoTotalSegundos)
          else if (!_cronometroActivo && _tiempoRestante > 0)
            _buildControlesPausados(context, screenSize, paddingValue, tiempoTotalSegundos),
        ],

        // Mensaje de completado - Transición a FASE 2
        if (_tratamientoCompletado) ...[
          SizedBox(height: paddingValue),
          Card(
            elevation: 2,
            color: AppColors.success.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.large),
              side: BorderSide(color: AppColors.success, width: 1),
            ),
            child: Padding(
              padding: EdgeInsets.all(paddingValue),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 40),
                  SizedBox(width: paddingValue),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fase 1 Completada',
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                        Text(
                          'Proceda a la validación de claridad',
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
          SizedBox(height: paddingValue),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _mostrarValidacion = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: paddingValue * 1.2,
                  horizontal: paddingValue,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: screenSize.width * 0.06),
                  SizedBox(width: paddingValue * 0.5),
                  Text(
                    'Iniciar Validación de Claridad',
                    style: AppTextStyles.button.copyWith(
                      fontSize: screenSize.width * 0.04,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFaseValidacion(BuildContext context, double paddingValue, double heading2Size) {
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        // Header de validación
        Card(
          elevation: 2,
          color: AppColors.info.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
            side: BorderSide(color: AppColors.info, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Row(
              children: [
                Icon(Icons.visibility, color: AppColors.info, size: 40),
                SizedBox(width: paddingValue),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Validación de Claridad',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                      Text(
                        'Fase 2: Análisis con Visión Artificial',
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

        SizedBox(height: paddingValue),

        // Vista de cámara o instrucciones
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          child: Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Column(
              children: [
                Text(
                  'Instrucciones de Captura',
                  style: AppTextStyles.heading3.copyWith(
                    fontSize: heading2Size.clamp(14, 20),
                  ),
                ),
                SizedBox(height: paddingValue),
                _buildInstruccionItem('1. Alinee la cubeta con la cámara', Icons.camera_alt),
                _buildInstruccionItem('2. Asegure buena iluminación', Icons.lightbulb),
                _buildInstruccionItem('3. Capture imagen del agua tratada', Icons.photo_camera),
                SizedBox(height: paddingValue),
                
                if (_cameraController != null && _cameraController!.value.isInitialized)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: CameraPreview(_cameraController!),
                    ),
                  )
                else
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundVariant,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_photography, size: 40, color: AppColors.textSecondary),
                        SizedBox(height: paddingValue * 0.5),
                        Text(
                          'Cámara no disponible',
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

        SizedBox(height: paddingValue),

        // Resultados de validación
        if (_validacionCompletada) ...[
          Card(
            elevation: 2,
            color: _validacionExitosa 
                ? AppColors.success.withOpacity(0.1)
                : AppColors.warning.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.large),
              side: BorderSide(
                color: _validacionExitosa ? AppColors.success : AppColors.warning, 
                width: 1
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(paddingValue),
              child: Column(
                children: [
                  Icon(
                    _validacionExitosa ? Icons.verified : Icons.warning,
                    size: 50,
                    color: _validacionExitosa ? AppColors.success : AppColors.warning,
                  ),
                  SizedBox(height: paddingValue),
                  Text(
                    _validacionExitosa 
                        ? '¡Validación Exitosa!'
                        : 'Validación Requiere Mejora',
                    style: AppTextStyles.heading3.copyWith(
                      color: _validacionExitosa ? AppColors.success : AppColors.warning,
                    ),
                  ),
                  SizedBox(height: paddingValue * 0.5),
                  Text(
                    'Brillo medido: ${_brilloPostEC.toStringAsFixed(1)} / ${_umbralClaridad}',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: paddingValue * 0.5),
                  Text(
                    _validacionExitosa
                        ? 'El agua cumple con los estándares de claridad'
                        : 'Claridad insuficiente. Faltan flóculos grandes.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: paddingValue),
        ],

        // Botones de acción - FASE 3
        if (!_validacionCompletada) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _procesandoImagen ? null : _iniciarValidacionClaridad,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.info,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: paddingValue * 1.2,
                  horizontal: paddingValue,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
              child: _procesandoImagen
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: paddingValue * 0.5),
                        Text(
                          'Procesando Imagen...',
                          style: AppTextStyles.button.copyWith(
                            fontSize: screenSize.width * 0.04,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_camera, size: screenSize.width * 0.06),
                        SizedBox(width: paddingValue * 0.5),
                        Text(
                          'Capturar y Validar Claridad',
                          style: AppTextStyles.button.copyWith(
                            fontSize: screenSize.width * 0.04,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],

        if (_validacionCompletada) ...[
          if (!_validacionExitosa) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _anadir5Minutos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: paddingValue * 1.2,
                    horizontal: paddingValue,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: screenSize.width * 0.06),
                    SizedBox(width: paddingValue * 0.5),
                    Text(
                      'Añadir 5 Minutos Más',
                      style: AppTextStyles.button.copyWith(
                        fontSize: screenSize.width * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: paddingValue * 0.5),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validacionExitosa ? _finalizarYFiltrar : _iniciarValidacionClaridad,
              style: ElevatedButton.styleFrom(
                backgroundColor: _validacionExitosa ? AppColors.success : AppColors.info,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: paddingValue * 1.2,
                  horizontal: paddingValue,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _validacionExitosa ? Icons.done_all : Icons.refresh,
                    size: screenSize.width * 0.06,
                  ),
                  SizedBox(width: paddingValue * 0.5),
                  Text(
                    _validacionExitosa 
                        ? 'Finalizar y Filtrar'
                        : 'Reintentar Validación',
                    style: AppTextStyles.button.copyWith(
                      fontSize: screenSize.width * 0.04,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Widgets auxiliares para los botones
  Widget _buildBotonIniciar(BuildContext context, Size screenSize, double paddingValue, int tiempoTotalSegundos) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _iniciarCronometro(tiempoTotalSegundos),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: paddingValue * 1.2,
            horizontal: paddingValue,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow, size: screenSize.width * 0.06),
            SizedBox(width: paddingValue * 0.5),
            Text(
              'Iniciar Tratamiento',
              style: AppTextStyles.button.copyWith(
                fontSize: screenSize.width * 0.045,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlesEnProgreso(BuildContext context, Size screenSize, double paddingValue, int tiempoTotalSegundos) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _detenerCronometro,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: paddingValue * 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pause, size: screenSize.width * 0.06),
                SizedBox(width: paddingValue * 0.5),
                Text(
                  'Pausar',
                  style: AppTextStyles.button.copyWith(fontSize: screenSize.width * 0.04),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: paddingValue),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _iniciarCronometro(tiempoTotalSegundos),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: paddingValue * 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stop, size: screenSize.width * 0.06),
                SizedBox(width: paddingValue * 0.5),
                Text(
                  'Reiniciar',
                  style: AppTextStyles.button.copyWith(fontSize: screenSize.width * 0.04),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlesPausados(BuildContext context, Size screenSize, double paddingValue, int tiempoTotalSegundos) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _iniciarCronometro(_tiempoRestante),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: paddingValue * 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow, size: screenSize.width * 0.06),
                SizedBox(width: paddingValue * 0.5),
                Text(
                  'Reanudar',
                  style: AppTextStyles.button.copyWith(fontSize: screenSize.width * 0.04),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: paddingValue),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _iniciarCronometro(tiempoTotalSegundos),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: paddingValue * 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: screenSize.width * 0.06),
                SizedBox(width: paddingValue * 0.5),
                Text(
                  'Reiniciar',
                  style: AppTextStyles.button.copyWith(fontSize: screenSize.width * 0.04),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstruccionItem(String texto, IconData icono) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icono, color: AppColors.textSecondary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParametroItemAlineado(BuildContext context, String titulo, String valor, IconData icon) {
    final Size screenSize = MediaQuery.of(context).size;
    final double iconSize = screenSize.width * 0.06;
    final double fontSize = screenSize.width * 0.04;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: iconSize.clamp(16, 24)),
          SizedBox(width: screenSize.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: fontSize.clamp(12, 16),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  valor,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: fontSize.clamp(12, 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleScreen(BuildContext context, String title, IconData icon, Color color, String description) {
    final Size screenSize = MediaQuery.of(context).size;
    final double paddingValue = screenSize.width * 0.05;
    final double iconSize = screenSize.width * 0.2;
    final double heading1Size = screenSize.width * 0.08;
    final double heading3Size = screenSize.width * 0.05;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.background, AppColors.backgroundVariant],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.all(paddingValue),
            child: Card(
              margin: EdgeInsets.all(paddingValue),
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
                  padding: EdgeInsets.all(paddingValue * 1.5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(paddingValue),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: iconSize.clamp(48, 80),
                          color: color,
                        ),
                      ),
                      SizedBox(height: paddingValue),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading1.copyWith(
                          color: color,
                          fontSize: heading1Size.clamp(20, 32),
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height: paddingValue * 0.5),
                      Text(
                        "En Construcción",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: heading3Size.clamp(14, 18),
                        ),
                      ),
                      SizedBox(height: paddingValue),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: screenSize.width * 0.038,
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: paddingValue * 0.8),
                      Container(
                        margin: EdgeInsets.only(top: paddingValue * 0.5),
                        padding: EdgeInsets.symmetric(
                          horizontal: paddingValue,
                          vertical: paddingValue * 0.5,
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
                            fontSize: screenSize.width * 0.035,
                          ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardVM = Provider.of<DashboardViewModel>(context);
    final datosPostratamiento = dashboardVM.datosPostratamiento;

    if (datosPostratamiento != null) {
      return _buildTratamientoActivo(context, datosPostratamiento);
    }

    return _buildModuleScreen(
      context,
      "Postratamiento",
      Icons.assignment_turned_in,
      AppColors.accent,
      "Módulo de resultados y reportes post-procesamiento",
    );
  }
}