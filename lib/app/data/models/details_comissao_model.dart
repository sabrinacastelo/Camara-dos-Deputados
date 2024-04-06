class ComissaoDetailsModel {
  final String apelido;
  final String nomePublicacao;
  final int codTipoOrgao;
  final String tipoOrgao;

  ComissaoDetailsModel({
    this.apelido = '',
    this.nomePublicacao = '',
    this.codTipoOrgao = 0,
    this.tipoOrgao = '',
  });

  factory ComissaoDetailsModel.fromMap(Map<String, dynamic> map) {
    return ComissaoDetailsModel(
      apelido: map['apelido'] ?? '',
      nomePublicacao: map['nomePublicacao'] ?? '',
      codTipoOrgao: map['codTipoOrgao'] ?? 0,
      tipoOrgao: map['tipoOrgao'] ?? '',
    );
  }
}
