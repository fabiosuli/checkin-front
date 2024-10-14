import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_integrador4/widget/custom_input_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _reservationController = TextEditingController();
  final TextEditingController _guestNameController = TextEditingController();

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Check-In',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bem-vindo ao Hotel',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20.0),
                // Campo de texto para número da reserva
                CustomInputField(
                  label: 'Número da Reserva',
                  width: screenWidth * 0.8,
                  controller: _reservationController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 20.0),
                // Campo de texto para nome do hóspede
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
                        onPressed: () {
                          if (_reservationController.text.isNotEmpty &&
                              _guestNameController.text.isNotEmpty) {
                            Navigator.pushNamed(
                              context,
                              '/checkIn',
                              arguments: {
                                'reservationNumber':
                                    _reservationController.text,
                                'guestName': _guestNameController.text,
                              },
                            );
                          } else {
                            _showErrorDialog(context,
                                'Por favor, preencha todos os campos.');
                          }
                        },
                        child: const Text('Check-In'),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.35,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_reservationController.text.isNotEmpty &&
                              _guestNameController.text.isNotEmpty) {
                            Navigator.pushNamed(
                              context,
                              '/checkOut',
                              arguments: {
                                'reservationNumber':
                                    _reservationController.text,
                                'guestName': _guestNameController.text,
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
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
