import 'dart:convert';
import 'package:api/app/data/http/http_client.dart';
import 'package:api/app/data/models/deputado_details_model.dart';


class DeputadoDetailsRepository {
  final HttpClient client;
  final int idDeputado;

  DeputadoDetailsRepository({
    required this.client,
    required this.idDeputado,
  });

  Future<DeputadoDetailsModel> getDeputadosDetailsById() async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados/$idDeputado',
    );

    if (response.statusCode == 200) {
      final bodyDecode = jsonDecode(response.body);
      return DeputadoDetailsModel.fromMap(bodyDecode['dados']);
    } else if (response.statusCode == 404) {
      throw Exception('Url informada não encontrada!');
    } else {
      throw Exception('Erro: ${response.statusCode}');
    }
  }
}
