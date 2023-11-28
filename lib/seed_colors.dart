import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path/path.dart' as path;
import 'package:drmax_colors/utils.dart';

class SeedColors {
  late Map<String, RgbColor> colors;

  SeedColors(this.colors);

  static Future<SeedColors> fromFile(String relativePath) async {
    // String filePath = path.join(Directory.current.path, relativePath);
    String filePath = path.join(path.dirname(Platform.resolvedExecutable), relativePath);
    filePath = path.normalize(filePath);
    final seedColorFile = File(filePath);

    final seedColorCsv = CsvToListConverter(eol: '\n').convert(
        await seedColorFile.readAsString()
    );

    final seedColors = {
      for (var v in seedColorCsv)
        v[0].toString() : RgbColor.fromHex(v[1].toString())
    };

    return SeedColors(seedColors);
  }
}