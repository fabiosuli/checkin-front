import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_integrador4/widget/custom_input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final TextEditingController reservaController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController documentoController = TextEditingController();

  String? selectedOption = 'CPF';
  String label = 'Número do CPF';
  String? errorMessage;

  void _onOptionChanged(String? value) {
    setState(() {
      selectedOption = value;
      label = value == 'CPF' ? 'Número do CPF' : 'Número do Passaporte';
      errorMessage = null;  // Limpar mensagem de erro ao mudar a opção
    });
  }

  // Função para enviar os dados para o backend e validar
  Future<void> _handleCheckIn() async {
    String documento = documentoController.text.trim();
    String reservaNumber = reservaController.text.trim();
    String nome = nomeController.text.trim();

    // Verifica se o campo de CPF ou Passaporte está vazio
    if (documento.isEmpty || reservaNumber.isEmpty || nome.isEmpty) {
      setState(() {
        errorMessage = 'Por favor, preencha todos os campos.';
      });
      return;
    }

    // Preparando o corpo da requisição
    Map<String, dynamic> data = {
      'reservaNumber': reservaNumber,
      'nome': nome,
      'documento': documento,
      'documentoTipo': selectedOption, // CPF ou Passaporte
    };

    // Enviando a requisição para o backend
    final response = await http.post(
      Uri.parse('http://<seu-backend>/api/validarCheckIn'), // Coloque o endpoint correto do seu backend
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      // Se a resposta for bem-sucedida, redireciona para a próxima tela
      Navigator.pushNamed(
        context,
        '/detalhesReserva',
        arguments: {
          'reservaNumber': reservaNumber,
          'nome': nome,
        },
      );
    } else {
      // Caso contrário, exibe a mensagem de erro
      setState(() {
        errorMessage = 'Erro ao validar os dados. Por favor, tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String reservationNumber = args['reservationNumber'];
    final String guestName = args['guestName'];

    reservaController.text = reservationNumber;
    nomeController.text = guestName;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                            'Bem-vindo(a) $guestName',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            'Número da Reserva: $reservationNumber',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Realizar o Check-In',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 10.0),
                            CustomInputField(
                              label: 'Número da Reserva',
                              width: screenWidth * 0.8,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: reservaController,
                              enabled: false,
                            ),
                            const SizedBox(height: 20.0),
                            CustomInputField(
                              label: 'Nome Completo',
                              width: screenWidth * 0.8,
                              controller: nomeController,
                              enabled: false,
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
                            if (errorMessage != null) ...[
                              const SizedBox(height: 10.0),
                              Text(
                                errorMessage!,
                                style: TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ],
                            const SizedBox(height: 20.0),
                            SizedBox(
                              width: screenWidth * 0.6,
                              height: 50.0,
                              child: ElevatedButton.icon(
                                onPressed: _handleCheckIn,
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
