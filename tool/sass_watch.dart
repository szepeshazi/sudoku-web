import 'dart:async';

import 'package:build_runner/build_runner.dart';
import 'package:sass_builder/phase.dart';

Future main() => watch([sassBuildAction], deleteFilesByDefault: true);