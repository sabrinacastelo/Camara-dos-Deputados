import 'package:api/app/data/http/exceptions.dart';
import 'package:api/app/data/models/deputado_model.dart';
import 'package:api/app/data/repositories/deputado_repository.dart';
import 'package:flutter/material.dart';

class DeputadoStore {
  final IDeputadoRepository repository;

  //loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  //state
  final ValueNotifier<List<DeputadoModel>> state =
      ValueNotifier<List<DeputadoModel>>([]);

  //erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');
  DeputadoStore({required this.repository});

  Future getDeputados() async {
    isLoading.value = true;
    try {
      final result = await repository.getDeputados();
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
