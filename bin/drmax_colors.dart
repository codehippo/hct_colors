import 'dart:async';
import 'dart:core';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:drmax_colors/seed_colors.dart';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;
import 'package:material_color_utilities/utils/color_utils.dart' as mcu_utils;
import 'package:drmax_colors/utils.dart';
import 'package:drmax_colors/color_names.dart';
import 'package:drmax_colors/palette.dart';
import 'package:excel/excel.dart';

const String excelFileName = 'output.xlsx';

Future<void> main(List<String> arguments) async {
  var blur = GaussianBlurWithinGamut(12);
  final blurredGamutBoundaries = blur.getBlurredGamutBoundaries();

  final seedColors = (await SeedColors.fromFile('seed_colors.csv')).colors;
  final colorNameMatcher = await ColorNameMatcher.fromFile('color_names.csv');

  var hctSeedColors = seedColors.map((key, value) => MapEntry(
    key,
    mcu.Hct.fromInt(mcu_utils.ColorUtils.argbFromRgb(
      value.r, value.g, value.b
    )))
  );

  final closestNames = hctSeedColors.map((key, value) => MapEntry(
      key,
      colorNameMatcher.match(value).$1
    )
  );

  var hctPalettesObject = HctPalettes(hctSeedColors, blurredGamutBoundaries);

  var hctPalettesFromSeedColors = hctPalettesObject.getHctPalettesFromSeedColors();

  var excelFile = Excel.createExcel();

  hctPalettesFromSeedColors.forEach((key, value) {
    excelFile.updateCell(
        key,
        CellIndex.indexByString('A1'),
        key,
        cellStyle: CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            bold: true
        )
    );

    excelFile.merge(
      key,
      CellIndex.indexByString('A1'),
      CellIndex.indexByString('I1')
    );

    excelFile.updateCell(
        key,
        CellIndex.indexByString('A2'),
        'Suggested name: ${closestNames[key]}',
        cellStyle: CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            italic: true
        )
    );

    excelFile.merge(
        key,
        CellIndex.indexByString('A2'),
        CellIndex.indexByString('I2')
    );

    excelFile.updateCell(
        key,
        CellIndex.indexByString('A3'),
        'Code',
        cellStyle: CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            bold: true
        )
    );

    excelFile.updateCell(
        key,
        CellIndex.indexByString('B3'),
        'Hue',
        cellStyle: CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            bold: true
        )
    );

    excelFile.updateCell(
        key,
        CellIndex.indexByString('C3'),
        'Chroma',
        cellStyle: CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            bold: true
        )
    );

    excelFile.updateCell(
        key,
        CellIndex.indexByString('D3'),
        'Tone',
        cellStyle: CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            bold: true
        )
    );

    excelFile.updateCell(
        key,
        CellIndex.indexByString('E3'),
        'HEX',
        cellStyle: CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            bold: true
        )
    );

    excelFile.updateCell(
        key,
        CellIndex.indexByString('F3'),
        'R',
        cellStyle: CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            bold: true
        )
    );

    excelFile.updateCell(
        key,
        CellIndex.indexByString('G3'),
        'G',
        cellStyle: CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            bold: true
        )
    );

    excelFile.updateCell(
        key,
        CellIndex.indexByString('H3'),
        'B',
        cellStyle: CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            bold: true
        )
    );

    excelFile.updateCell(
        key,
        CellIndex.indexByString('I3'),
        'Color',
        cellStyle: CellStyle(
            horizontalAlign: HorizontalAlign.Center,
            bold: true
        )
    );

    var residua = List.from(value.reversed.indexed.map((each) => (each.$1, (each.$2.tone - hctSeedColors[key]!.tone).abs())).toList());
    residua.sort((a, b) => a.$2.compareTo(b.$2));
    final closestColorIndex = residua.first.$1;


    for (final (index, element) in value.reversed.indexed) {
      excelFile.updateCell(
          key,
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: index + 3),
          lightnessNames.reversed.toList()[index],
          cellStyle: CellStyle(
              horizontalAlign: HorizontalAlign.Right,
              bold: true
          )
      );

      excelFile.updateCell(
          key,
          CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index + 3),
          element.hue
      );

      excelFile.updateCell(
          key,
          CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: index + 3),
          element.chroma
      );

      excelFile.updateCell(
          key,
          CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: index + 3),
          element.tone
      );

      var argbValue = element.toInt();
      var rgbColor = RgbColor.fromArgb(argbValue);

      excelFile.updateCell(
          key,
          CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: index + 3),
          rgbColor.hex
      );

      excelFile.updateCell(
          key,
          CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: index + 3),
          rgbColor.r
      );

      excelFile.updateCell(
          key,
          CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: index + 3),
          rgbColor.g
      );

      excelFile.updateCell(
          key,
          CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: index + 3),
          rgbColor.b
      );

      if (closestColorIndex == index) {
        excelFile.updateCell(
            key,
            CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: index + 3),
            '',
            cellStyle: CellStyle(
                backgroundColorHex: rgbColor.hex,
                leftBorder: Border(borderStyle: BorderStyle.Thick),
                rightBorder: Border(borderStyle: BorderStyle.Thick),
                topBorder: Border(borderStyle: BorderStyle.Thick),
                bottomBorder: Border(borderStyle: BorderStyle.Thick)
            )
        );
      } else {
        excelFile.updateCell(
            key,
            CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: index + 3),
            '',
            cellStyle: CellStyle(
                backgroundColorHex: rgbColor.hex
            )
        );
      }
    };
  }
  );

  String filePath = path.join(path.dirname(Platform.resolvedExecutable), excelFileName);
  filePath = path.normalize(filePath);

  excelFile.delete('Sheet1');
  final fileBytes = excelFile.save();
  if (fileBytes != null) {
    File(filePath).writeAsBytesSync(fileBytes);
  }
}
