import 'package:exam_2a/view/EasiestTipsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/Tip.dart';
import '../repository/DbRepository.dart';

class ChangeDifficultyPage extends StatefulWidget {
  final Tip _tip;

  const ChangeDifficultyPage(this._tip, {super.key});

  @override
  State<StatefulWidget> createState() => _ChangeDifficultyPage();
}

class _ChangeDifficultyPage extends State<ChangeDifficultyPage> {
  bool isLoading = false;

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

  void showAreYouSureDialog(String category) {
    // set up the button
    Widget yesButton = TextButton(
        child: const Text("Yes"),
        onPressed: () async {
          setState(() {
            isLoading = true;
          });

          var result = await Provider.of<DbRepository>(context, listen: false)
              .changeCategory(widget._tip.id, category);

          setState(() {
            isLoading = false;
          });

          if (!mounted) {
            return;
          }

          if (result.left is String && result.left != "ok") {
            final snackBar = SnackBar(content: Text(result.left as String));

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }

          if (result.right is bool && result.right) {
            Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (context) {
              return const EasiestTipsPage();
            }));
          } else {
            showAlertDialog(context, "Change is not possible while offline!");
          }
        });

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: const Text('Are you sure you want to change this entity?'),
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

    var nameController = TextEditingController();
    nameController.text = widget._tip.name;

    var descriptionController = TextEditingController();
    descriptionController.text = widget._tip.description;

    var materialsController = TextEditingController();
    materialsController.text = widget._tip.materials;

    var stepsController = TextEditingController();
    stepsController.text = widget._tip.steps.toString();

    var categoryController = TextEditingController();
    categoryController.text = widget._tip.category;

    var difficultyController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Change difficulty'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                  title: TextField(
                      readOnly: true,
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                      ))),
              ListTile(
                  title: TextField(
                      readOnly: true,
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ))),
              ListTile(
                  title: TextField(
                      readOnly: true,
                      controller: materialsController,
                      decoration: const InputDecoration(
                        labelText: "Materials",
                      ))),
              ListTile(
                  title: TextField(
                      readOnly: true,
                      controller: stepsController,
                      decoration: const InputDecoration(
                        labelText: "Steps",
                      ))),
              ListTile(
                  title: TextField(
                      readOnly: true,
                      controller: categoryController,
                      decoration: const InputDecoration(
                        labelText: "Category",
                      ))),
              ListTile(
                  title: TextField(
                      controller: difficultyController,
                      decoration: const InputDecoration(
                        labelText: "Difficulty",
                      ))),
              Center(
                child: !isLoading
                    ? ElevatedButton(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Update difficulty"),
                            ],
                          ),
                        ),
                        onPressed: () {
                          showAreYouSureDialog(difficultyController.text);
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ));
  }
}
