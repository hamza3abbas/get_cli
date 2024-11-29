import 'dart:io';
import 'package:dcli/dcli.dart'; // Importing dcli for better terminal utilities
import '../../../../common/menu/menu.dart';
import '../../../../common/utils/logger/log_utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../interface/command.dart';

/// The command creates a `base` directory with controller, state, and widget files.
class CreateBaseCommand extends Command {
  @override
  String get commandName => 'base';

  @override
  List<String> get alias => ['-b'];

  @override
  Future<void> execute() async {
    var dirName = 'base';
    var basePath = Directory(dirName);

    // Check if the directory already exists
    if (basePath.existsSync()) {
      final menu = Menu(
        [
          LocaleKeys.options_yes.tr,
          LocaleKeys.options_no.tr,
          LocaleKeys.options_rename.tr,
        ],
        title: Translation(LocaleKeys.ask_existing_page.trArgs([dirName]))
            .toString(),
      );
      final result = menu.choose();

      if (result.index == 0) {
        _createFiles(basePath, overwrite: true);
      } else if (result.index == 2) {
        var newName = ask(LocaleKeys.ask_existing_page.tr);
        var newPath = Directory(newName);
        _createFiles(newPath, overwrite: false);
      }
    } else {
      // If the directory doesn't exist, create it
      basePath.createSync(recursive: true);
      LogService.success(LocaleKeys.sucess_file_created.trArgs([dirName]));
      _createFiles(basePath, overwrite: false);
    }
  }

  /// Creates the required files in the given directory
  void _createFiles(Directory basePath, {bool overwrite = false}) {
    _createFile('${basePath.path}/controller.dart', _controllerTemplate(),
        'Controller', overwrite);
    _createFile(
        '${basePath.path}/state.dart', _stateTemplate(), 'State', overwrite);
    _createFile(
        '${basePath.path}/widget.dart', _widgetTemplate(), 'Widget', overwrite);
  }

  /// Helper to create individual files with content if they don't exist
  void _createFile(
      String filePath, String content, String fileType, bool overwrite) {
    var file = File(filePath);
    if (file.existsSync() && !overwrite) {
      LogService.info('$fileType file already exists at $filePath');
    } else {
      file.writeAsStringSync(content);
      LogService.success('$fileType file created at $filePath');
    }
  }

  String _controllerTemplate() => '''
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

  String _stateTemplate() => '''
  class BaseState<T> {
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;
  var isSuccess = false.obs;
  var isEmpty = false.obs;
  var data = Rxn<T>();
}
''';

  String _widgetTemplate() => '''
 import 'package:flutter/material.dart';
 import 'package:get/get.dart';

 import 'controller.dart';

class BaseWidget<T> extends StatelessWidget {
  final BaseController<T> controller;
  final Widget Function(T? data) successBuilder;
  final Widget? emptyStateWidget; // Widget to show when data is empty
  final VoidCallback? onRetry;

  const BaseWidget({
    Key? key,
    required this.controller,
    required this.successBuilder,
    this.emptyStateWidget,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.baseState.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.baseState.isError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.baseState.errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      } else if (controller.baseState.isEmpty.value) {
        return emptyStateWidget ??
            const Center(child: Text("No Data Available"));
      } else if (controller.baseState.isSuccess.value) {
        return successBuilder(controller.baseState.data.value);
      } else {
        return const SizedBox();
      }
    });
  }
}
''';

  @override
  String? get hint =>
      'Creates a base directory with controller, state, and widget files.';

  @override
  String get codeSample => 'get create base';

  @override
  int get maxParameters => 0;
}
