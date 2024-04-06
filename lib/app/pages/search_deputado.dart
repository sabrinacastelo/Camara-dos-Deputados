// ignore_for_file: library_private_types_in_public_api

import 'package:api/app/data/models/busca_deputados.dart';
import 'package:api/app/pages/details_deputado.dart';
import 'package:flutter/material.dart';
import 'package:api/app/data/models/deputado_model.dart';
import 'package:api/app/data/repositories/deputado_repository.dart';
// import 'package:flutter/widgets.dart';

class SearchDeputado extends StatefulWidget {
  final DeputadoRepository deputadoRepository;

  const SearchDeputado({super.key, required this.deputadoRepository});

  @override
  _SearchDeputadoScreenState createState() => _SearchDeputadoScreenState();
}

class _SearchDeputadoScreenState extends State<SearchDeputado> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _partidoController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  DeputadoSearchService? _deputadoSearchService;
  List<DeputadoModel> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _deputadoSearchService =
        DeputadoSearchService(deputadoRepository: widget.deputadoRepository);
  }

  void _searchDeputado() async {
    final String nome = _nomeController.text;
    final String partido = _partidoController.text;
    final String estado = _estadoController.text;

    final List<DeputadoModel> results = await _deputadoSearchService!.search(
      nome: nome.isNotEmpty ? nome : null,
      partido: partido.isNotEmpty ? partido : null,
      estado: estado.isNotEmpty ? estado : null,
    );

    setState(() {
      _searchResults = results;
    });
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Pesquisar Deputado",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _partidoController,
              decoration: const InputDecoration(labelText: 'Partido'),
            ),
            TextField(
              controller: _estadoController,
              decoration: const InputDecoration(labelText: 'Estado'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchDeputado,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Pesquisar',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _searchResults.isNotEmpty
                  ? ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final pessoa = _searchResults[index];
                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 10.0,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DeputadoDetails(deputado: pessoa),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10),
                              ),
                            ),
                            child: ListTile(
                              leading: Image.network(pessoa.urlFoto),
                              title: Text(pessoa.nome),
                              subtitle: Text(pessoa.siglaPartido),
                              trailing: Text(pessoa.siglaUf),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(''),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
