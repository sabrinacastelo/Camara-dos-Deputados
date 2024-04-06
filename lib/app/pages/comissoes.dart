import 'package:api/app/data/http/http_cliente.dart';
import 'package:api/app/data/repositories/comissao_repository.dart';
import 'package:api/app/pages/home/stores/comissao_store.dart';
import 'package:flutter/material.dart';

class ComissoesBR extends StatefulWidget {
  const ComissoesBR({super.key});

  @override
  State<ComissoesBR> createState() => _HomePageState();
}

class _HomePageState extends State<ComissoesBR> {
  final ComissaoStore store = ComissaoStore(
    repository: ComissaoRepository(
      cliente: HttpClient(),
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
                final comissao = store.state.value[index];
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      
                    ),
                    ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(comissao.apelido,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                        subtitle: Text(
                          comissao.nomePublicacao,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
