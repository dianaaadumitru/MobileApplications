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

  void showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var dog = Provider.of<DogService>(context, listen: true)
        .getAllDogs()[widget.index];

    var dogName = TextEditingController(text: dog.name);
    var dogBreed = TextEditingController(text: dog.breed);
    var dogYearOfBirth =
        TextEditingController(text: dog.yearOfBirth.toString());
    var dogArrivalDate = TextEditingController(text: dog.arrivalDate);
    var dogMedicalDetails = TextEditingController(text: dog.medicalDetails);
    var dogCrateNo = TextEditingController(text: dog.crateNumber.toString());

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
                    controller: dogName,
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ))),
            ListTile(
                title: TextField(
                    controller: dogBreed,
                    decoration: const InputDecoration(
                      labelText: "Breed",
                    ))),
            ListTile(
                title: TextField(
                    controller: dogYearOfBirth,
                    decoration: const InputDecoration(
                      labelText: "Year of birth",
                    ))),
            ListTile(
                title: TextField(
                    controller: dogArrivalDate,
                    decoration: const InputDecoration(
                      labelText: "Arrival date",
                    ))),
            ListTile(
                title: TextField(
                    controller: dogMedicalDetails,
                    decoration: const InputDecoration(
                      labelText: "medical Details",
                    ))),
            ListTile(
                title: TextField(
                    controller: dogCrateNo,
                    decoration: const InputDecoration(
                      labelText: "Crate number",
                    ))),
            Center(
              child: ElevatedButton(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Update dog"),
                    ],
                  ),
                ),
                onPressed: () {
                  var yearOfBirth = int.tryParse(dogYearOfBirth.text);
                  if (dogYearOfBirth.text == "") {
                    yearOfBirth = 0;
                  }

                  var medicalDetails = dogMedicalDetails.text;
                  if (medicalDetails == "") {
                    medicalDetails = "";
                  }

                  if (dogName.text == "") {
                    showAlertDialog(context, "Name should not be empty!");
                    return;
                  }

                  if (dogBreed.text == "") {
                    showAlertDialog(context, "Breed should not be empty!");
                    return;
                  }

                  if (dogArrivalDate.text == "") {
                    showAlertDialog(
                        context, "Arrival date should not be empty!");
                    return;
                  }

                  if (dogCrateNo.text == "") {
                    showAlertDialog(
                        context, "Crate number should not be empty!");
                    return;
                  }

                  Provider.of<DogService>(context, listen: false).updateDog(
                      dog.id,
                      dogName.text,
                      dogBreed.text,
                      yearOfBirth!,
                      dogArrivalDate.text,
                      medicalDetails,
                      int.tryParse(dogCrateNo.text)!);

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
