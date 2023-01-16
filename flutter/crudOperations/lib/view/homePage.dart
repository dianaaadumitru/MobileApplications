import 'package:crud_operations/domain/Dog.dart';
import 'package:crud_operations/service/DogService.dart';
import 'package:crud_operations/view/DogAddPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DogDetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showAreYouSureDialog(int index) {
    bool isCancelled = false;

    // set up the button
    Widget yesButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        var result =
            Provider.of<DogService>(context, listen: false).removeDog(index);
        result.then((value) => {
              if (value == "SUCCESS")
                {
                  Navigator.of(context)
                      .push(MaterialPageRoute<void>(builder: (context) {
                    return const HomePage();
                  }))
                } else {
                showDialog(context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Error"),
                        content: const Text("You are offline or there is a problem, please try again later."),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute<void>(builder: (context) {
                                  return const HomePage();
                                }));
                              },
                              child: const Text("OK")
                          )
                        ],
                      );
                    }
                )
              }
            });
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        isCancelled = true;
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: const Text('Are you sure this dog has been adopted?'),
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

    return isCancelled;
  }

  Widget buildListView() {
    var dogsFuture =
        Provider.of<DogService>(context, listen: true).getAllDogs();

    return FutureBuilder<List<Dog>>(
        future: dogsFuture,
        builder: (context, snapshot) {
          var dogs = snapshot.data;
          return ListView.builder(
              itemCount: dogs?.length,
              itemBuilder: (context, index) {
                var dog = dogs?[index];
                if (dog == null) {
                  // return const Card();
                  return const ListTile();
                }

                return ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      dog.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 19.0,
                          fontWeight: FontWeight.normal),
                    ),
                    subtitle: Text(
                      "${dog.breed}, ${dog.arrivalDate}",
                    ),
                    trailing: Column(
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            var wasCancelled = showAreYouSureDialog(dog.id);
                          },
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                    onTap: () => {
                          Navigator.of(context)
                              .push(MaterialPageRoute<void>(builder: (context) {
                            return DogDetails(dog);
                          }))
                        });
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (context) {
            return const DogAddPage();
          }));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
