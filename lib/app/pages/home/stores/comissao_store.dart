import 'package:api/app/data/http/exceptions.dart';
import 'package:api/app/data/models/comissao_model.dart';
import 'package:api/app/data/repositories/comissao_repository.dart';
import 'package:flutter/material.dart';

class ComissaoStore {
  final IComissaoRepository repository;

  //loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  //state
  final ValueNotifier<List<ComissaoModel>> state =
      ValueNotifier<List<ComissaoModel>>([]);

  //erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');
  ComissaoStore({required this.repository});

  Future getDeputados() async {
    isLoading.value = true;
    try {
      final result = await repository.getComissoes();
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
