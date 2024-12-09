import 'package:flutter/material.dart';
import 'package:projeto_integrador4/page/home_page.dart';
import 'package:flutter/services.dart';
import 'package:projeto_integrador4/widget/custom_input_field.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = 'Cartão de Crédito';
  double _totalAmount = 250.0;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardholderNameController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              'Pagamento',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildPaymentMethods(),
                    // Exibir campos de cartão tanto para 'Cartão de Crédito' quanto para 'Cartão de Débito'
                    if (_selectedPaymentMethod == 'Cartão de Crédito' ||
                        _selectedPaymentMethod == 'Cartão de Débito')
                      _buildCardFields(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildFooter(), // Coloca o footer na parte inferior
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Selecione o método de pagamento:',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        _buildPaymentMethodOption('Cartão de Crédito'),
        _buildPaymentMethodOption('Cartão de Débito'),
        _buildPaymentMethodOption('Dinheiro'),
        _buildPaymentMethodOption('PIX'),
      ],
    );
  }

  Widget _buildPaymentMethodOption(String method) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: RadioListTile<String>(
        title: Text(
          method,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        value: method,
        groupValue: _selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            _selectedPaymentMethod = value!;
          });
        },
        activeColor: const Color(0xFF0096c7),
        dense: true,
      ),
    );
  }

  Widget _buildCardFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          CustomInputField(
            label: 'Número do Cartão',
            width: double.infinity,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            controller: _cardNumberController,
          ),
          const SizedBox(height: 10.0),
          CustomInputField(
            label: 'Nome do Titular',
            width: double.infinity,
            keyboardType: TextInputType.text,
            controller: _cardholderNameController,
          ),
          const SizedBox(height: 10.0),
          CustomInputField(
            label: 'Data de Validade',
            width: double.infinity,
            keyboardType: TextInputType.datetime,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
            ],
            controller: _expiryDateController,
          ),
          const SizedBox(height: 10.0),
          CustomInputField(
            label: 'CVV',
            width: double.infinity,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            controller: _cvvController,
          ),
        ],
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
          // Total amount widget
          _buildTotalAmount(),

          const SizedBox(height: 10.0),

          // Confirm button widget
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildTotalAmount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total: ',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'R\$ ${_totalAmount.toStringAsFixed(2)}',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            _confirmPayment(context);
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.payment, size: 20, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Confirmar Pagamento',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmPayment(BuildContext context) {
    if (_selectedPaymentMethod == 'Cartão de Crédito' ||
        _selectedPaymentMethod == 'Cartão de Débito') {
      if (_validateCard()) {
        _showConfirmationDialog();
      } else {
        _showErrorDialog('Por favor, verifique as informações do cartão.');
      }
    } else if (_selectedPaymentMethod == 'Dinheiro' ||
        _selectedPaymentMethod == 'PIX') {
      _showConfirmationDialog();
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Column(
            children: [
              Icon(
                Icons.check_circle,
                color: Color.fromARGB(255, 39, 189, 44),
                size: 60,
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Pagamento\nConfirmado!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Método de pagamento:',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                _selectedPaymentMethod,
                style: const TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
          backgroundColor: Colors.white.withOpacity(0.9),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Fechar',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 60,
              ),
              SizedBox(height: 10),
              Text(
                'Erro no pagamento!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(message),
          backgroundColor: Colors.white.withOpacity(0.9),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Fechar',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool _validateCard() {
    return _cardNumberController.text.isNotEmpty &&
        _cardholderNameController.text.isNotEmpty &&
        _expiryDateController.text.isNotEmpty &&
        _cvvController.text.isNotEmpty;
  }
}
