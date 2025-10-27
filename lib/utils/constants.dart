import 'package:flutter/material.dart';

/// ===========================
/// 🎨 COLORES DE LA APP - PALETA PROFESIONAL VERDE/AZUL
/// ===========================
class AppColors {
  // Colores primarios - Verde profesional
  static const primary = Color(0xFF2E7D32); // Verde principal sólido
  static const primaryLight = Color(0xFF4CAF50); // Verde más claro
  static const primaryDark = Color(0xFF1B5E20); // Verde más oscuro
  
  // Colores secundarios - Azul complementario
  static const secondary = Color(0xFF1976D2); // Azul profesional
  static const secondaryLight = Color(0xFF42A5F5); // Azul claro
  static const secondaryDark = Color(0xFF1565C0); // Azul oscuro
  
  // Colores de acento
  static const accent = Color(0xFF009688); // Verde azulado elegante
  static const accentLight = Color(0xFF4DB6AC); // Verde azulado claro
  
  // Colores neutros y de fondo
  static const background = Color(0xFFFAFDFB); // Blanco con tono verde muy suave
  static const backgroundVariant = Color(0xFFF1F8E9); // Verde muy claro para fondos
  static const surface = Color(0xFFFFFFFF); // Blanco puro para superficies
  static const card = Color(0xFFF8FDF9); // Fondo de tarjetas con tono verde suave
  
  // Colores de estado
  static const success = Color(0xFF388E3C); // Verde éxito
  static const successLight = Color(0xFFC8E6C9); // Verde éxito claro
  static const error = Color(0xFFD32F2F); // Rojo error
  static const errorLight = Color(0xFFFFCDD2); // Rojo error claro
  static const warning = Color(0xFFF57C00); // Naranja advertencia
  static const warningLight = Color(0xFFFFE0B2); // Naranja advertencia claro
  static const info = Color(0xFF0288D1); // Azul informativo
  static const infoLight = Color(0xFFB3E5FC); // Azul informativo claro
  
  // Colores de texto
  static const textPrimary = Color(0xFF263238); // Gris azulado oscuro
  static const textSecondary = Color(0xFF546E7A); // Gris azulado medio
  static const textDisabled = Color(0xFF90A4AE); // Gris azulado claro
  static const textOnPrimary = Color(0xFFFFFFFF); // Texto sobre fondos primarios
  static const textOnSecondary = Color(0xFFFFFFFF); // Texto sobre fondos secundarios
  
  // Colores de borde y separadores
  static const border = Color(0xFFE0E0E0); // Borde gris claro
  static const divider = Color(0xFFEEEEEE); // Divisor gris muy claro
  
  // Gradientes profesionales
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// ===========================
/// ✍️ ESTILOS DE TEXTO ACTUALIZADOS
/// ===========================
class AppTextStyles {
  // Estilos de encabezado
  static const heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Estilos de cuerpo
  static const bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // Estilos de botón
  static const buttonLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.5,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.3,
  );

  static const buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
  );

  // Estilos especiales
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textDisabled,
  );

  static const overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 1.2,
  );
}

/// ===========================
/// 📏 ESPACIADOS Y RADIOS (MEJORADOS)
/// ===========================
class AppSpacing {
  static const extraSmall = 4.0;
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const extraLarge = 32.0;
  static const xxLarge = 48.0;
  
  // Espaciados específicos
  static const appBarHeight = 64.0;
  static const bottomNavBarHeight = 80.0;
  static const cardPadding = 20.0;
  static const screenPadding = 16.0;
}

class AppRadius {
  static const extraSmall = 4.0;
  static const small = 8.0;
  static const medium = 12.0;
  static const large = 16.0;
  static const extraLarge = 24.0;
  static const round = 50.0;
  
  // Radios específicos
  static const card = medium;
  static const button = small;
  static const textField = small;
  static const dialog = large;
}

/// ===========================
/// 🎯 SOMBRAS Y ELEVACIONES
/// ===========================
class AppShadows {
  static const small = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const medium = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  static const large = [
    BoxShadow(
      color: Color(0x2A000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
}

/// ===========================
/// 🖼️ ASSETS / ICONOS
/// ===========================
class AppAssets {
  static const logo = "assets/logo.png";
  static const logoWhite = "assets/logo_white.png";
  static const userPlaceholder = "assets/images/user.png";
  static const backgroundPattern = "assets/images/pattern.png";
}

/// ===========================
/// 🔑 STRINGS COMUNES
/// ===========================
class AppStrings {
  static const appName = "Tratamiento de Agua";
  static const appTagline = "Plataforma Educativa";
  static const login = "Iniciar Sesión";
  static const logout = "Cerrar Sesión";
  static const dashboard = "Tratamiento de Agua";
  static const welcome = "Bienvenido/a";
}

/// ===========================
/// 👤 ROLES DE USUARIO
/// ===========================
class UserRoles {
  static const administrador = 'Administrador';
  static const estudiante = 'Estudiante';
  static const futuroEstudiante = 'FuturoEstudiante';
  static const docente = 'Docente';
}

/// ===========================
/// 📌 ESTADOS
/// ===========================
class Estados {
  static const activo = 'Activo';
  static const inactivo = 'Inactivo';
  static const pendiente = 'Pendiente';
  static const aprobado = 'Aprobado';
  static const rechazado = 'Rechazado';
  static const inscrito = 'Inscrito';
  static const cancelado = 'Cancelado';
  static const completado = 'Completado';
}

/// ===========================
/// 📚 TIPOS DE ACTIVIDAD
/// ===========================
class TiposActividad {
  static const seminario = 'Seminario';
  static const taller = 'Taller';
  static const curso = 'Curso';
  static const conferencia = 'Conferencia';
  static const workshop = 'Workshop';
  static const laboratorio = 'Laboratorio';
}

/// ===========================
/// 🗄️ COLECCIONES FIRESTORE
/// ===========================
class Collections {
  static const usuarios = 'usuarios';
  static const docentes = 'docentes';
  static const actividades = 'actividades';
  static const seminarios = 'seminarios';
  static const postulaciones = 'postulaciones';
  static const inscripciones = 'inscripciones';
  static const mensajes = 'mensajes';
  static const programasEstudio = 'programas_estudio';
  static const ofertasAcademicas = 'ofertas_academicas';
  static const notificaciones = 'notificaciones';
  static const calificaciones = 'calificaciones';
  static const asistencias = 'asistencias';
}

/// ===========================
/// 💬 MENSAJES COMUNES
/// ===========================
class Messages {
  static const loginError = 'Usuario o contraseña incorrectos';
  static const campoRequerido = 'Este campo es obligatorio';
  static const correoInvalido = 'Correo electrónico inválido';
  static const passwordCorta = 'La contraseña debe tener al menos 6 caracteres';
  static const operacionExitosa = 'Operación realizada con éxito';
  static const errorGeneral = 'Ha ocurrido un error. Intente nuevamente.';
  static const sinConexion = 'No hay conexión a internet';
  static const cargando = 'Cargando...';
  static const guardando = 'Guardando...';
}