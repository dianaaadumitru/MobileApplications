import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';

class AddHealthDataPage extends StatefulWidget {
  const AddHealthDataPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddHealthDataPage();
}

class _AddHealthDataPage extends State<AddHealthDataPage> {
  bool isAddLoading = false;

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
    var dateController = TextEditingController();
    var symptomController = TextEditingController();
    var medicationController = TextEditingController();
    var dosageController = TextEditingController();
    var doctorController = TextEditingController();
    var notesController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Add health data"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: "date"),
                ),
              ),
              ListTile(
                title: TextField(
                  controller: symptomController,
                  decoration: const InputDecoration(labelText: "symptom"),
                ),
              ),
              ListTile(
                title: TextField(
                  controller: medicationController,
                  decoration: const InputDecoration(labelText: "medication"),
                ),
              ),
              ListTile(
                title: TextField(
                  controller: dosageController,
                  decoration: const InputDecoration(labelText: "dosage"),
                ),
              ),
              ListTile(
                title: TextField(
                  controller: doctorController,
                  decoration: const InputDecoration(labelText: "doctor"),
                ),
              ),
              ListTile(
                title: TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: "notes"),
                ),
              ),
              Center(
                child: !isAddLoading ? ElevatedButton(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Add health data"),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      isAddLoading = true;
                    });

                    if (symptomController.text == "" ||
                        dateController.text == "") {
                      showAlertDialog(context, "invalid data!");
                      isAddLoading = false;
                      return;
                    }

                    var result =
                    await Provider.of<DbRepository>(context, listen: false)
                        .addHealthData(
                        dateController.text,
                        symptomController.text,
                        medicationController.text,
                        dosageController.text,
                        doctorController.text,
                        notesController.text);

                    setState(() {
                      isAddLoading = false;
                    });

                    if (result.left is String && result.left != "ok") {
                      final snackBar =
                      SnackBar(content: Text(result.left as String));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    if (result.right is bool && result.right) {
                      Navigator.pop(context);
                    } else {
                      showAlertDialog(context, "Add is not possible while offline!");
                    }
                  },
                ) : const Center(child:CircularProgressIndicator()),
              )
            ],
          ),
        ));
  }
}