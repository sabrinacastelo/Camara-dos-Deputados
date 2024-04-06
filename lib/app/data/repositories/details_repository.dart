import 'dart:convert';

import 'package:api/app/data/http/http_client.dart';
import 'package:api/app/data/models/details_model.dart';


class DetailsRepository {
  final HttpClient client;
  final int idDeputado;

  DetailsRepository({
    required this.client,
    required this.idDeputado,
  });

  Future<List<DetailsModel>> getDetailsById() async {
    final response = await client.get(
      url:
          'https://dadosabertos.camara.leg.br/api/v2/deputados/$idDeputado/despesas',
    );

    if (response.statusCode == 200) {
      final List<DetailsModel> details = [];
      final bodyDecode = jsonDecode(response.body);

      bodyDecode['dados'].map((expense) {
        details.add(DetailsModel.fromMap(expense));
      }).toList();

      return details;
    } else if (response.statusCode == 404) {
      throw Exception('Url informada não encontrada!');
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }

  Future<List<DetailsModel>> getDetailsByMonthYear(
      int? month, int? year) async {
    final dynamic response;

    if (month != null && year == null) {
      response = await client.get(
        url:
            'https://dadosabertos.camara.leg.br/api/v2/deputados/$idDeputado/despesas?mes=$month',
      );
    } else if (month == null && year != null) {
      response = await client.get(
        url:
            'https://dadosabertos.camara.leg.br/api/v2/deputados/$idDeputado/despesas?ano=$year',
      );
    } else {
      response = await client.get(
        url:
            'https://dadosabertos.camara.leg.br/api/v2/deputados/$idDeputado/despesas?mes=$month&ano=$year',
      );
    }

    if (response.statusCode == 200) {
      final List<DetailsModel> details = [];
      final bodyDecode = jsonDecode(response.body);

      bodyDecode['dados'].map((expense) {
        details.add(DetailsModel.fromMap(expense));
      }).toList();

      return details;
    } else if (response.statusCode == 404) {
      throw Exception('Url informada não encontrada!');
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }

  getDetailsModelById() {}
}
