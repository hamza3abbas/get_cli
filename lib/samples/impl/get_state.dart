import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file for State creation.
class StateSample extends Sample {
  final String _fileName;
  StateSample(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => '''class ${_fileName.pascalCase}State {}''';
}
