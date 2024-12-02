import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_integrador4/cor/ipfixo.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  List<Map<String, dynamic>> consumptions = [];
  double totalAmount = 0.0;
  bool isLoading = true;
  bool isError = false;

  String reservationNumber = '';
  String guestName = '';

  bool _didDependenciesChange = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didDependenciesChange) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null &&
          args.containsKey('reservationNumber') &&
          args.containsKey('guestName')) {
        reservationNumber = args['reservationNumber'] ?? '';
        guestName = args['guestName'] ?? '';
      }

      print("Reservation Number: $reservationNumber");
      print("Guest Name: $guestName");

      if (reservationNumber.isEmpty || guestName.isEmpty) {
        setState(() {
          isError = true;
          isLoading = false;
        });
      } else {
        _fetchExpense();
      }

      _didDependenciesChange = true;
    }
  }

  Future<void> _fetchExpense() async {
    final String apiUrl =
        '${Ipfixo().iplocal}/api/bookings/$reservationNumber/expenses';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> expenseList = data['expenses'];

        setState(() {
          consumptions = expenseList
              .map((item) => {
                    'item': item['description'],
                    'price': item['amount'].toDouble(),
                  })
              .toList();
          totalAmount =
              consumptions.fold(0.0, (sum, item) => sum + item['price']);
          isLoading = false;
        });
      } else {
        _handleError('Erro ao carregar os consumos.');
      }
    } catch (e) {
      print('Erro: $e');
      _handleError('Erro ao carregar os consumos.');
    }
  }

  void _handleError(String message) {
    setState(() {
      isError = true;
      isLoading = false;
    });
    _showErrorDialog(message);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: _buildAppBar(),
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
                  _buildReservationDetails(),
                  const SizedBox(height: 20.0),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : isError
                          ? _buildErrorState()
                          : _buildConsumptionsList(),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildReservationDetails() {
    return Column(
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Nome do Hóspede: $guestName',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConsumptionsList() {
    return Expanded(
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
    );
  }

  Widget _buildErrorState() {
    return const Center(
      child: Text(
        'Erro ao carregar os consumos.',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
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
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 15.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => _showConfirmationDialog(context),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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
            'Você deseja finalizar o\ncheck-out?',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white.withOpacity(0.9),
          actions: [
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.pushNamed(context, '/payment');
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
