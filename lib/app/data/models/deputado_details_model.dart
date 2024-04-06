class DeputadoDetailsModel {
  final String? nome;
  final String? civilNome;
  final String? situacao;
  final String? condicao;
  final String? status;
  final String? cpf;
  final String? sexo;
  final String? website;
  final List<dynamic>? socialMedia;
  final String? birthDate;
  final String? deathDate;
  final String? birthUf;
  final String? birthCity;
  final String? educacao;
  final Map<String, dynamic>? gabinete;

  DeputadoDetailsModel({
    this.nome,
    this.civilNome,
    this.situacao,
    this.condicao,
    this.status,
    this.cpf,
    this.sexo,
    this.website,
    this.socialMedia,
    this.birthDate,
    this.deathDate,
    this.birthUf,
    this.birthCity,
    this.educacao,
    this.gabinete,
  });

  factory DeputadoDetailsModel.fromMap(Map<String, dynamic> map) {
    return DeputadoDetailsModel(
      nome: map['ultimoStatus']['nomeEleitoral'] ?? '',
      civilNome: map['nomeCivil'] ?? '',
      situacao: map['ultimoStatus']['situacao'] ?? '',
      condicao: map['ultimoStatus']['condicaoEleitoral'] ?? '',
      status: map['ultimoStatus']['descricaoStatus'] ?? '',
      cpf: map['cpf'] ?? '',
      sexo: map['sexo'] ?? '',
      website: map['urlWebsite'] ?? '',
      socialMedia: map['redeSocial'] ?? [],
      birthDate: map['dataNascimento'] ?? '',
      deathDate: map['dataFalecimento'] ?? '',
      birthUf: map['ufNascimento'] ?? '',
      birthCity: map['municipioNascimento'] ?? '',
      educacao: map['escolaridade'] ?? '',
      gabinete: map['ultimoStatus']['gabinete'] ?? {},
    );
  }
}
