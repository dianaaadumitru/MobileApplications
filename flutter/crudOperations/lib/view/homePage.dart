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
        Provider.of<DogService>(context, listen: false).removeDog(index);
        Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
          return const HomePage();
        }));
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
                  return const Card();
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                      title: Row(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                dog.name,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                ", " + dog.breed,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                ", " + dog.arrivalDate,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  var wasCancelled =
                                      showAreYouSureDialog(dog.id);
                                },
                                backgroundColor: Colors.blue,
                                child: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () => {
                            Navigator.of(context).push(
                                MaterialPageRoute<void>(builder: (context) {
                              return DogDetails(dog);
                            }))
                          }),
                );
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
