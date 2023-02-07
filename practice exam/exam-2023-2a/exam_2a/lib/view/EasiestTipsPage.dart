import 'package:exam_2a/view/EasiestTipsListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';
import 'MainSection.dart';

class EasiestTipsPage extends StatefulWidget {
  const EasiestTipsPage({super.key});

  @override
  State<StatefulWidget> createState() => _EasiestTipsPage();
}

class _EasiestTipsPage extends State<EasiestTipsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Easiest tips section"),
      ),
      body: const EasiestTipsListWidget(),
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
