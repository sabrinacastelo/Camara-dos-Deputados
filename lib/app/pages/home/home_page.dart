import 'package:api/app/data/http/http_client.dart';
// import 'package:api/app/data/models/deputado_model.dart';
import 'package:api/app/data/repositories/deputado_repository.dart';
import 'package:api/app/pages/comissoes.dart';
import 'package:api/app/pages/deputados_br.dart';
import 'package:api/app/pages/home/stores/deputado_store.dart';
import 'package:api/app/pages/search_deputado.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DeputadoStore store = DeputadoStore(
    repository: DeputadoRepository(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    store.getDeputados();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 375.0,
              height: 125.0,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.people, color: Colors.white, size: 35.0),
                label: const Text('DEPUTADOS',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DeputadosBr()),
                  );
                },
              ),
            ),
            Container(
              width: 375.0,
              height: 125.0,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.group_work,
                    color: Colors.white,
                    size: 35.0), // Adiciona um ícone de grupo
                label: const Text('COMISSÕES',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ), // Define a cor do botão para verde
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    // Substitua isso pela rota correta para a tela de Comissões
                    MaterialPageRoute(
                        builder: (context) => const ComissoesBR()),
                  );
                },
              ),
            ),
            Container(
              width: 375.0,
              height: 125.0,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton.icon(
                icon: const Center(
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 35,
                  ),
                ), // Adiciona um ícone de pesquisa
                label: const Text('PESQUISAR DEPUTADOS',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchDeputado(
                        deputadoRepository:
                            DeputadoRepository(client: HttpClient()),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
