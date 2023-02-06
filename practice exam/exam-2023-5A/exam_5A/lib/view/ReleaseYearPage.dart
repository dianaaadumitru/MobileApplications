import 'package:exam_5a/view/ActiveYearsListWidget.dart';
import 'package:exam_5a/view/MainSection.dart';
import 'package:exam_5a/view/Top3GenresPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';

class ReleaseYearPage extends StatefulWidget {
  const ReleaseYearPage({super.key});

  @override
  State<StatefulWidget> createState() => _ReleaseYearPage();

}

class _ReleaseYearPage extends State<ReleaseYearPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Release year section"),
      ),
      body: const ActiveYearsListWidget(),
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
                child: const Text("Main Section")
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Provider.of<DbRepository>(context, listen: false).checkOnline();
                },
                child: const Text("Refresh")
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute<void>(builder: (context) {
                    return const Top3GenresPage();
                  }));
                },
                child: const Text("Top 3 genres")
            ),
            const Spacer(),
          ],
        ),
      ),

    );
  }

}