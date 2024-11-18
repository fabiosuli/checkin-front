import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingService {
  final String baseUrl = 'http://localhost:8080/api';

  // Verifica a conexão com o backend
  Future<bool> checkBackendConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ping'));
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao conectar com o backend: $e');
      return false;
    }
  }

  // Busca informações de uma reserva específica
  Future<Map<String, dynamic>?> fetchBooking(String reservationNumber) async {
    final url = Uri.parse('$baseUrl/bookings/reservation/$reservationNumber');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print("Resposta da API: ${response.body}");
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print(
            'Erro ao buscar reserva. Código de status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro ao conectar com o backend: $e');
      return null;
    }
  }
}
