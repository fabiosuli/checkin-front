import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_integrador4/widget/custom_input_field.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final TextEditingController hotelController = TextEditingController();
  final TextEditingController reservaController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController documentoController = TextEditingController();

  String? selectedOption = 'CPF';
  String label = 'Número do CPF';

  void _onOptionChanged(String? value) {
    setState(() {
      selectedOption = value;
      label = value == 'CPF' ? 'Número do CPF' : 'Número do Passaporte';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: screenHeight,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF00b4d8),
                      Color(0xFF90e0ef),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'COLOCAR ALGUMA',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(
                            'COISA AQUI',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45.0),
                        topRight: Radius.circular(45.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Realizar o Check-In',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 10.0),
                            CustomInputField(
                              label: 'Hotel',
                              width: screenWidth * 0.8,
                              controller: hotelController,
                            ),
                            const SizedBox(height: 20.0),
                            CustomInputField(
                              label: 'Número da Reserva',
                              width: screenWidth * 0.8,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: reservaController,
                            ),
                            const SizedBox(height: 20.0),
                            CustomInputField(
                              label: 'Nome Completo',
                              width: screenWidth * 0.8,
                              controller: nomeController,
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'CPF',
                                      groupValue: selectedOption,
                                      onChanged: _onOptionChanged,
                                    ),
                                    const Text('CPF'),
                                  ],
                                ),
                                const SizedBox(width: 20.0),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Passaporte',
                                      groupValue: selectedOption,
                                      onChanged: _onOptionChanged,
                                    ),
                                    const Text('Passaporte'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            CustomInputField(
                              label: label,
                              width: screenWidth * 0.8,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: documentoController,
                            ),
                            const SizedBox(height: 20.0),
                            SizedBox(
                              width: screenWidth * 0.6,
                              height: 50.0,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/detalhesReserva',
                                      arguments: {
                                        'reservaNumber': reservaController.text,
                                        'nome': nomeController.text,
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                icon: const Icon(Icons.check),
                                label: const Text('Fazer Check-In'),
                              ),
                            ),
                          ],
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
    );
  }
}
