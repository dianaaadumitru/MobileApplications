import 'package:exam/repository/DbRepository.dart';
import 'package:exam/view/MainSection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var service = await DbRepository.init();

  runApp(ChangeNotifierProvider(
      create: (_) => service,
      child: const MaterialApp(title: 'Main Section', home: MainSection())));
}
