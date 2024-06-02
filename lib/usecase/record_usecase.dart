import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import '../entity/record_entity.dart';

class RecordUseCase extends ChangeNotifier {
  final GSheets _gsheets;
  final Spreadsheet _spreadsheet;

  RecordUseCase(this._gsheets, this._spreadsheet);
  List<RecordEntity> allRecords = [];

  void addRecord(RecordEntity record) {
    allRecords.add(record);
    notifyListeners();
  }

  Future<void> removeRecord(RecordEntity record) async {
    // Remove the record from the local list
    allRecords.remove(record);
    notifyListeners();

    final sheet = _spreadsheet.worksheetByTitle('Records');

    // Clear the existing data in the sheet
    await sheet?.clear();

    // Upload the updated list of records to the sheet
    final List<List<dynamic>> rows = [
      // Convert each record to a list of values
      for (var record in allRecords)
        [
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
        ]
    ];

    // Write the updated rows back to the sheet
    await sheet?.values.insertRows(1, rows);
  }
}
