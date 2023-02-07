import 'package:exam_7b/view/widgets/Top3DoctorsListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';
import 'MainSection.dart';

class Top3DoctorsPage extends StatefulWidget {
  const Top3DoctorsPage({super.key});

  @override
  State<StatefulWidget> createState() => _Top3DoctorsPage();
}

class _Top3DoctorsPage extends State<Top3DoctorsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top section"),
      ),
      body: const Top3DoctorsListWidget(),
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