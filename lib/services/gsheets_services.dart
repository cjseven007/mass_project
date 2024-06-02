import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import '../entity/pond_entity.dart';
import '../entity/record_entity.dart';

class Sheets extends ChangeNotifier {
  static const _credentials = r'''
    {
  //none
  ''';

  static const _spreadsheetId = '1-oT7FQieHHZV2CXjWjH0AtHnw1cyoMWzfQ8XJkiAamk';

  static final GSheets _gsheets = GSheets(_credentials);
  static Spreadsheet _spreadsheet = _spreadsheet;

  static GSheets get gsheets => _gsheets;
  static Spreadsheet get spreadsheet => _spreadsheet;

  // Method to authenticate and get access to the spreadsheet
  static Future<void> _init() async {
    final client = await _gsheets
        .spreadsheet(_spreadsheetId)
        .then((spreadsheet) => spreadsheet);
    _spreadsheet = client;
  }

  static Future<List<RecordEntity>> readRecords() async {
    await _init();

    final sheet = _spreadsheet.worksheetByTitle("Records");
    final values = await sheet?.values.allRows();

    List<RecordEntity> records = [];

    if (values != null) {
      for (List<String> row in values) {
        final double numericValue =
            double.parse(row[2]); // Sample numeric value

        // Adjust the numeric value to account for Excel epoch start date
        final int secondsSinceEpoch = ((numericValue - 25569 - 1) * 86400000)
            .round(); // Convert days to seconds and adjust by 1 day
        final DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch);
        RecordEntity record = RecordEntity(
          pondEntity: PondEntity(
              id: int.parse(row[0]),
              label: row[1]), // Assuming Pond ID is in the first column
          day: dateTime,

          lightIntensity: double.parse(row[3]),
          windSpeed: double.parse(row[4]),
          salinityLevel: double.parse(row[5]),
          temperature: double.parse(row[6]),
          netSolarRadiation: double.parse(row[7]),
          evaporationnRate: double.parse(row[8]),
          humidity: double.parse(row[9]),
        );
        records.add(record);
      }
    }

    return records;
  }

  // Method to append a new row with RecordEntity data
  static Future<void> uploadRecord(RecordEntity record) async {
    await _init();

    final sheet = _spreadsheet.worksheetByTitle("Records");

    final values = [
      record.pondEntity.id.toString(),
      record.pondEntity.label,
      record.day.toString(),
      record.lightIntensity.toString(),
      record.windSpeed.toString(),
      record.salinityLevel.toString(),
      record.temperature.toString(),
      record.netSolarRadiation.toString(),
      record.evaporationnRate.toString(),
      record.humidity.toString(),
    ];

    await sheet?.values.appendRow(values);
    debugPrint('Record uploaded to Google Sheets!');
  }

  static Future<List<PondEntity>> fetchPondsFromSheets() async {
    // Assume _spreadsheet is already initialized

    final sheet = _spreadsheet.worksheetByTitle('Ponds');
    final values = await sheet?.values.allRows();
    List<PondEntity> allPonds = [];

    if (values != null) {
      for (final row in values) {
        final int? id = int.tryParse(row[0]);
        final String label = row[1];

        if (id != null && label.isNotEmpty) {
          final pond = PondEntity(id: id, label: label);
          allPonds.add(pond);
        }
      }
    }
    return allPonds;
  }

  static Future<void> addPondToSheets(PondEntity pond) async {
    final sheet = _spreadsheet.worksheetByTitle('Ponds');

    // Append a new row with pond data
    await sheet?.values.appendRow([pond.id.toString(), pond.label]);
  }
}
