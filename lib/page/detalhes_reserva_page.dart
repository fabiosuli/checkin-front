import 'package:flutter/material.dart';
import 'package:projeto_integrador4/api/api_service.dart';

class DetalhesReservaPage extends StatefulWidget {
  final String? reserveNumber;
  final String? guestName;

  const DetalhesReservaPage({super.key, this.reserveNumber, this.guestName});

  @override
  State<DetalhesReservaPage> createState() => _DetalhesReservaPageState();
}

class _DetalhesReservaPageState extends State<DetalhesReservaPage> {
  Map<String, dynamic>? reservationDetails;
  bool isLoading = true; // Controle de carregamento
  String errorMessage = ''; // Para exibir mensagens de erro

  // Instância do ApiService
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchBookingDetails(); // Função para pegar os dados do backend
  }

  // Função para buscar os detalhes da reserva do backend
  Future<void> _fetchBookingDetails() async {
    try {
      // Chama o serviço para pegar os detalhes
      final data = await _apiService.fetchBookingDetails(
        widget.reserveNumber ?? '', // Usando 'widget' corretamente
      );

      if (data != null) {
        setState(() {
          reservationDetails = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erro ao buscar os detalhes da reserva';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erro: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Exibe mensagem de erro caso ocorra algum problema
    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.red, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Dados para exibição
    final String nomeHospede =
        reservationDetails?["guestName"] ?? "Nome não disponível";
    final String documento =
        reservationDetails?["document"] ?? "Documento não disponível";
    final String quarto =
        reservationDetails?["room"] ?? "Quarto não disponível";
    final String dataCheckIn =
        reservationDetails?["checkInDate"] ?? "Data não disponível";
    final String dataCheckOut =
        reservationDetails?["checkOutDate"] ?? "Data não disponível";
    final double valorDiaria =
        (reservationDetails?["dailyValue"] ?? 0.0) as double;
    final int totalDias = (reservationDetails?["totalDays"] ?? 0) as int;
    final double totalDiarias = valorDiaria * totalDias;
    final String cafeDaManha =
        (reservationDetails?["breakfastIncluded"] ?? false)
            ? 'Incluído'
            : 'Não incluído';
    final String cancelamento = reservationDetails?["cancellationPolicy"] ??
        "Sem política de cancelamento.";

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00b4d8),
              Color(0xFF90e0ef),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildListTile(
                        Icons.person, 'Nome do Hóspede', nomeHospede),
                    _buildListTile(Icons.assignment, 'Documento', documento),
                    _buildListTile(Icons.hotel, 'Quarto', quarto),
                    _buildListTile(Icons.date_range, 'Check-in', dataCheckIn),
                    _buildListTile(Icons.date_range, 'Check-out', dataCheckOut),
                    _buildListTile(Icons.attach_money, 'Valor da Diária',
                        'R\$ ${valorDiaria.toStringAsFixed(2)}'),
                    _buildListTile(Icons.attach_money, 'Total das Diárias',
                        'R\$ ${totalDiarias.toStringAsFixed(2)}'),
                    _buildListTile(
                        Icons.fastfood, 'Café da Manhã', cafeDaManha),
                    _buildListTile(
                        Icons.info, 'Política de Cancelamento', cancelamento),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkOut', arguments: {
                            'reservationNumber': widget.reserveNumber,
                            'guestName': nomeHospede,
                          });
                        },
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text('Ir para Check-out'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
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
    );
  }

  // Função para criar o AppBar personalizado
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
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
          title: const Text(
            'Detalhes da Reserva',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  // Função para criar itens de exibição
  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0096c7)),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
