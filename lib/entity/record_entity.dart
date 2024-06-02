import 'pond_entity.dart';

class RecordEntity {
  final PondEntity pondEntity;
  final DateTime day;
  final double lightIntensity;
  final double windSpeed;
  final double salinityLevel;
  final double temperature;
  final double netSolarRadiation;
  final double evaporationnRate;
  final double humidity;

  RecordEntity(
      {required this.pondEntity,
      required this.day,
      required this.lightIntensity,
      required this.windSpeed,
      required this.salinityLevel,
      required this.temperature,
      required this.netSolarRadiation,
      required this.evaporationnRate,
      required this.humidity});
}
