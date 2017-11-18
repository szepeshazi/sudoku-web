import 'dart:async';
import 'dart:io';
import 'package:grinder/grinder.dart';
import 'package:grinder/grinder_sdk.dart';
import 'package:grinder/grinder_tools.dart';

import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

Future<Null> main(List<String> args) => grind(args);

@Task('Starts all the things needed for dev')
@Depends(pubGet)
Future<Null> start() async {
  var watch = Dart.runAsync(r'tool/sass_watch.dart');
  var serve = runAsync(sdkBin('pub'), arguments: ['serve', 'web', '--port=8080']);
  await Future.wait([watch, serve]);
}

@Task('Run pub get on all dependant packages')
void pubGet() {
  var packageGlob = new Glob('**/pubspec.yaml');
  var packages = packageGlob.listSync(root: '..');
  for(FileSystemEntity entity in packages) {
    if(entity is File) {
      var packageDir = p.dirname(entity.path);
      print('Getting for: ${packageDir}');
      Pub.get(workingDirectory: packageDir);
    }
  }
}

@Task('Compile all SCSS files to CSS')
Future<Null> sass() async {
  Dart.run(r'tool/sass_build.dart');
}

@Task('Compile all SCSS files to CSS and keep watching changes')
Future<Null> sassWatch() async {
  Dart.run(r'tool/sass_watch.dart');
}

@Task('Runs build')
Future<Null> build() async {
  Pub.get();
  Pub.build();
}
