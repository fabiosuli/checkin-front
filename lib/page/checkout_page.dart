import 'package:flutter/material.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Recuperando os argumentos passados pela navegação
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String reservationNumber = args['reservationNumber'];
    final String guestName = args['guestName'];

    double totalAmount = 0.0; // Total a ser pago
    List<Map<String, dynamic>> consumptions = [
      {'item': 'Refeição', 'price': 50.0},
      {'item': 'Mini-bar', 'price': 30.0},
      {'item': 'Serviço de quarto', 'price': 20.0},
    ];

    // Calcula o total
    totalAmount = consumptions.fold(0, (sum, item) => sum + item['price']);

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
              'Check-Out',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados da Reserva',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10.0),
            Text(
              'Número da Reserva: $reservationNumber',
              style: const TextStyle(
                  fontSize: 16.0, color: Colors.white), // Cor do texto
            ),
            Text(
              'Nome do Hóspede: $guestName',
              style: const TextStyle(
                  fontSize: 16.0, color: Colors.white), // Cor do texto
            ),
            const SizedBox(height: 20.0),
            Text(
              'Consumos:',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white), 
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: consumptions.length,
                itemBuilder: (context, index) {
                  final consumption = consumptions[index];
                  return ListTile(
                    title: Text(consumption['item'],
                        style: const TextStyle(
                            color: Colors.white)),
                    trailing: Text(
                      'R\$ ${consumption['price'].toStringAsFixed(2)}',
                      style:
                          const TextStyle(color: Colors.white), 
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Total: R\$ ${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white), 
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implementar lógica de pagamento
                _showConfirmationDialog(context);
              },
              child: const Text('Finalizar Check-Out'),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmação de Check-Out'),
          content: const Text('Você deseja finalizar o check-out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Lógica de finalização do check-out
                Navigator.of(context).pop(); // Fechar o diálogo
                _showSuccessDialog(context);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sucesso!'),
          content: const Text('Check-out realizado com sucesso!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
                Navigator.of(context).pop(); // Voltar para a tela anterior
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
