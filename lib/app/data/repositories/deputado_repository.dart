import 'dart:convert';
import 'package:api/app/data/http/exceptions.dart';
import 'package:api/app/data/http/http_client.dart';
import 'package:api/app/data/models/deputado_model.dart';

abstract class IDeputadoRepository {
  Future<List<DeputadoModel>> getDeputados();
}

class DeputadoRepository implements IDeputadoRepository {
  final IHttpClient client;
  DeputadoRepository({required this.client});

  @override
  Future<List<DeputadoModel>> getDeputados() async {
    final response = await client.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados',
    );

    if (response.statusCode == 200) {
      final List<DeputadoModel> deputados = [];

      final body = jsonDecode(response.body);

      body['dados'].map((pessoa) {
        final DeputadoModel deputado = DeputadoModel.fromMap(map: pessoa);
        deputados.add(deputado);
      }).toList();

      return deputados;
    }else if (response.statusCode == 404) {
      throw NotFoundException('Deputados não encontrados');
    }else{
      throw Exception('Erro ao buscar deputados');
    }
  }
}
