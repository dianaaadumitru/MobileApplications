import 'package:exam_2a/view/TipsListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';

class CategoryTipsPage extends StatefulWidget {
  final String _category;

  const CategoryTipsPage(this._category, {super.key});

  @override
  State<StatefulWidget> createState() => _CategoryTipsPage();
}

class _CategoryTipsPage extends State<CategoryTipsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tips for ${widget._category}"),
      ),
      body: TipsListWidget(widget._category),
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
          ],
        ),
      ),
    );
  }
}
