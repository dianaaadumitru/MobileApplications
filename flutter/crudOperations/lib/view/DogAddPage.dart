import 'package:crud_operations/service/DogService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DogAddPage extends StatelessWidget {
  const DogAddPage({Key? key}) : super(key: key);

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
    var dogName = TextEditingController();
    var dogBreed = TextEditingController();
    var dogYearOfBirth = TextEditingController();
    var dogArrivalDate = TextEditingController();
    var dogMedicalDetails = TextEditingController();
    var dogCrateNo = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add a new dog'),
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
                        labelText: "Year of Birth",
                      ))),
              ListTile(
                  title: TextField(
                      controller: dogArrivalDate,
                      decoration: const InputDecoration(
                        labelText: "Arrival Date",
                      ))),
              ListTile(
                  title: TextField(
                      controller: dogMedicalDetails,
                      decoration: const InputDecoration(
                        labelText: "Medical Details",
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
                        Text("Add player"),
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

                    Provider.of<DogService>(context, listen: false).addDog(
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
        ));
  }
}
