import 'package:exam_5a/view/ReleaseYearPage.dart';
import 'package:exam_5a/view/Top3GenresListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';

class Top3GenresPage extends StatefulWidget {
  const Top3GenresPage({super.key});

  @override
  State<StatefulWidget> createState() => _Top3GenresPage();
}

class _Top3GenresPage extends State<Top3GenresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Release year section"),
      ),
      body: const Top3GenresListWidget(),
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
                    return const ReleaseYearPage();
                  }));
                },
                child: const Text("Release year page")),
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
