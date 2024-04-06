import 'package:api/app/data/http/http_client.dart';
import 'package:api/app/data/models/deputado_model.dart';
import 'package:api/app/data/models/details_model.dart';
import 'package:api/app/data/repositories/details_deputado_repository.dart';
import 'package:api/app/data/repositories/details_repository.dart';
import 'package:api/app/pages/home/stores/details_deputado_store.dart';
import 'package:api/app/pages/home/stores/details_store.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class DeputadoDetails extends StatefulWidget {
  final DeputadoModel deputado;

  const DeputadoDetails({
    super.key,
    required this.deputado,
  });

  @override
  State<DeputadoDetails> createState() => _DeputadoDetailsState();
}

class _DeputadoDetailsState extends State<DeputadoDetails> {

  late DeputadoDetailsStore storeDeputadoDetails;
  late DetailsStore storeDetails;

  final List<Map<int, String>> months = [
    {0: 'Mês'},
    {1: 'Janeiro'},
    {2: 'Fevereiro'},
    {3: 'Março'},
    {4: 'Abril'},
    {5: 'Maio'},
    {6: 'Junho'},
    {7: 'Julho'},
    {8: 'Agosto'},
    {9: 'Setembro'},
    {10: 'Outubro'},
    {11: 'Novembro'},
    {12: 'Dezembro'},
  ];
  final List<int> years = [
    2024,
    2023,
    2022,
    2021,
    2020,
    2019,
    2018,
    2017,
    2016,
    2015,
    2014,
  ];
  int _getMonth = 0;
  int _getYear = 2024;

  void _changeMonth(int month) {
    setState(() {
      _getMonth = month;
    });
  }

  void _changeYear(int year) {
    setState(() {
      _getYear = year;
    });
  }

  @override
  void initState() {
    super.initState();

    storeDeputadoDetails = DeputadoDetailsStore(
      repository: DeputadoDetailsRepository(
        client: HttpClient(),
        idDeputado: widget.deputado.id,
      ),
    );
    storeDeputadoDetails.getDeputadoDetails();

    storeDetails = DetailsStore(
      repository: DetailsRepository(
        client: HttpClient(),
        idDeputado: widget.deputado.id,
      ),
    );
    storeDetails.getDetails();
  }

