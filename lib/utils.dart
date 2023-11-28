import 'dart:math' as math;
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;

const List<double> grayLightnessValues = [0.0, 5.0, 10.0, 15.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 85.0, 90.0, 92.5, 95.0, 97.5, 98.75];
const List<double> lightnessValues = [10, 20, 30, 40, 50, 60, 70, 80, 90, 94.5, 97.5];
const List<num> lightnessNames = [900, 800, 700, 600, 500, 400, 300, 200, 100, 50, 25];
const List<double> dynamicRanges = [2.931, 2.636, 2.569, 2.543, 2.529, 2.543, 2.569, 2.636, 2.931, 3.367, 4.543];
const List<double> maxChromaDerivatives = [-0.114, -0.104, -0.092, -0.098, -0.104, -0.103, -0.102, -0.093, -0.085, -0.085, -0.085, -0.085, -0.083, -0.082, -0.079, -0.076, -0.056, -0.026, -0.010, 0.010, 0.041, 0.068, 0.097, 0.138, 0.173, 0.210, 0.247, 0.284, 0.327, 0.368, 0.398, 0.426, 0.452, 0.475, 0.494, 0.511, 0.524, 0.535, 0.543, 0.539, 0.540, 0.533, 0.517, 0.511, 0.505, 0.492, 0.488, 0.484, 0.464, 0.462, 0.459, 0.457, 0.455, 0.444, 0.441, 0.439, 0.437, 0.435, 0.425, 0.422, 0.421, 0.419, 0.418, 0.418, 0.426, 0.416, 0.415, 0.414, 0.414, 0.415, 0.416, 0.418, 0.421, 0.432, 0.425, 0.425, 0.427, 0.428, 0.438, 0.438, 0.439, 0.441, 0.452, 0.463, 0.466, 0.470, 0.474, 0.478, 0.483, 0.497, 0.511, 0.516, 0.530, 0.546, 0.554, 0.562, 0.579, 0.597, 0.616, 0.625, 0.613, 0.606, 0.596, 0.572, 0.543, 0.518, 0.488, 0.438, 0.392, 0.351, 0.298, 0.243, 0.194, 0.146, 0.083, 0.029, -0.013, -0.069, -0.121, -0.151, -0.187, -0.227, -0.254, -0.284, -0.296, -0.290, -0.301, -0.312, -0.305, -0.308, -0.319, -0.320, -0.312, -0.293, -0.280, -0.264, -0.247, -0.235, -0.222, -0.198, -0.175, -0.159, -0.134, -0.110, -0.095, -0.073, -0.043, -0.021, 0.000, 0.019, 0.028, 0.044, 0.057, 0.061, 0.071, 0.079, 0.078, 0.076, 0.065, 0.056, 0.055, 0.054, 0.051, 0.057, 0.065, 0.065, 0.064, 0.064, 0.064, 0.065, 0.065, 0.057, 0.051, 0.054, 0.055, 0.056, 0.056, 0.055, 0.054, 0.051, 0.048, 0.054, 0.061, 0.060, 0.051, 0.040, 0.027, 0.013, -0.011, -0.036, -0.055, -0.075, -0.099, -0.124, -0.152, -0.180, -0.210, -0.241, -0.271, -0.301, -0.330, -0.358, -0.383, -0.407, -0.428, -0.447, -0.471, -0.491, -0.500, -0.500, -0.491, -0.489, -0.487, -0.485, -0.483, -0.481, -0.479, -0.477, -0.475, -0.474, -0.473, -0.472, -0.472, -0.472, -0.473, -0.464, -0.464, -0.473, -0.475, -0.467, -0.468, -0.477, -0.479, -0.481, -0.483, -0.493, -0.494, -0.496, -0.506, -0.509, -0.513, -0.517, -0.520, -0.533, -0.538, -0.543, -0.556, -0.562, -0.568, -0.582, -0.604, -0.610, -0.607, -0.622, -0.646, -0.661, -0.669, -0.688, -0.708, -0.728, -0.748, -0.769, -0.790, -0.813, -0.846, -0.872, -0.896, -0.930, -0.965, -1.003, -1.032, -1.043, -1.049, -1.040, -1.015, -0.992, -0.960, -0.918, -0.868, -0.802, -0.729, -0.650, -0.566, -0.487, -0.398, -0.308, -0.219, -0.133, -0.051, 0.033, 0.102, 0.165, 0.230, 0.295, 0.344, 0.379, 0.401, 0.414, 0.418, 0.423, 0.436, 0.440, 0.444, 0.457, 0.460, 0.464, 0.477, 0.483, 0.496, 0.509, 0.515, 0.521, 0.527, 0.540, 0.553, 0.568, 0.575, 0.581, 0.596, 0.612, 0.629, 0.647, 0.657, 0.657, 0.645, 0.627, 0.613, 0.595, 0.564, 0.526, 0.492, 0.446, 0.397, 0.344, 0.289, 0.242, 0.195, 0.140, 0.085, 0.033, -0.014, -0.047, -0.077, -0.118, -0.156, -0.179, -0.198, -0.204, -0.200, -0.186, -0.173, -0.168, -0.171, -0.167, -0.156, -0.153, -0.149, -0.137, -0.127, -0.124, -0.122];
const List<double> minimaMaximaHues = [18.5, 115.5, 148.0, 187.5, 288.5, 339.5];

