import 'package:exam_7b/domain/HealthData.dart';
import 'package:exam_7b/view/DateHealthDataPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';

class DeleteHealthDataPage extends StatefulWidget {
  final HealthData _healthData;
  const DeleteHealthDataPage(this._healthData, {super.key});

  @override
  State<StatefulWidget> createState() => _DeleteHealthDataPage();

}

class _DeleteHealthDataPage extends State<DeleteHealthDataPage> {
  bool isLoading = false;

  void showAreYouSureDialog(int index) {
    // set up the button
    Widget yesButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });

        var result = await Provider.of<DbRepository>(context, listen: false).deleteHealthData(index);

        setState(() {
          isLoading = false;
        });

        if (!mounted) {
          return;
        }

        if (result.left is String && result.left != "ok") {
          final snackBar =
          SnackBar(content: Text(result.left as String));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }

        if (result.right is bool && result.right) {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (context) {
            return DateHealthDataPage(widget._healthData.date);
          }));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: const Text(
                      "You are offline, please try again later."),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                  builder: (context) {
                                    return DateHealthDataPage(widget._healthData.date);
                                  }));
                        },
                        child: const Text("OK"))
                  ],
                );
              });
        }
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert"),
      content: const Text('Are you sure you want to delete this entity?'),
      actions: [
        cancelButton,
        yesButton,
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

  Widget _buildListView() {
    var dateController = TextEditingController();
    dateController.text = widget._healthData.date;

    var symptomController = TextEditingController();
    symptomController.text = widget._healthData.symptom;

    var medicationController = TextEditingController();
    medicationController.text = widget._healthData.medication;

    var dosageController = TextEditingController();
    dosageController.text = widget._healthData.dosage;

    var doctorController = TextEditingController();
    doctorController.text = widget._healthData.doctor.toString();

    var notesController = TextEditingController();
    notesController.text = widget._healthData.notes;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Delete health data'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                  title: TextField(
                      readOnly: true,
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: "date",
                      ))),
              ListTile(
                  title: TextField(
                      readOnly: true,
                      controller: symptomController,
                      decoration: const InputDecoration(
                        labelText: "symptom",
                      ))),
              ListTile(
                  title: TextField(
                      readOnly: true,
                      controller: medicationController,
                      decoration: const InputDecoration(
                        labelText: "medication",
                      ))),
              ListTile(
                  title: TextField(
                      readOnly: true,
                      controller: dosageController,
                      decoration: const InputDecoration(
                        labelText: "dosage",
                      ))),
              ListTile(
                  title: TextField(
                      readOnly: true,
                      controller: doctorController,
                      decoration: const InputDecoration(
                        labelText: "doctor",
                      ))),
              ListTile(
                  title: TextField(
                      readOnly: true,
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: "notes",
                      ))),
              Center(
                child: !isLoading ? ElevatedButton(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Delete activity"),
                      ],
                    ),
                  ),
                  onPressed: () {
                    showAreYouSureDialog(widget._healthData.id);
                  },
                ) : const Center(child:CircularProgressIndicator()),
              ),
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<DbRepository>(context);
    final infoMessage = storage.getInfoMessage();

    if (infoMessage != '') {
      return AlertDialog(
        title: const Text('Alert'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[Text(infoMessage)],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              storage.setInfoMessage('');
            },
          )
        ],
      );
    }
    return _buildListView();
  }

}