  List<DetailsModel> getDetailsByMonthYear(int? month, int? year) {
    storeDetails.getDetailsByMonthYear(month, year);
    return storeDetails.value.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
        title: PreferredSize(
          preferredSize:
              const Size.fromHeight(50.0), // altere o valor conforme necessário
          child: Image.network(
              "https://logodownload.org/wp-content/uploads/2017/11/camara-dos-deputados-logo-8.png"),
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(254, 254, 254, 1),
        child: AnimatedBuilder(
          animation: Listenable.merge(
            [
              // Store de detalhes do deputado
              storeDeputadoDetails.isLoading,
              storeDeputadoDetails.error,
              storeDeputadoDetails.value,
              // Store de despesas
              storeDetails.isLoading,
              storeDetails.error,
              storeDetails.value,
            ],
          ),
          builder: (context, _) {
            if (storeDeputadoDetails.isLoading.value ||
                storeDetails.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.amber),
                ),
              );
            }

            if (storeDeputadoDetails.error.value.isNotEmpty) {
              return Center(
                child: Text(storeDeputadoDetails.error.value),
              );
            }

            if (storeDeputadoDetails.value.value.nome == null) {
              return const Center(
                child: Text('Nenhum dado encontrado!'),
              );
            }

            final deputadoDetails = storeDeputadoDetails.value.value;
            final expenses = storeDetails.value.value;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      deputadoDetails.civilNome ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      // Primeiro Container - Informações do Deputado
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        color:  Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 230,
                        child: PageView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 20,
                              child: Column(
                                children: [
                                  const Text(
                                    'Informações do Deputado',
                                    style: TextStyle(
                                      color:  Color.fromRGBO(86, 185, 82, 1),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    thickness: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                widget.deputado.urlFoto,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            if (widget.deputado.nome.length > 15)
                                              Text(
                                                '${widget.deputado.nome.substring(0, 14)}...',
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(86, 185, 82, 1),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            if (widget.deputado.nome.length <= 15)
                                              Text(
                                                widget.deputado.nome,
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(86, 185, 82, 1),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  color: Color.fromRGBO(86, 185, 82, 1),
                                                  Icons.group,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  widget.deputado.siglaPartido,
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(86, 185, 82, 1),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  color: Colors.white,
                                                  Icons.location_on,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  widget.deputado.siglaUf,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Situação:',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(86, 185, 82, 1),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  deputadoDetails.situacao ?? '',
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(86, 185, 82, 1),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Condição Eleitoral:',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(86, 185, 82, 1),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Flexible(
                                                  child: Text(
                                                    deputadoDetails.condicao ??
                                                        '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(86, 185, 82, 1),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Escolaridade:',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(86, 185, 82, 1),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Flexible(
                                                  child: Text(
                                                    deputadoDetails.educacao ??
                                                        '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(86, 185, 82, 1),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Gênero:',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(86, 185, 82, 1),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  deputadoDetails.sexo ?? '',
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(86, 185, 82, 1),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'UF Nascimento: ',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(86, 185, 82, 1),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  deputadoDetails.birthUf ?? '',
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(86, 185, 82, 1),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Nasc.:',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(86, 185, 82, 1),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Flexible(
                                                  child: Text(
                                                    deputadoDetails.birthDate ??
                                                        '',
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(86, 185, 82, 1),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (deputadoDetails.deathDate != '')
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Data de Falec.:',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(86, 185, 82, 1),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    deputadoDetails.deathDate ??
                                                        '',
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(86, 185, 82, 1),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'CPF:',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(86, 185, 82, 1),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  deputadoDetails.cpf ?? '',
                                                  style: const TextStyle(
                                                    color: Color.fromRGBO(86, 185, 82, 1),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 20,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Gabinete',
                                      style: TextStyle(
                                        color: Color.fromRGBO(86, 185, 82, 1),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Divider(
                                      color: Color.fromRGBO(86, 185, 82, 1),
                                      thickness: 1,
                                    ),
                                    for (var gabinete
                                        in deputadoDetails.gabinete!.entries)
                                      Row(
                                        children: [
                                          Text(
                                            // Primeira letra maiúscula
                                            '${gabinete.key[0].toUpperCase() + gabinete.key.substring(1)}: ',
                                            style: const TextStyle(
                                              color: Color.fromRGBO(86, 185, 82, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            gabinete.value,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(86, 185, 82, 1),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      // Segundo Container - Despesas do Deputado
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:  Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(86, 185, 82, 1),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Despesas',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Total:',
                                        style: TextStyle(
                                          color: Color.fromRGBO(86, 185, 82, 1),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'R\$ ${expenses.fold<double>(0, (total, expense) => total + expense.documentValue).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Color.fromRGBO(86, 185, 82, 1),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              // Dropdown para selecionar o mês
                              DropdownButton<String>(
                                value: months[_getMonth].values.first,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color.fromRGBO(86, 185, 82, 1),
                                ),
                                onChanged: (String? value) => setState(() {
                                  final month = months.indexWhere((element) {
                                    return element.values.contains(value);
                                  });
                                  _changeMonth(month);
                                  getDetailsByMonthYear(_getMonth, _getYear);
                                }),
                                items: [
                                  for (final month in months)
                                    DropdownMenuItem(
                                      value: month.values.first,
                                      child: Text(
                                        month.values.first,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 5),
                              // Dropdown para selecionar o ano
                              DropdownButton<int>(
                                value: years[years.indexOf(_getYear)],
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                onChanged: (int? value) => setState(() {
                                  _changeYear(value!);
                                  getDetailsByMonthYear(_getMonth, _getYear);
                                }),
                                items: [
                                  for (final year in years)
                                    DropdownMenuItem(
                                      value: year,
                                      child: Text(
                                        year.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 300,
                            child: ListView.builder(
                              itemCount: expenses.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final expense = expenses[index];
                                return Container(
                                  width: 350,
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                expense.documentType,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Nº ${expense.documentNumber.replaceAll(
                                                  RegExp(r'\D'),
                                                  '',
                                                )}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${expense.month}/${expense.year}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Valor:',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    'R\$ ${expense.documentValue.toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        color: Color.fromRGBO(86, 185, 82, 1),
                                        thickness: 1,
                                      ),
                                      const Text(
                                        'Tipo:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        expense.type,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Fornecedor:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        expense.providerName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'CNPJ/CPF do Fornecedor:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        expense.providerCnpj,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Container(
                    //   // Terceiro Container - Ocupações do Deputado
                    //   padding: const EdgeInsets.all(8.0),
                    //   decoration: BoxDecoration(
                    //     color: const Color.fromRGBO(86, 185, 82, 1),
                    //     borderRadius: BorderRadius.circular(10),
                    //     boxShadow: const [
                    //       BoxShadow(
                    //         color: Colors.white,
                    //         blurRadius: 5,
                    //         offset: Offset(0, 2),
                    //       ),
                    //     ],
                    //   ),
                    //   child: const Column(
                    //     children: [
                    //       Text(
                    //         'Ocupações do Deputado',
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //       Divider(
                    //         color: Colors.white,
                    //         thickness: 1,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // Container(
                    //   // Quarto Container - Histórico do Deputado
                    //   padding: const EdgeInsets.all(8.0),
                    //   decoration: BoxDecoration(
                    //     color: const Color.fromRGBO(86, 185, 82, 1),
                    //     borderRadius: BorderRadius.circular(10),
                    //     boxShadow: const [
                    //       BoxShadow(
                    //         color: Colors.white,
                    //         blurRadius: 5,
                    //         offset: Offset(0, 2),
                    //       ),
                    //     ],
                    //   ),
                    //   child: const Column(
                    //     children: [
                    //       Text(
                    //         'Histórico do Deputado',
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //       Divider(
                    //         color: Colors.white,
                    //         thickness: 1,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
