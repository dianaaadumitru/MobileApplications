import 'dart:developer';

import 'package:crud_operations/domain/Dog.dart';
import 'package:crud_operations/service/DogService.dart';
import 'package:crud_operations/view/DogAddPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DogDetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // Widget build(BuildContext context) {
  // return Scaffold(
  //   // appBar: AppBar(title: const Text('Dog Shelter')),
  //     backgroundColor: Colors.purple,
  //     body: ListView.builder(
  //       itemCount: Provider.of<DogService>(context, listen: true).getAllDogs().length,
  //         itemBuilder: (context, index) {
  //           var dog = Provider.of<DogService>(context, listen: true)
  //               .getAllDogs()[index];
  //
  //           return Card(
  //               shape: RoundedRectangleBorder(
  //                 side: BorderSide(
  //                   color: Colors.blue.shade300,
  //                 ),
  //                 borderRadius: BorderRadius.circular(15.0),
  //               ),
  //           );
  //         }
  //     )
  // );
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: Provider.of<DogService>(context, listen: true)
              .getAllDogs()
              .length,
          itemBuilder: (context, index) {
            var dog = Provider.of<DogService>(context, listen: true)
                .getAllDogs()[index];

            return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.blue.shade300,
                ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            dog.yearOfBirth.toString(),
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => {
                        Navigator.of(context)
                            .push(MaterialPageRoute<void>(builder: (context) {
                          return DogDetails(index);
                        }))
                      }),
            );
          }),
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

    Widget buildDog(Dog dog) => ListTile(
          leading: Text(dog.name),
          title: Text(dog.breed),
          subtitle: Text(dog.arrivalDate),
        );
  }
}
