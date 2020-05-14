import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart_bloc.dart';
import 'package:quantifico/bloc/chart/chart_state.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';

abstract class Chart extends StatelessWidget {
  final ChartBloc bloc;

  Chart({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is SeriesLoading) {
          return LoadingIndicator();
        } else if (state is SeriesNotLoaded) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Não foi possível carregar gráfico'),
                SizedBox(width: 5),
                Icon(Icons.sentiment_dissatisfied),
              ],
            ),
          );
        } else if (state is SeriesLoadedEmpty) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sem dados para exibir'),
                SizedBox(width: 5),
                Icon(Icons.sentiment_neutral),
              ],
            ),
          );
        } else {
          return buildContent();
        }
      },
    );
  }

  @protected
  Widget buildContent();

  Widget filterDialog();
}
