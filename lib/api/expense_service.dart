import 'dart:convert';
import 'package:http/http.dart' as http;

class Expense {
  final String description;
  final double amount;

  Expense({required this.description, required this.amount});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      description: json['description'],
      amount: json['amount'],
    );
  }
}

class ExpenseSummary {
  final List<Expense> expenses;
  final double total;

  ExpenseSummary({required this.expenses, required this.total});
}

Future<ExpenseSummary> fetchExpenseSummary(String bookingId) async {
  final url =
      Uri.parse('http://localhost:8080/api/bookings/$bookingId/expenses');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // Se a requisição for bem-sucedida, parseia a resposta
    var data = json.decode(response.body);
    List<Expense> expenses =
        (data['expenses'] as List).map((e) => Expense.fromJson(e)).toList();
    double total = data['total'];
    return ExpenseSummary(expenses: expenses, total: total);
  } else {
    throw Exception('Falha ao carregar resumo de despesas');
  }
}
