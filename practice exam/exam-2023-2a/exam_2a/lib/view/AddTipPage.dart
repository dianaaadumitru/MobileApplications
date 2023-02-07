import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/DbRepository.dart';

class AddTipPage extends StatefulWidget {
  const AddTipPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddTipPage();
}

class _AddTipPage extends State<AddTipPage> {
  bool isAddLoading = true;

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
    var nameController = TextEditingController();
    var descriptionController = TextEditingController();
    var materialsController = TextEditingController();
    var stepsController = TextEditingController();
    var categoryController = TextEditingController();
    var difficultyController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Add tip"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
              ),
              ListTile(
                title: TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
              ),
              ListTile(
                title: TextField(
                  controller: materialsController,
                  decoration: const InputDecoration(labelText: "materials"),
                ),
              ),
              ListTile(
                title: TextField(
                  controller: stepsController,
                  decoration: const InputDecoration(labelText: "steps"),
                ),
              ),
              ListTile(
                title: TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: "category"),
                ),
              ),
              ListTile(
                title: TextField(
                  controller: difficultyController,
                  decoration: const InputDecoration(labelText: "difficulty"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Add tip"),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      isAddLoading = true;
                    });

                    if (descriptionController.text == "" ||
                        nameController.text == "") {
                      showAlertDialog(context, "invalid data!");
                      return;
                    }

                    var result =
                        await Provider.of<DbRepository>(context, listen: false)
                            .addTip(
                                nameController.text,
                                descriptionController.text,
                                materialsController.text,
                                stepsController.text,
                                categoryController.text,
                                difficultyController.text);

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
                ),
              )
            ],
          ),
        ));
  }
}
