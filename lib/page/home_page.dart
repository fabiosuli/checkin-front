import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_integrador4/widget/custom_input_field.dart';
import 'package:projeto_integrador4/api/booking_service.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _reservationController = TextEditingController();
  final TextEditingController _guestNameController = TextEditingController();
  bool _isLoading = false;

  final BookingService bookingService = BookingService();

  @override
  void dispose() {
    _reservationController.dispose();
    _guestNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00b4d8),
              Color(0xFF90e0ef),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bem-vindo(a) ao',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'CheckInExpress',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 20.0),
                    CustomInputField(
                      label: 'Número da Reserva',
                      width: screenWidth * 0.8,
                      controller: _reservationController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 20.0),
                    CustomInputField(
                      label: 'Nome Completo',
                      width: screenWidth * 0.8,
                      controller: _guestNameController,
                    ),
                    const SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.35,
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    try {
                                      final reservation = _reservationController.text;
                                      final response = await bookingService.fetchBooking(reservation);

                                      if (response != null) {
                                        Navigator.pushNamed(
                                          context,
                                          '/checkIn',
                                          arguments: {
                                            'reservationNumber':
                                                response['reservationNumber'],
                                            'guestName': response['guestName'],
                                          },
                                        );
                                      } else {
                                        _showErrorDialog(
                                            context, 'Reserva não encontrada.');
                                      }
                                    } catch (e) {
                                      _showErrorDialog(context,
                                          'Erro ao buscar reserva: $e');
                                    } finally {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                            child: const Text('Check-In'),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.35,
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    if (_reservationController
                                            .text.isNotEmpty &&
                                        _guestNameController.text.isNotEmpty) {
                                      Navigator.pushNamed(
                                        context,
                                        '/checkOut',
                                        arguments: {
                                          'reservationNumber':
                                              _reservationController.text,
                                          'guestName':
                                              _guestNameController.text,
                                        },
                                      );
                                    } else {
                                      _showErrorDialog(context,
                                          'Por favor, preencha todos os campos.');
                                    }
                                  },
                            child: const Text('Check-Out'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Colors.white.withOpacity(0.9),
            title: const Center(
              child: Text(
                'Erro',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            content: Text(
              message,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0096c7),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Entendi',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
