import 'package:api/app/data/models/deputado_model.dart';
import 'package:api/app/data/repositories/deputado_repository.dart';

class DeputadoSearchService {
  final DeputadoRepository deputadoRepository;

  DeputadoSearchService({required this.deputadoRepository});

  Future<List<DeputadoModel>> search({
  String? nome,
  String? partido,
  String? estado,
}) async {
  final List<DeputadoModel> deputados = await deputadoRepository.getDeputados();
  
  List<DeputadoModel> resultados = deputados;

  if (nome != null && nome.isNotEmpty) {
    resultados = resultados.where((deputado) => deputado.nome.toLowerCase().contains(nome.toLowerCase())).toList();
  }

  if (partido != null && partido.isNotEmpty) {
    resultados = resultados.where((deputado) => deputado.siglaPartido.toLowerCase() == partido.toLowerCase()).toList();
  }

  if (estado != null && estado.isNotEmpty) {
    resultados = resultados.where((deputado) => deputado.siglaUf.toLowerCase() == estado.toLowerCase()).toList();
  }

  return resultados;
}

}
