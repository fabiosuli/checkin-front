import 'package:flutter/material.dart';

class DetalhesReservaPage extends StatefulWidget {
  const DetalhesReservaPage({super.key});

  @override
  State<DetalhesReservaPage> createState() => _DetalhesReservaPageState();
}

class _DetalhesReservaPageState extends State<DetalhesReservaPage> {
  @override
  Widget build(BuildContext context) {
    final String nomeHospede = 'João da Silva';
    final String documento = 'CPF: 123.456.789-00';
    final String quarto = '101 - Deluxe';
    final String dataCheckIn = '10/10/2024';
    final String dataCheckOut = '15/10/2024';
    final String numeroReserva = 'AB123456';
    final double valorDiaria = 200.00;
    final double total = valorDiaria * 5;
    final String cafeDaManha = 'Incluído';
    final String cancelamento =
        'Cancelamento grátis até 24 horas antes da chegada.';

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
              'Detalhes da Reserva',
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
                    _buildListTile(Icons.confirmation_number,
                        'Número da Reserva', numeroReserva),
                    _buildListTile(Icons.attach_money, 'Valor da Diária',
                        'R\$ $valorDiaria'),
                    _buildListTile(Icons.attach_money, 'Total', 'R\$ $total'),
                    _buildListTile(
                        Icons.fastfood, 'Café da Manhã', cafeDaManha),
                    _buildListTile(
                        Icons.info, 'Política de Cancelamento', cancelamento),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkOut');
                        },
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text('Ir para Check-out'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
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

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF0096c7)),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
