import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class ControllerSample extends Sample {
  final String _fileName;
  final bool _isServer;
  ControllerSample(String path, this._fileName, this._isServer,
      {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => _isServer ? serverController : flutterController;

  String get serverController => '''import 'package:get_server/get_server.dart';
import '../${_fileName.snakeCase}/state.dart';
import '../${_fileName.snakeCase}/repo.dart';

class ${_fileName.pascalCase}Controller extends GetxController {
  final ${_fileName.pascalCase}State state = ${_fileName.pascalCase}State();
  final ${_fileName.pascalCase}Repo repo = ${_fileName.pascalCase}Repo();
  
  //TODO: Implement ${_fileName.pascalCase}Controller

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

}
''';

  String get flutterController => '''import 'package:get/get.dart';
import '../state.dart';
import '../repo.dart';

class ${_fileName.pascalCase}Controller extends GetxController {
  final ${_fileName.pascalCase}State state = ${_fileName.pascalCase}State();
  final ${_fileName.pascalCase}Repo repo = ${_fileName.pascalCase}Repo();
  
  //TODO: Implement ${_fileName.pascalCase}Controller

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }
  @override
  void onReady() {
    super.onReady();
  }
  @override
  void onClose() {
    super.onClose();
  }
  void increment() => count.value++;
}
''';
}
