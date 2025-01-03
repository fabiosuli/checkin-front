import 'package:flutter/material.dart';
import 'package:projeto_integrador4/api/api_service.dart';
import 'package:projeto_integrador4/page/checkout_page.dart';
import 'package:projeto_integrador4/page/checkin_page.dart';
import 'package:projeto_integrador4/page/home_page.dart';
import 'package:projeto_integrador4/page/payment_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  final isConnected = await apiService.checkBackendConnection();

  runApp(MyApp(isConnected: isConnected));
}

class MyApp extends StatelessWidget {
  final bool isConnected;

  const MyApp({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    debugPrint("Backend está conectado? $isConnected");

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF00b4d8),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: const Color(0xFF48cae4),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          headlineMedium: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            backgroundColor: const Color(0xFF00b4d8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            textStyle: const TextStyle(fontSize: 17.0),
          ),
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/checkIn': (context) => const CheckInPage(),
        '/checkOut': (context) => const CheckOutPage(),
        '/payment': (context) => const PaymentPage(),
      },
    );
  }
}
