import 'package:crud_operations/service/DogService.dart';
import 'package:crud_operations/view/homePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var service = await DogService.init();
  // service.populateList();
  runApp(
    ChangeNotifierProvider(
        create: (_) => service,
        child: MaterialApp(
            title: 'Dog Shelter Application',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Dog Shelter'),
              ),
              body: const HomePage(),
            ))),
  );
}
