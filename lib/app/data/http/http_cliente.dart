import 'package:http/http.dart' as http;

abstract class IClienteHttp {
  Future get({required String url});
}

class HttpClient implements IClienteHttp {
  final cliente = http.Client();
  // HttpClient({required this.client});

  @override
  Future get({required String url}) async {
    return await cliente.get(Uri.parse(url));
  }
}

