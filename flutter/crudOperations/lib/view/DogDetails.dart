import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/DogService.dart';

class DogDetails extends StatefulWidget {
  final int index;

  const DogDetails(this.index, {super.key});

  @override
  State<StatefulWidget> createState() => _DogDetailsState();
}

class _DogDetailsState extends State<DogDetails> {
  _DogDetailsState();

  @override
  Widget build(BuildContext context) {
    var dog = Provider.of<DogService>(context, listen: true)
        .getAllDogs()[widget.index];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(dog.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
                title: TextField(
                    controller: TextEditingController(text: dog.name),
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ))),
            ListTile(
                title: TextField(
                    controller: TextEditingController(text: dog.breed),
                    decoration: const InputDecoration(
                      labelText: "Breed",
                    ))),
            ListTile(
                title: TextField(
                    controller:
                        TextEditingController(text: dog.yearOfBirth.toString()),
                    decoration: const InputDecoration(
                      labelText: "Year of birth",
                    ))),
            ListTile(
                title: TextField(
                    controller: TextEditingController(text: dog.arrivalDate),
                    decoration: const InputDecoration(
                      labelText: "Arrival date",
                    ))),
            ListTile(
                title: TextField(
                    controller: TextEditingController(text: dog.medicalDetails),
                    decoration: const InputDecoration(
                      labelText: "medical Details",
                    ))),
            ListTile(
                title: TextField(
                    controller:
                        TextEditingController(text: dog.crateNumber.toString()),
                    decoration: const InputDecoration(
                      labelText: "Crate number",
                    ))),
          ],
        ),
      ),
    );
  }
}
