import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file for State creation.
class BaseControllerSample extends Sample {
  final String _fileName;
  BaseControllerSample(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => '''
 import 'package:get/get.dart';
 import 'state.dart';

abstract class BaseController<T> extends GetxController {
  final BaseState<T> baseState = BaseState<T>();
  Future<dynamic> fetchData();

  void loadData() async {
    try {
      baseState.isLoading.value = true;
      baseState.isError.value = false;
      baseState.isSuccess.value = false;
      baseState.isEmpty.value = false;

      final result = await fetchData();

      if (result == null || (result is List && result.isEmpty)) {
        baseState.isEmpty.value = true;
      } else {
        baseState.data.value = result;
        baseState.isSuccess.value = true;
      }
    } catch (e) {
      baseState.isError.value = true;
      baseState.errorMessage.value = e.toString();
    } finally {
      baseState.isLoading.value = false;
    }
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }
}
''';
}
