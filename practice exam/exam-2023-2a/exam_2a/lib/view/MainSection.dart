import 'package:exam_2a/view/AddTipPage.dart';
import 'package:exam_2a/view/CategoriesListWidget.dart';
import 'package:exam_2a/view/EasiestTipsPage.dart';
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
      body: const CategoriesListWidget(),
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
                    return const EasiestTipsPage();
                  }));
                },
                child: const Text("Easiest tips")),
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
                    return const AddTipPage();
                  }));
                },
                child: const Text("Add tip")),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
