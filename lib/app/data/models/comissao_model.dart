class ComissaoModel {
  final String apelido;
  final String nomePublicacao;
  final int codTipoOrgao;
  final String tipoOrgao;

  ComissaoModel({
    required this.apelido,
    required this.nomePublicacao,
    required this.codTipoOrgao,
    required this.tipoOrgao,
  });

  factory ComissaoModel.fromMap({required Map<String, dynamic> map}) {
    return ComissaoModel(
      apelido: map['apelido'] ?? '',
      nomePublicacao: map['nomePublicacao'] ?? '',
      codTipoOrgao: map['codTipoOrgao'] ?? 0,
      tipoOrgao: map['tipoOrgao'] ?? '',
    );
  }
}
