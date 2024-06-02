import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entity/record_entity.dart';
import '../services/gsheets_services.dart';
import '../usecase/record_usecase.dart';
import '../widgets/empty_widget.dart';
import '../widgets/record_card.dart';
import '../widgets/title_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: FutureBuilder(
        future: Sheets.readRecords(),
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
            List<RecordEntity> records = snapshot.data ?? [];

            return Consumer<RecordUseCase>(
              builder: (context, value, child) {
                value.allRecords = records;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleText(title: "RECORD HISTORY"),
                    (value.allRecords.isEmpty)
                        ? const EmptyWidget(text: "Empty Records")
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value.allRecords.length,
                            itemBuilder: (context, index) {
                              return RecordCard(
                                  recordUseCase: value,
                                  recordEntity: value.allRecords[index]);
                            },
                          ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
