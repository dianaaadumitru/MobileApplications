import 'package:exam_7b/view/MainSection.dart';
import 'package:exam_7b/view/widgets/HealthDataListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';

class DateHealthDataPage extends StatefulWidget {
  final String _date;

  const DateHealthDataPage(this._date, {super.key});

  @override
  State<StatefulWidget> createState() => _DateHealthDataPage();
}

class _DateHealthDataPage extends State<DateHealthDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health data for ${widget._date}"),
      ),
      body: HealthDataListWidget(widget._date),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    return const MainSection();
                  }));
                },
                child: const Text("Main Section")),
          ],
        ),
      ),
    );
  }
}
