import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import '../entity/pond_entity.dart';

class PondUseCase extends ChangeNotifier {
  final GSheets _gsheets;
  final Spreadsheet _spreadsheet;

  PondUseCase(this._gsheets, this._spreadsheet);
  List<PondEntity> allPonds = [];

  late PondEntity selectedPond = allPonds.first;

  void setP(List<PondEntity> a) {
    allPonds = a;
    notifyListeners();
  }

  void selectPond(PondEntity pondEntity) {
    selectedPond = pondEntity;
    notifyListeners();
  }

  void addPond(PondEntity pond) {
    allPonds.add(pond);
    notifyListeners();
  }

  Future<void> deletePondRecord(PondEntity pondEntity) async {
    allPonds.remove(pondEntity);
    notifyListeners();
    final sheet = _spreadsheet.worksheetByTitle('Ponds');
    // Clear the existing data in the sheet
    await sheet?.clear();

    final List<List<dynamic>> rows = [
      // Convert each record to a list of values
      for (var pond in allPonds) [pond.id.toString(), pond.label]
    ];

    // Write the updated rows back to the sheet
    await sheet?.values.insertRows(1, rows);
  }
}
