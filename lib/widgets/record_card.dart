import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../entity/record_entity.dart';
import '../usecase/record_usecase.dart';

class RecordCard extends StatelessWidget {
  final RecordUseCase recordUseCase;
  final RecordEntity recordEntity;
  const RecordCard(
      {super.key, required this.recordUseCase, required this.recordEntity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(15),
              flex: 1,
              onPressed: (_) {
                recordUseCase.removeRecord(recordEntity);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
          ],
        ),
        child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                    color: const Color(0xff0f7497).withOpacity(0.5), width: 2)
                // boxShadow: [
                //   BoxShadow(
                //       color: Colors.black.withOpacity(0.2),
                //       blurRadius: 3,
                //       spreadRadius: 3)
                // ],
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      recordEntity.pondEntity.label,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(recordEntity.day),
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                _buildAlignedText(
                    "Light Intensity", "${recordEntity.lightIntensity} %"),
                _buildAlignedText(
                    "Wind Speed", "${recordEntity.windSpeed} m/s"),
                _buildAlignedText(
                    "Salinity Level", "${recordEntity.salinityLevel} kg/dm³"),
                _buildAlignedText(
                    "Temperature", "${recordEntity.temperature} °C"),
                _buildAlignedText("Net Solar Radiation",
                    "${recordEntity.netSolarRadiation} mJ/m²day"),
                _buildAlignedText("Evaporation Rate",
                    "${recordEntity.evaporationnRate} mm/day"),
                _buildAlignedText("Humidity", "${recordEntity.humidity} %"),
              ],
            )),
      ),
    );
  }

  Widget _buildAlignedText(String label, String value) {
    const labelWidth = 150.0; // Adjust the width as needed for your layout
    return Row(
      children: [
        SizedBox(width: labelWidth, child: Text(label)),
        Text(": $value"),
      ],
    );
  }
}
