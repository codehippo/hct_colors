import 'package:material_color_utilities/material_color_utilities.dart' as mcu;
import 'package:drmax_colors/utils.dart';

class HctPalettes {
  late Map<String, mcu.Hct> hctSeedColors;
  late List<List<num>> blurredGamutBoundaries;

  HctPalettes(this.hctSeedColors, this.blurredGamutBoundaries);

  Map<String, List<mcu.Hct>> getHctPalettesFromSeedColors() {
    return hctSeedColors.map((key, value) {
      bool directionLighterIsMoreSaturated = maxChromaDerivatives[value.hue.round()] > 0;

      var hueTwists = _calculateHueTwists(value, directionLighterIsMoreSaturated);
      var hues = _generateHues(value, hueTwists, directionLighterIsMoreSaturated);
      var colorPalette = _createColorPalette(hues, value);

      return MapEntry(key, colorPalette);
    });
  }

  (double, double) _calculateHueTwists(mcu.Hct value, bool directionLighterIsMoreSaturated) {
    var lowerTwist = value.tone / 100 * hueTwist;
    var upperTwist = (100 - value.tone) / 100 * hueTwist;

    double lowerHue = value.hue + (directionLighterIsMoreSaturated ? -lowerTwist : lowerTwist);
    double upperHue = value.hue + (directionLighterIsMoreSaturated ? upperTwist : -upperTwist);

    for (var minMaxHue in minimaMaximaHues) {
      lowerHue = _adjustHue(minMaxHue, lowerHue, value.hue, directionLighterIsMoreSaturated);
      upperHue = _adjustHue(minMaxHue, upperHue, value.hue, !directionLighterIsMoreSaturated);
    }

    return (lowerHue, upperHue);
  }

  double _adjustHue(double minMaxHue, double targetHue, double referenceHue, bool isUpper) {
    return minMaxHue.clamp(
        isUpper ? targetHue : referenceHue,
        isUpper ? referenceHue : targetHue
    ) == minMaxHue ? minMaxHue : targetHue;
  }

  List<double> _generateHues(mcu.Hct value, (double, double) hueTwists, bool directionLighterIsMoreSaturated) {
    var newHueTwist = (hueTwists.$2 - hueTwists.$1).abs();

    return lightnessValues.map((lightness) {
      var hueShift = (lightness - value.tone) / 100 * newHueTwist;

      return (value.hue +
          (directionLighterIsMoreSaturated ? hueShift : -hueShift)
      ) % 360;
    }).toList();
  }

  List<mcu.Hct> _createColorPalette(List<double> hues, mcu.Hct seedColor) {
    return List<mcu.Hct>.generate(lightnessValues.length, (i) {
      var hue = hues[i];
      var chroma = seedColor.chroma.clamp(0.0, blurredGamutBoundaries[i][hue.round()]) as double;
      var lightness = lightnessValues[i];

      return mcu.Hct.from(hue, chroma, lightness);
    });
  }
}
