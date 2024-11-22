import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://localhost:8080'; // Atualize para o IP/URL do seu backend

  /// Verifica se o backend está acessível.
  Future<bool> checkBackendConnection() async {
    try {
      // Use uma rota existente, como '/api/checkin' ou '/api/bookings'
      final response =
          await http.get(Uri.parse('$baseUrl/api/test/connection'));

      // Considera que a conexão é válida se o servidor responde com status 200
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
        print('Reserva encontrada');
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
  Future<bool> sendCheckIn(String reservationNumber, String guestName,
      String documentType, String documentNumber) async {
    try {
      final url = Uri.parse('$baseUrl/api/bookings/checkin');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'reservationNumber': reservationNumber,
          'guestName': guestName,
          'documentType': documentType,
          'documentNumber': documentNumber,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao fazer o check-in: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro ao fazer o check-in: $e');
      return false;
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        print('Erro ao enviar o checkout: ${response.body}');
      }
    } catch (e) {
      print('Erro ao enviar o checkout: $e');
    }
    return null;
  }
}
