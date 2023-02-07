import 'package:exam_7b/view/AddHealthDataPage.dart';
import 'package:exam_7b/view/NoSymptomsByMonthPage.dart';
import 'package:exam_7b/view/Top3DoctorsPage.dart';
import 'package:exam_7b/view/widgets/DaysListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';

class MainSection extends StatefulWidget {
  const MainSection({super.key});

  @override
  State<StatefulWidget> createState() => _MainSection();
}

class _MainSection extends State<MainSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Section"),
      ),
      body: const DaysListWidget(),
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
                    return const NoSymptomsByMonthPage();
                  }));
                },
                child: const Text("Progress")),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute<void>(builder: (context) {
                    return const Top3DoctorsPage();
                  }));
                },
                child: const Text("Top")),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Provider.of<DbRepository>(context, listen: false)
                      .checkOnline();
                },
                child: const Text("Refresh")),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute<void>(builder: (context) {
                    return const AddHealthDataPage();
                  }));
                },
                child: const Text("Add health entry")),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}