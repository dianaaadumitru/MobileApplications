import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repository/DbRepository.dart';
import '../../utils/Pair.dart';
import '../MainSection.dart';


class HealthDataListWidget extends StatefulWidget {
  final String _date;

  const HealthDataListWidget(this._date, {super.key});

  @override
  State<StatefulWidget> createState() => _HealthDataListWidget();
}

class _HealthDataListWidget extends State<HealthDataListWidget> {
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
            return const MainSection();
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
                                    return const MainSection();
                                  }));
                        },
                        child: const Text("OK"))
                  ],
                );
              });
        }

        // result.then((value) => {
        //   if (value.right is bool && value.right)
        //     {
        //       Navigator.of(context)
        //           .push(MaterialPageRoute<void>(builder: (context) {
        //         return const MainSection();
        //       }))
        //     }
        //   else
        //     {
        //       showDialog(
        //           context: context,
        //           builder: (BuildContext context) {
        //             return AlertDialog(
        //               title: const Text("Error"),
        //               content: const Text(
        //                   "You are offline or there is a problem, please try again later."),
        //               actions: [
        //                 ElevatedButton(
        //                     onPressed: () {
        //                       Navigator.of(context).push(
        //                           MaterialPageRoute<void>(
        //                               builder: (context) {
        //                                 return const MainSection();
        //                               }));
        //                     },
        //                     child: const Text("OK"))
        //               ],
        //             );
        //           })
        //     }
        // });
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
    var entitiesFuture = Provider.of<DbRepository>(context, listen: true)
        .getHealthDataByDate(widget._date);
    return FutureBuilder<Pair>(
        future: entitiesFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text("none");
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return const Text("active");
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text(
                  '${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                );
              }
          }

          var entities = snapshot.data;
          if (entities?.left?.left.length == 0 && !entities?.right) {
            return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.blue.shade300,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: const Text("offline"),
            );
          }

          if (entities?.left?.left.length == 0 && entities?.right) {
            return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.blue.shade300,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: const Text("No elements in the list"),
            );
          }

          return ListView.builder(
              itemCount: entities?.left.left.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var entity = entities?.left.left[index];

                if (entities?.left.left != [] && entity == null) {
                  return const Card();
                } else if (entity == null && index == 0) {
                  return const Card(
                    child: Text("No elements in the list"),
                  );
                } else if (entity == null) {
                  return const Card();
                }

                var card = Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.blue.shade300,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          entity.symptom,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          entity.medication,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          entity.dosage,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          entity.doctor,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          entity.notes,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    onTap: () => {
                      showAreYouSureDialog(entity.id)
                    },
                  ),
                );

                if (entities?.right == false && index == 0) {
                  return Card(
                    child: Column(children: [const Text("Offline"), card]),
                  );
                }

                return card;
              });
        });
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
