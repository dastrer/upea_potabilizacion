// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:potabilizacion_upea/main.dart';
import 'package:potabilizacion_upea/viewmodels/dashboard_viewmodel.dart';

void main() {
  testWidgets('Dashboard screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the dashboard screen is loaded
    expect(find.text('Dashboard App'), findsOneWidget);
    
    // Verify that the main modules are present in navigation
    expect(find.text('Análisis'), findsAtLeast(1));
    expect(find.text('Pretratamiento'), findsAtLeast(1));
    expect(find.text('Resultados'), findsAtLeast(1));
    
    // Verify that construction message is present
    expect(find.text('En Construcción'), findsAtLeast(1));
    expect(find.text('Próximamente'), findsAtLeast(1));
  });

  testWidgets('Navigation between screens', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Initially should show the first screen (Análisis)
    expect(find.text('Análisis'), findsOneWidget);
    
    // Tap on Pretratamiento in bottom navigation
    await tester.tap(find.text('Pretrata.').first);
    await tester.pumpAndSettle();

    // Should now show Pretratamiento screen
    expect(find.text('Pretratamiento'), findsOneWidget);
  });

  testWidgets('Drawer navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Open the drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Verify drawer items are present
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Análisis'), findsOneWidget);
    expect(find.text('Pretratamiento'), findsOneWidget);
    expect(find.text('Postratamiento'), findsOneWidget);
    expect(find.text('Resultados'), findsOneWidget);
    expect(find.text('Fundamentos'), findsOneWidget);
    expect(find.text('Soporte'), findsOneWidget);

    // Tap on Resultados in drawer
    await tester.tap(find.text('Resultados'));
    await tester.pumpAndSettle();

    // Should show Resultados screen
    expect(find.text('Resultados'), findsOneWidget);
  });

  testWidgets('DashboardViewModel changes index', (WidgetTester tester) async {
    // Test the ViewModel functionality
    final viewModel = DashboardViewModel();
    
    // Initial index should be 0 (Análisis)
    expect(viewModel.selectedIndex, 0);
    
    // Change index and verify
    viewModel.changeIndex(2);
    expect(viewModel.selectedIndex, 2); // Postratamiento
    
    // Change to Inicio (index 3)
    viewModel.changeIndex(3);
    expect(viewModel.selectedIndex, 3);
    
    // Change back to 0
    viewModel.changeIndex(0);
    expect(viewModel.selectedIndex, 0);
  });

  testWidgets('Responsive navigation bars', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Should find at least one navigation item
    expect(find.byType(MaterialButton), findsAtLeast(7));
    
    // Should find the central inicio button
    expect(find.byIcon(Icons.dashboard), findsAtLeast(2));
  });

  testWidgets('Module screens display correct content', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify initial screen content
    expect(find.text('Análisis'), findsOneWidget);
    expect(find.text('Módulo de análisis y evaluación de calidad'), findsOneWidget);
    expect(find.byIcon(Icons.analytics), findsOneWidget);
  });

  testWidgets('App theme and colors are applied', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify app bar uses primary color
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.backgroundColor, isNotNull);
    
    // Verify gradient background is present
    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('User info in drawer', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Verify user information
    expect(find.text('Usuario Ejemplo'), findsOneWidget);
    expect(find.text('usuario@correo.com'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsAtLeast(2));
  });

  testWidgets('Logout button in drawer', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Verify logout button is present
    expect(find.text('Cerrar Sesión'), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });
}