const double chromaMax = 145;
const int hueMax = 360;
const double hueTwist = 12;

class RgbColor {
  late int r;
  late int g;
  late int b;

  RgbColor(this.r, this.g, this.b);

  RgbColor.fromHex(String hex) {
    final intColor = int.parse(hex.replaceAll('#', ''), radix: 16);

    r = (intColor >> 16) & 0xff;
    g = (intColor >> 8) & 0xff;
    b = (intColor >> 0) & 0xff;
  }

  RgbColor.fromArgb(int argbColor) {
    r = (argbColor >> 16) & 0xff;
    g = (argbColor >> 8) & 0xff;
    b = (argbColor >> 0) & 0xff;
  }

  String get hex {
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }
}

class Kernel {
  late List<num> coefficients;

  Kernel(int radius) {
    coefficients = List<num>.filled(2 * radius + 1, 0);
  }

  void scaleCoefficients(num scale) {
    for (var i = 0; i < coefficients.length; i++) {
      coefficients[i] *= scale;
    }
  }
}

class GaussianBlurWithinGamut {
  final int radius;
  late Kernel gaussianKernel;
  late List<num> gamut;

  GaussianBlurWithinGamut(this.radius) {
    _calculateKernel();
  }

  int get width => 2 * radius + 1;

  void _calculateKernel() {
    final num sigma = radius * (2.0 / 3.0);
    final num s = 2.0 * sigma * sigma;

    num sum = 0.0;
    gaussianKernel = Kernel(radius);

    for (var x = -radius; x <= radius; x++) {
      final num c = math.exp(-(x * x) / s);
      sum += c;
      gaussianKernel.coefficients[x + radius] = c;
    }

    gaussianKernel.scaleCoefficients(1.0 / sum);
  }

  List<num> convolution(List<num> data) {
    final paddedData = [
      ...data.sublist(data.length - radius),
      ...data,
      ...data.sublist(0, radius)
    ];

    return List<num>.generate(paddedData.length - width + 1, (index) {
      final window = paddedData.sublist(index, index + width);
      return List<num>.generate(window.length, (i) => window[i] * gaussianKernel.coefficients[i])
          .reduce((a, b) => a + b);
    });
  }

  List<num> blurAndContainWithinGamut({
    required List<num> data,
    required List<num> gamut,
    required num targetDynamicRange,
  }) {
    this.gamut = gamut;
    var blurredData = data;

    num dynamicRange;
    do {
      blurredData = _applyGamut(blurredData, gamut);
      blurredData = convolution(blurredData);
      dynamicRange = _calculateDynamicRange(blurredData);
    } while (dynamicRange > targetDynamicRange);

    return blurredData;
  }

  List<num> _applyGamut(List<num> data, List<num> gamut) {
    return List<num>.generate(data.length, (i) => math.min(data[i], gamut[i]));
  }

  num _calculateDynamicRange(List<num> data) {
    final maxValue = data.reduce(math.max);
    final minValue = data.reduce(math.min);
    return maxValue / minValue;
  }

  List<List<num>> getBlurredGamutBoundaries() {
    var hueList = List<double>.generate(hueMax + 1, (index) => index.toDouble());
    var gamutLimitedChromas = lightnessValues.map((lightness) => _getGamutLimitedChromas(hueList, lightness)).toList();

    return List<List<num>>.generate(gamutLimitedChromas.length, (i) =>
        blurAndContainWithinGamut(
            data: gamutLimitedChromas[i],
            gamut: gamutLimitedChromas[i],
            targetDynamicRange: dynamicRanges[i]
        )
    );
  }

  List<num> _getGamutLimitedChromas(List<double> hueList, double lightness) {
    return hueList.map((hue) {
      var hctColorOriginal = mcu.Hct.from(hue, chromaMax, lightness);
      var hctColorGamutLimited = mcu.Hct.fromInt(hctColorOriginal.toInt());
      
      return hctColorGamutLimited.chroma;
    }).toList();
  }
}