import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path/path.dart' as path;
import 'package:material_color_utilities/utils/color_utils.dart' as mcu_utils;
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;
import 'package:material_color_utilities/hct/src/hct_solver.dart' as mcu_hct_solver;
import 'package:more/collection.dart';

class ColorNameMatcher {
  late Map<String, mcu.Hct> hctColorNames;
  late Map<String, mcu.Cam16> camColorNames;

  ColorNameMatcher(this.hctColorNames, this.camColorNames);

  static Future<ColorNameMatcher> fromFile(String relativePath) async {
    // String filePath = path.join(Directory.current.path, relativePath);
    String filePath = path.join(path.dirname(Platform.resolvedExecutable), relativePath);
    filePath = path.normalize(filePath);
    final colorNamesFile = File(filePath);

    final colorNamesCsv = CsvToListConverter(eol: '\n').convert(
        await colorNamesFile.readAsString()
    );

    final hctColorNames = {
      for (var v in colorNamesCsv)
        v[0].toString() : mcu.Hct.fromInt(mcu_utils.ColorUtils.argbFromRgb(v[2], v[3], v[4]))
    };

    final camColorNames = hctColorNames.map((key, value) => MapEntry(
        key.toString(),
        mcu_hct_solver.HctSolver.solveToCam(value.hue, value.chroma, value.tone))
    );

    return ColorNameMatcher(hctColorNames, camColorNames);
  }

  (String, mcu.Hct) match(mcu.Hct colorToMatch) {
    final distances = camColorNames.map((key, value) => MapEntry(
        key,
        value.distance(mcu_hct_solver.HctSolver.solveToCam(
            colorToMatch.hue, colorToMatch.chroma, colorToMatch.tone
        ))
    )).toBiMap();

    final minimalDistance = distances.values.min();
    final closestColorName = distances.inverse[minimalDistance];

    return (closestColorName!, hctColorNames[closestColorName]!);
  }
}
