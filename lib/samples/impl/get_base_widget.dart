import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file for State creation.
class BaseWidgetSample extends Sample {
  final String _fileName;
  BaseWidgetSample(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => '''
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
}
