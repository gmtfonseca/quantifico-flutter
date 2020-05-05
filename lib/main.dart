import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quantifico/bloc/simple_bloc_delegate.dart';
import 'package:quantifico/data/provider/chart_web_provider.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/presentation/screen/main_screen.dart';
import 'package:quantifico/util/web_client.dart';

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
        fontFamily: 'Raleway',
        primarySwatch: Colors.deepPurple,
      ),
      home: BlocProvider<TabBloc>(
        create: (context) => TabBloc(),
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ChartRepository>(
              create: (context) {
                final webClient = WebClient();
                final chartWebProvider = ChartWebProvider(webClient: webClient);
                return ChartRepository(
                  chartWebProvider: chartWebProvider,
                );
              },
            )
          ],
          child: MainScreen(),
        ),
      ),
    );
  }
}
