import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quantifico/bloc/simple_bloc_delegate.dart';
import 'package:quantifico/presentation/screen/main_screen.dart';

import 'bloc/tab/tab.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(Quantifico());
}

class Quantifico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantifico',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<TabBloc>(
        create: (context) => TabBloc(),
        child: MainScreen(),
      ),
    );
  }
}
