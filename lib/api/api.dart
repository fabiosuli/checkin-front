import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_integrador4/api/results_reserve.dart';

class Api {
  final String _baseUrl = "";

  Future<bool> consultReserv(String reserveNumber) async {
    try {
      final endpoint = _baseUrl;
      final url = Uri.parse(endpoint);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonString = response.body;
        final map = jsonDecode(jsonString);
        final object = ResultsReservation.fromJson(map);

        // Verifica se o número da reserva corresponde ao fornecido
        if (object.reservationNumber == reserveNumber) {
          return true; // Reserva existe
        }
      }
      return false; // Reserva não existe ou ocorreu um erro
    } catch (e) {
      print("Erro ao trazer os dados!");
      return false; // Em caso de erro, retorna false
    }
  }

  Future<Map<String, String>?> fetchReservationDetails(
      String reserveNumber) async {
    try {
      // Passo 1: Verificar se a reserva existe
      bool reservaExiste = await consultReserv(reserveNumber);

      if (!reservaExiste) {
        print("Reserva não encontrada!");
        return null; // Se a reserva não existe, retornamos null
      }

      // Passo 2: Buscar os detalhes da reserva se a reserva existir
      final endpoint = _baseUrl; // Substitua com a URL do seu servidor
      final url = Uri.parse(endpoint);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonString = response.body;
        final map = jsonDecode(jsonString);

        // Converte o JSON em um objeto ResulstReserv
        final result = ResulstReserv.fromJson(map);

        // Verifica se o número da reserva encontrado corresponde ao número de reserva fornecido
        if (result.reservation?.reservationNumber == reserveNumber) {
          // Retorna os detalhes da reserva, incluindo informações do hóspede
          return {
            "firstName": result.guest?.firstName ?? "",
            "lastName": result.guest?.lastName ?? "",
            "checkInDate": result.reservation?.checkInDate ?? "",
            "checkOutDate": result.reservation?.checkOutDate ?? "",
            "roomNumber": result.reservation?.roomNumber ?? "",
          };
        }
      }

      print("Reserva não encontrada nos detalhes!");
      return null; // Caso a reserva não seja encontrada ou outro erro ocorra
    } catch (e) {
      print("Erro ao trazer os dados: $e");
      return null; // Caso ocorra um erro durante a requisição
    }
  }
}
