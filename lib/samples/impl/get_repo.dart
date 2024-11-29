import 'package:recase/recase.dart';

import '../interface/sample_interface.dart';

/// [Sample] file for Repo creation.
class RepoSample extends Sample {
  final String _fileName;
  RepoSample(String path, this._fileName, {bool overwrite = false})
      : super(path, overwrite: overwrite);

  @override
  String get content => '''class ${_fileName.pascalCase}Repo {}''';
}
