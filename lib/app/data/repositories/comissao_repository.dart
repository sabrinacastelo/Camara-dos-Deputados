import 'dart:convert';
import 'package:api/app/data/http/exceptions.dart';
import 'package:api/app/data/http/http_cliente.dart';
import 'package:api/app/data/models/comissao_model.dart';

abstract class IComissaoRepository {
  Future<List<ComissaoModel>> getComissoes();
}

class ComissaoRepository implements IComissaoRepository {
  final IClienteHttp cliente;
  ComissaoRepository({required this.cliente});

  @override
  Future<List<ComissaoModel>> getComissoes() async {
    final response = await cliente.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/orgaos/',
    );

    if (response.statusCode == 200) {
      final List<ComissaoModel> comis = [];

      final body = jsonDecode(response.body);

      body['dados'].map((comissoes) {
        final ComissaoModel comissao = ComissaoModel.fromMap(map: comissoes);
        comis.add(comissao);
      }).toList();

      return comis;
    }else if (response.statusCode == 404) {
      throw NotFoundException('Deputados não encontrados');
    }else{
      throw Exception('Erro ao buscar deputados');
    }
  }
}

