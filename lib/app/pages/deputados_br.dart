import 'package:api/app/data/http/http_client.dart';
import 'package:api/app/data/repositories/deputado_repository.dart';
import 'package:api/app/pages/details_deputado.dart';
import 'package:api/app/pages/home/stores/deputado_store.dart';
import 'package:flutter/material.dart';

class DeputadosBr extends StatefulWidget {
  const DeputadosBr({super.key});

  @override
  State<DeputadosBr> createState() => _HomePageState();
}

class _HomePageState extends State<DeputadosBr> {
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
      body: AnimatedBuilder(
        animation: Listenable.merge([
          store.isLoading,
          store.erro,
          store.state,
        ]),
        builder: (context, child) {
          if (store.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (store.erro.value.isNotEmpty) {
            return Center(
              child: Text(
                store.erro.value,
                style: const TextStyle(
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (store.state.value.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum deputado encontrado',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                height: 32,
              ),
              padding: const EdgeInsets.all(16),
              itemCount: store.state.value.length,
              itemBuilder: (context, index) {
                final pessoa = store.state.value[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeputadoDetails(deputado: pessoa)),
                    );
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(80, 64, 162, 103),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(pessoa.urlFoto),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            pessoa.nome,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pessoa.siglaPartido,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                pessoa.siglaUf,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
