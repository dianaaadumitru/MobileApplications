import 'package:exam_5a/repository/DbRepository.dart';
import 'package:exam_5a/view/AddMoviePage.dart';
import 'package:exam_5a/view/GenresListWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainSection extends StatefulWidget {
  const MainSection({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _MainSection();
}

class _MainSection extends State<MainSection> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text("Main Section"),
     ),
     body: const GenresListWidget(),
     floatingActionButton: Container(
       alignment: Alignment.bottomCenter,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           const Spacer(),
           const Spacer(),
           ElevatedButton(
               onPressed: () {

               },
               child: const Text("Release year section")
           ),
           const Spacer(),
           ElevatedButton(
               onPressed: () {
                  Provider.of<DbRepository>(context, listen: false).checkOnline();
               },
               child: const Text("Refresh")
           ),
           const Spacer(),
           ElevatedButton(
               onPressed: () {
                 Navigator.of(context)
                     .push(MaterialPageRoute<void>(builder: (context) {
                   return AddMoviePage();
                 }));
               },
               child: const Text("Add movie")
           ),
           const Spacer(),
         ],
       ),
     ),
   );
  }
  
}