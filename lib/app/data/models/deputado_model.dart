class DeputadoModel {
  final String urlFoto;
  final String nome;
  final String siglaPartido;
  final String siglaUf;
  final int idLegislatura;
  final String email;
  final int id;

  DeputadoModel({
    required this.urlFoto,
    required this.nome,
    required this.siglaPartido,
    required this.siglaUf,
    required this.idLegislatura,
    required this.email,
    required this.id,
  });

  factory DeputadoModel.fromMap({required Map<String, dynamic> map}) {
    return DeputadoModel(
      urlFoto: map['urlFoto'] ?? '',
      nome: map['nome'] ?? '',
      siglaPartido: map['siglaPartido'] ?? '',
      siglaUf: map['siglaUf'] ?? '',
      idLegislatura: map['idLegislatura'] ?? 0,
      email: map['email'] ?? '',
      id: map['id'] ?? '',
    );
  }

}

