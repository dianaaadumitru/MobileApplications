import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    );
  }

}