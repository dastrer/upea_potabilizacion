import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  int _selectedIndex = 3; // Inicio por defecto (índice 3 según tu dashboard)
  Map<String, dynamic>? _datosPretratamiento;

  int get selectedIndex => _selectedIndex;
  Map<String, dynamic>? get datosPretratamiento => _datosPretratamiento;

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

  // Métodos para navegación rápida a cada módulo
  void goToAnalisis() {
    changeIndex(0);
  }

  void goToPretratamiento([Map<String, dynamic>? datos]) {
    _selectedIndex = 1;
    if (datos != null) {
      _datosPretratamiento = datos;
    }
    notifyListeners();
  }

  void goToPostratamiento() {
    changeIndex(2);
  }

  void goToInicio() {
    changeIndex(3);
  }

  void goToResultados() {
    changeIndex(4);
  }

  void goToFundamentos() {
    changeIndex(5);
  }

  void goToSoporte() {
    changeIndex(6);
  }

  // Método para verificar si hay datos de pretratamiento
  bool get tieneDatosPretratamiento => _datosPretratamiento != null;

  // Método para obtener un dato específico de pretratamiento
  dynamic getDatoPretratamiento(String clave) {
    return _datosPretratamiento?[clave];
  }

  // Método para actualizar datos de pretratamiento
  void actualizarDatosPretratamiento(Map<String, dynamic> nuevosDatos) {
    _datosPretratamiento = {...?_datosPretratamiento, ...nuevosDatos};
    notifyListeners();
  }
}