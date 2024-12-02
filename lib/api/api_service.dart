import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto_integrador4/cor/ipfixo.dart';

class ApiService {
  static String baseUrl = Ipfixo().iplocal;

  /// Verifica se o backend está acessível.
  Future<bool> checkBackendConnection() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/test/connection'));
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao verificar conexão com o backend: $e');
      return false;
    }
  }

  /// Valida a reserva e o nome do hóspede
  Future<Map<String, dynamic>?> validateBooking(
      String reservationNumber, String guestName) async {
    try {
      final url = Uri.parse('$baseUrl/api/bookings/validate');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'reservationNumber': reservationNumber,
          'guestName': guestName,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Erro ao validar reserva: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro ao validar reserva: $e');
      return null;
    }
  }

  /// Envia um pedido de check-in para o backend
  Future<bool> sendCheckIn(String reservaNumber, String nome,
      String tipoDocumento, String numeroDocumento) async {
    try {
      final url = Uri.parse('$baseUrl/api/bookings/checkin');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reservationNumber': reservaNumber,
          'guestName': nome,
          'documentType': tipoDocumento,
          'documentNumber': numeroDocumento,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao se conectar com a API: $e');
      return false;
    }
  }

  /// Busca os detalhes da reserva
  Future<Map<String, dynamic>?> fetchBookingDetails(
      String reserveNumber) async {
    final url = Uri.parse('$baseUrl/api/bookings/details/$reserveNumber');
    try {
      final response = await http.get(url);
      print("Response ${response.body}");
      if (response.statusCode == 200) {
        print("response ${response.body}");
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao carregar dados');
      }
    } catch (e) {
      print('Erro: $e');
      throw Exception('Falha ao se conectar ao servidor: $e');
    }
  }

  /// Refatoração para buscar as despesas utilizando `fetchExpenseSummary`
  Future<ExpenseSummary> fetchExpenseSummary(String reservationNumber) async {
    final url = Uri.parse('$baseUrl/expenses/$reservationNumber');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // O campo 'expenses' já foi filtrado sem o 'id' no modelo Expense
        List<Expense> expenses =
            (data['expenses'] as List).map((e) => Expense.fromJson(e)).toList();
        double total = data['total'];
        return ExpenseSummary(expenses: expenses, total: total);
      } else {
        throw Exception('Falha ao carregar resumo de despesas');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o backend: $e');
    }
  }

  /// Envia um pedido de checkout para o backend
  Future<http.Response?> sendCheckOut(
      String reservationNumber, String guestName) async {
    try {
      final url = Uri.parse('$baseUrl/api/checkout');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'reservationNumber': reservationNumber,
          'guestName': guestName,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201
          ? response
          : null;
    } catch (e) {
      print('Erro ao enviar o checkout: $e');
      return null;
    }
  }
}

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
