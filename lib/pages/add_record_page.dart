import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entity/pond_entity.dart';
import '../entity/record_entity.dart';
import '../services/gsheets_services.dart';
import '../usecase/pond_usecase.dart';
import '../usecase/record_usecase.dart';
import '../widgets/text_box.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({super.key});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  TextEditingController lightController = TextEditingController();
  TextEditingController windController = TextEditingController();
  TextEditingController salinityController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  TextEditingController solarController = TextEditingController();
  TextEditingController evaporationController = TextEditingController();
  TextEditingController humidityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0f7497),
        title: const Text(
          "Add Record Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer2<PondUseCase, RecordUseCase>(
        builder: (context, pondUseCase, recordUseCase, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown menu to choose pond
                  (pondUseCase.allPonds.isEmpty)
                      ? const Text(
                          "No ponds. Add ponds now",
                          style: TextStyle(color: Colors.red),
                        )
                      : Builder(
                          builder: (BuildContext context) {
                            if (pondUseCase.allPonds.isEmpty) {
                              return const Text(
                                "No ponds. Add ponds now",
                                style: TextStyle(color: Colors.red),
                              );
                            } else {
                              List<PondEntity> pe = pondUseCase.allPonds;

                              pe.forEach((e) => debugPrint(e.id.toString()));

                              return DropdownButton<PondEntity>(
                                value: pondUseCase.selectedPond,
                                items: pe
                                    .map((PondEntity pond) {
                                      return DropdownMenuItem<PondEntity>(
                                        value: pond,
                                        child: Text(pond.label),
                                      );
                                    })
                                    .toSet()
                                    .toList(), // Convert to set to remove duplicates
                                onChanged: (PondEntity? newValue) {
                                  pondUseCase.selectPond(newValue!);
                                },
                              );
                            }
                          },
                        ),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2, // Set the number of columns in the grid
                    crossAxisSpacing: 10, // Set the spacing between columns
                    mainAxisSpacing: 10, // Set the spacing between rows
                    childAspectRatio: 2,
                    shrinkWrap:
                        true, // Allow the grid view to occupy only the necessary space
                    children: [
                      TextBox(
                        text: "Light Intensity",
                        controller: lightController,
                      ),
                      TextBox(
                        text: "Wind Speed",
                        controller: windController,
                      ),
                      TextBox(
                        text: "Salinity Level",
                        controller: salinityController,
                      ),
                      TextBox(
                        text: "Temperature",
                        controller: temperatureController,
                      ),
                      TextBox(
                        text: "Net Solar Radiation",
                        controller: solarController,
                      ),
                      TextBox(
                        text: "Evaporation Rate",
                        controller: evaporationController,
                      ),
                      TextBox(
                        text: "Humidity",
                        controller: humidityController,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: const Color(0xff0f7497),
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        // Check if any of the controllers are empty
                        if (lightController.text.isEmpty ||
                            windController.text.isEmpty ||
                            salinityController.text.isEmpty ||
                            temperatureController.text.isEmpty ||
                            solarController.text.isEmpty ||
                            evaporationController.text.isEmpty ||
                            humidityController.text.isEmpty) {
                          // Show a snackbar or alert dialog indicating that all fields are required
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All fields are required.'),
                            ),
                          );
                          return; // Exit the method if any field is empty
                        }

                        // All fields are filled, proceed with record addition
                        RecordEntity recordEntity = RecordEntity(
                          pondEntity: pondUseCase.selectedPond,
                          day: DateTime.now(),
                          lightIntensity: double.parse(lightController.text),
                          windSpeed: double.parse(windController.text),
                          salinityLevel: double.parse(salinityController.text),
                          temperature: double.parse(temperatureController.text),
                          netSolarRadiation: double.parse(solarController.text),
                          evaporationnRate:
                              double.parse(evaporationController.text),
                          humidity: double.parse(humidityController.text),
                        );

                        // Upload the record and add it to the list
                        await Sheets.uploadRecord(recordEntity);
                        recordUseCase.addRecord(recordEntity);

                        // Clear all text fields
                        lightController.clear();
                        windController.clear();
                        salinityController.clear();
                        temperatureController.clear();
                        solarController.clear();
                        evaporationController.clear();
                        humidityController.clear();

                        // Navigate back to the previous screen
                        Navigator.pop(context);
                      },
                      child: const Text("Add Record"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
