import 'package:flutter/material.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String reservationNumber = args?['reservationNumber'] ?? '00000';
    final String guestName = args?['guestName'] ?? 'Nome Padrão';

    double totalAmount = 0.0;
    List<Map<String, dynamic>> consumptions = [
      {'item': 'Refeição', 'price': 50.0},
      {'item': 'Mini-bar', 'price': 30.0},
      {'item': 'Serviço de quarto', 'price': 20.0},
      {'item': 'Spa', 'price': 100.0},
      {'item': 'Lavanderia', 'price': 40.0},
    ];

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
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00b4d8),
                    Color(0xFF90e0ef),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Dados da Reserva',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Número da Reserva: $reservationNumber',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'Nome do Hóspede: $guestName',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      'Consumos:',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: consumptions.length,
                      itemBuilder: (context, index) {
                        final consumption = consumptions[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: const Icon(
                              Icons.receipt,
                              color: Color(0xFF0096c7),
                            ),
                            title: Text(
                              consumption['item'],
                              style: const TextStyle(color: Colors.black),
                            ),
                            trailing: Text(
                              'R\$ ${consumption['price'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Total: R\$ ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      _showConfirmationDialog(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check_circle, size: 20),
                        SizedBox(width: 8), 
                        Text(
                          'Finalizar Check-Out',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Confirmação de',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Center(
                child: Text(
                  'Check-Out',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          content: const Text(
            'Você deseja finalizar o check-out?',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white.withOpacity(0.9),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red, 
                  ),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); 
                    _showSuccessDialog(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor:
                        const Color(0xFF0096c7), 
                  ),
                  child: const Text('Confirmar'),
                ),
              ],
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
          title: Center(
            child: const Text(
              'Sucesso!',
              style: TextStyle(color: Colors.black),
            ),
          ),
          content: const Text(
            'Check-out realizado com sucesso!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white.withOpacity(0.9),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/payment');
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0096c7),
              ),
              child: Center(
                child: const Text('Realizar o pagamento'),
              ),
            ),
          ],
        );
      },
    );
  }
}
