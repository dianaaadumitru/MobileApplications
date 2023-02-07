import 'package:exam_7b/view/widgets/NoSymptomsByMonthListWidget.dart';
import 'package:exam_7b/view/widgets/Top3DoctorsListWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';
import 'MainSection.dart';

class NoSymptomsByMonthPage extends StatefulWidget {
  const NoSymptomsByMonthPage({super.key});

  @override
  State<StatefulWidget> createState() => _NoSymptomsByMonthPage();
}

class _NoSymptomsByMonthPage extends State<NoSymptomsByMonthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress section"),
      ),
      body: const NoSymptomsByMonthListWidget(),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute<void>(builder: (context) {
                    return const MainSection();
                  }));
                },
                child: const Text("Main Section")),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Provider.of<DbRepository>(context, listen: false)
                      .checkOnline();
                },
                child: const Text("Refresh")),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}