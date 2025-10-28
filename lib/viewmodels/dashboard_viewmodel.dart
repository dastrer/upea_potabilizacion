import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  int _selectedIndex = 3; // Inicio por defecto (índice 3 según tu dashboard)
  Map<String, dynamic>? _datosPretratamiento;
  Map<String, dynamic>? _datosTratamientoCalculado;
  Map<String, dynamic>? _datosTratamientoIniciado;
  Map<String, dynamic>? _datosPostratamiento; // NUEVA PROPIEDAD

  int get selectedIndex => _selectedIndex;
  Map<String, dynamic>? get datosPretratamiento => _datosPretratamiento;
  Map<String, dynamic>? get datosTratamientoCalculado => _datosTratamientoCalculado;
  Map<String, dynamic>? get datosTratamientoIniciado => _datosTratamientoIniciado;
  Map<String, dynamic>? get datosPostratamiento => _datosPostratamiento; // NUEVO GETTER

  void changeIndex(int index) {
    _selectedIndex = index;
    // REMOVED: No limpiar datos automáticamente al cambiar de página
    // _datosPretratamiento = null;
    notifyListeners();
  }

  void changeToPretratamiento(Map<String, dynamic>? datos) {
    _selectedIndex = 1; // Índice de Pretratamiento
    _datosPretratamiento = datos;
    notifyListeners();
  }

  // Método para establecer datos de pretratamiento sin cambiar de página
  void setDatosPretratamiento(Map<String, dynamic>? datos) {
    _datosPretratamiento = datos;
    notifyListeners();
  }

  // Método opcional para limpiar datos específicamente (solo cuando sea necesario)
  void limpiarDatosPretratamiento() {
    _datosPretratamiento = null;
    notifyListeners();
  }

  // ========== NUEVOS MÉTODOS PARA POSTRATAMIENTO ==========

  // Guardar datos para postratamiento (tiempo y voltaje)
  void setDatosPostratamiento(Map<String, dynamic> datos) {
    _datosPostratamiento = datos;
    notifyListeners();
  }

  // Limpiar datos de postratamiento
  void limpiarDatosPostratamiento() {
    _datosPostratamiento = null;
    notifyListeners();
  }

  // ========== MÉTODOS PARA TRATAMIENTO ==========

  // Guardar datos de tratamiento calculados (para persistencia entre navegaciones)
  void setDatosTratamientoCalculado(Map<String, dynamic> datos) {
    _datosTratamientoCalculado = datos;
    notifyListeners();
  }

  // Guardar datos de tratamiento iniciado (para enviar al módulo de Tratamiento)
  void setDatosTratamientoIniciado(Map<String, dynamic> datos) {
    _datosTratamientoIniciado = datos;
    notifyListeners();
  }

  // Limpiar datos de tratamiento calculados
  void limpiarDatosTratamientoCalculado() {
    _datosTratamientoCalculado = null;
    notifyListeners();
  }

  // Limpiar datos de tratamiento iniciado
  void limpiarDatosTratamientoIniciado() {
    _datosTratamientoIniciado = null;
    notifyListeners();
  }

  // Limpiar todos los datos de tratamiento
  void limpiarTodosDatosTratamiento() {
    _datosTratamientoCalculado = null;
    _datosTratamientoIniciado = null;
    notifyListeners();
  }

  // ========== MÉTODOS PARA NAVEGACIÓN RÁPIDA ==========
  void goToAnalisis() {
    changeIndex(0); // Análisis - Índice 0
  }

  void goToPretratamiento([Map<String, dynamic>? datos]) {
    _selectedIndex = 1; // Pretratamiento - Índice 1
    if (datos != null) {
      _datosPretratamiento = datos;
    }
    notifyListeners();
  }

  void goToTratamiento() {
    _selectedIndex = 2; // Tratamiento - Índice 2
    notifyListeners();
  }

  void goToPostratamiento() {
    changeIndex(2); // Postratamiento - Índice 2
  }

  void goToInicio() {
    changeIndex(3); // Inicio - Índice 3
  }

  void goToResultados() {
    changeIndex(4); // Resultados - Índice 4
  }

  void goToFundamentos() {
    changeIndex(5); // Fundamentos - Índice 5
  }

  void goToSoporte() {
    changeIndex(6); // Soporte - Índice 6
  }

  // ========== MÉTODOS DE VERIFICACIÓN ==========

  // Método para verificar si hay datos de pretratamiento
  bool get tieneDatosPretratamiento => _datosPretratamiento != null;

  // Método para verificar si hay datos de tratamiento calculados
  bool get tieneDatosTratamientoCalculado => _datosTratamientoCalculado != null;

  // Método para verificar si hay datos de tratamiento iniciado
  bool get tieneDatosTratamientoIniciado => _datosTratamientoIniciado != null;

  // Método para verificar si hay datos de postratamiento
  bool get tieneDatosPostratamiento => _datosPostratamiento != null;

  // ========== MÉTODOS PARA OBTENER DATOS ESPECÍFICOS ==========

  // Método para obtener un dato específico de pretratamiento
  dynamic getDatoPretratamiento(String clave) {
    return _datosPretratamiento?[clave];
  }

  // Método para obtener un dato específico de tratamiento calculado
  dynamic getDatoTratamientoCalculado(String clave) {
    return _datosTratamientoCalculado?[clave];
  }

  // Método para obtener un dato específico de tratamiento iniciado
  dynamic getDatoTratamientoIniciado(String clave) {
    return _datosTratamientoIniciado?[clave];
  }

  // Método para obtener un dato específico de postratamiento
  dynamic getDatoPostratamiento(String clave) {
    return _datosPostratamiento?[clave];
  }

  // ========== MÉTODOS PARA ACTUALIZAR DATOS ==========

  // Método para actualizar datos de pretratamiento
  void actualizarDatosPretratamiento(Map<String, dynamic> nuevosDatos) {
    _datosPretratamiento = {...?_datosPretratamiento, ...nuevosDatos};
    notifyListeners();
  }

  // Método para actualizar datos de tratamiento calculado
  void actualizarDatosTratamientoCalculado(Map<String, dynamic> nuevosDatos) {
    _datosTratamientoCalculado = {...?_datosTratamientoCalculado, ...nuevosDatos};
    notifyListeners();
  }

  // Método para actualizar datos de tratamiento iniciado
  void actualizarDatosTratamientoIniciado(Map<String, dynamic> nuevosDatos) {
    _datosTratamientoIniciado = {...?_datosTratamientoIniciado, ...nuevosDatos};
    notifyListeners();
  }

  // Método para actualizar datos de postratamiento
  void actualizarDatosPostratamiento(Map<String, dynamic> nuevosDatos) {
    _datosPostratamiento = {...?_datosPostratamiento, ...nuevosDatos};
    notifyListeners();
  }
}