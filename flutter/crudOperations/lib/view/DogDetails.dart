import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/Dog.dart';
import '../service/DogService.dart';
import 'homePage.dart';

class DogDetails extends StatefulWidget {
  final Dog dog;

  const DogDetails(this.dog, {Key? key}) : super(key: key);

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
    var dogName = TextEditingController(text: widget.dog.name);
    var dogBreed = TextEditingController(text: widget.dog.breed);
    var dogYearOfBirth =
        TextEditingController(text: widget.dog.yearOfBirth.toString());
    var dogArrivalDate = TextEditingController(text: widget.dog.arrivalDate);
    var dogMedicalDetails =
        TextEditingController(text: widget.dog.medicalDetails);
    var dogCrateNo =
        TextEditingController(text: widget.dog.crateNumber.toString());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.dog.name),
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

                  var result = Provider.of<DogService>(context, listen: false)
                      .updateDog(
                          widget.dog.id,
                          dogName.text,
                          dogBreed.text,
                          yearOfBirth!,
                          dogArrivalDate.text,
                          medicalDetails,
                          int.tryParse(dogCrateNo.text)!);

                  result.then((value) => {
                        if (value == "SUCCESS")
                          {
                            Navigator.of(context).push(
                                MaterialPageRoute<void>(builder: (context) {
                              return const HomePage();
                            }))
                          }
                        else
                          {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Error"),
                                    content: const Text(
                                        "You are offline or there is a problem, please try again later."),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute<void>(
                                                    builder: (context) {
                                              return const HomePage();
                                            }));
                                          },
                                          child: const Text("OK"))
                                    ],
                                  );
                                })
                          }
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
