import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file for State creation.
class BaseStateSample extends Sample {
  final String _fileName;
  BaseStateSample(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => '''
  class BaseState<T> {
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;
  var isSuccess = false.obs;
  var isEmpty = false.obs;
  var data = Rxn<T>();
}
''';
}
