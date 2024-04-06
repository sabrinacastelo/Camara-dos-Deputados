import 'package:api/app/data/models/deputado_details_model.dart';
import 'package:api/app/data/repositories/details_deputado_repository.dart';
import 'package:flutter/material.dart';

class DeputadoDetailsStore {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<DeputadoDetailsModel> value =
      ValueNotifier<DeputadoDetailsModel>(DeputadoDetailsModel());
  final ValueNotifier<String> error = ValueNotifier<String>('');

  final DeputadoDetailsRepository repository;

  DeputadoDetailsStore({
    required this.repository,
  });

  Future getDeputadoDetails() async {
    isLoading.value = true;

    try {
      final result = await repository.getDeputadosDetailsById();
      value.value = result;
    } on Exception catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }  
}
