import 'package:exam_5a/repository/DbRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMoviePage extends StatefulWidget {
  const AddMoviePage({super.key});

  @override
  State<StatefulWidget> createState() => _AddMoviePage();

}

class _AddMoviePage extends State<AddMoviePage> {
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
    var genreController = TextEditingController();
    var directorController = TextEditingController();
    var yearController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add movie"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name"
                ),
              ),
            ),
            ListTile(
              title: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    labelText: "Description"
                ),
              ),
            ),
            ListTile(
              title: TextField(
                controller: genreController,
                decoration: const InputDecoration(
                    labelText: "Genre"
                ),
              ),
            ),
            ListTile(
              title: TextField(
                controller: directorController,
                decoration: const InputDecoration(
                    labelText: "Director"
                ),
              ),
            ),
            ListTile(
              title: TextField(
                controller: yearController,
                decoration: const InputDecoration(
                    labelText: "Year"
                ),
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
                      Text("Add movie"),
                    ],
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    isAddLoading = true;
                  });

                  var yearInt = int.tryParse(yearController.text);
                  if (yearInt == null || nameController.text == "") {
                    showAlertDialog(context, "invalid data!");
                    return;
                  }

                  var result  = await Provider.of<DbRepository>(context, listen: false).addMovie(
                      nameController.text,
                      descriptionController.text,
                      genreController.text,
                      directorController.text,
                      yearInt);

                  setState(() {
                    isAddLoading = false;
                  });

                  if (result.left is String && result.left != "ok") {
                    final snackBar = SnackBar(
                        content: Text(result.left as String)
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  if (result.right is bool && result.right) {
                    Navigator.pop(context);
                  }
                  else {
                    showAlertDialog(context, "Add is not possible while offline!");
                  }
                },
              ),
            )
          ],
        ),
      )
    );
  }

}



