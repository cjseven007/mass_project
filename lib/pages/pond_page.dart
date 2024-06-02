import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entity/pond_entity.dart';
import '../usecase/pond_usecase.dart';
import '../widgets/empty_widget.dart';
import '../widgets/pond_card.dart';
import '../widgets/title_text.dart';

import '../services/gsheets_services.dart';

class PondPage extends StatefulWidget {
  const PondPage({super.key});

  @override
  State<PondPage> createState() => _PondPageState();
}

class _PondPageState extends State<PondPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController idController = TextEditingController();
    TextEditingController labelController = TextEditingController();
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: FutureBuilder(
            future: Sheets.fetchPondsFromSheets(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                      const CircularProgressIndicator(
                        color: Color(0xff0f7497),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                List<PondEntity> ponds = snapshot.data ?? [];

                return Consumer<PondUseCase>(
                  builder: (context, value, child) {
                    value.allPonds = ponds;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const TitleText(title: "POND LIST"),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
                              child: IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xff4dbac3),
                                    foregroundColor: Colors.white),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Add Pond'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              TextField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: idController,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: "ID"),
                                              ),
                                              TextField(
                                                controller: labelController,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: "Label"),
                                              )
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text(
                                              'CANCEL',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () {
                                              idController.clear();
                                              labelController.clear();
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('OK',
                                                style: TextStyle(
                                                    color: Color(0xff0f7497))),
                                            onPressed: () {
                                              int id =
                                                  int.parse(idController.text);
                                              bool existingPond = value.allPonds
                                                  .any((pond) => pond.id == id);
                                              if (existingPond) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Pond with ID $id already exists.'),
                                                  ),
                                                );
                                              } else {
                                                PondEntity pond = PondEntity(
                                                  id: id,
                                                  label: labelController.text,
                                                );
                                                Sheets.addPondToSheets(pond);
                                                value.addPond(pond);
                                                idController.clear();
                                                labelController.clear();
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.add),
                              ),
                            )
                          ],
                        ),
                        (value.allPonds.isEmpty)
                            ? const EmptyWidget(text: "Empty Ponds")
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: value.allPonds.length,
                                itemBuilder: (context, index) {
                                  return PondCard(
                                    pondEntity: value.allPonds[index],
                                    pondUseCase: value,
                                  );
                                },
                              ),
                      ],
                    );
                  },
                );
              }
            }));
  }
}
