import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../entity/pond_entity.dart';
import '../usecase/pond_usecase.dart';

class PondCard extends StatelessWidget {
  final PondUseCase pondUseCase;
  final PondEntity pondEntity;
  const PondCard(
      {super.key, required this.pondEntity, required this.pondUseCase});

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
                pondUseCase.deletePondRecord(pondEntity);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
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
              Text(
                "ID: ${pondEntity.id}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text("Label: ${pondEntity.label}"),
            ],
          ),
        ),
      ),
    );
  }
}
