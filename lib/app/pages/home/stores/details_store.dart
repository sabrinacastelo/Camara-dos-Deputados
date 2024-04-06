import 'package:api/app/data/models/details_model.dart';
import 'package:api/app/data/repositories/details_repository.dart';
import 'package:flutter/material.dart';


class DetailsStore {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<DetailsModel>> value =
      ValueNotifier<List<DetailsModel>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  final DetailsRepository repository;

  DetailsStore({
    required this.repository,
  });

  Future getExpenses() async {
    isLoading.value = true;

    try {
      final result = await repository.getDetailsById();
      value.value = result;
    } on Exception catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future getDetailsByMonthYear(int? month, int? year) async {
    isLoading.value = true;

    try {
      final result = await repository.getDetailsByMonthYear(month, year);
      value.value = result;
    } on Exception catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void getDetails() {}
}
