import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart/chart_state.dart';
import 'package:quantifico/bloc/chart_container/chart_container.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/data/model/chart/chart.dart';
import 'package:quantifico/presentation/shared/chart/full_screen_chart.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';

class ChartContainer extends StatelessWidget {
  final String title;
  final ChartContainerBloc bloc;
  final Chart chart;
  final Widget filterDialog;
  final double height;

  ChartContainer({
    Key key,
    @required this.bloc,
    @required this.chart,
    this.title,
    this.filterDialog,
    this.height = 450,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: height,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Material(
        child: Column(
          children: [
            _buildHeader(context),
            Divider(thickness: 1.5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildContent(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<ChartContainerBloc, ChartContainerState>(
      bloc: bloc,
      builder: (
        BuildContext context,
        ChartContainerState state,
      ) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _buildOptions(context, state),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildOptions(BuildContext context, ChartContainerState state) {
    final options = [
      _buildStarButton(state),
      _buildFilterButton(context),
      _buildFullScreenButton(context),
    ];

    return options;
  }

  Widget _buildStarButton(ChartContainerState state) {
    return IconButton(
      icon: _buildStarIcon(state),
      onPressed: () {
        if ((state as ChartContainerLoaded).isStarred) {
          bloc.add(UnstarChart(chart.name));
        } else {
          bloc.add(StarChart(chart.name));
        }
      },
    );
  }

  Widget _buildStarIcon(ChartContainerState state) {
    if (state is ChartContainerLoaded) {
      return Icon(state.isStarred ? Icons.star : Icons.star_border);
    } else {
      return SizedBox();
    }
  }

  Widget _buildFilterButton(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: filterDialog != null
            ? () {
                showDialog(
                  context: context,
                  child: filterDialog,
                );
              }
            : null);
  }

  Widget _buildFullScreenButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.fullscreen),
      onPressed: chart.state is SeriesLoaded ? () => _openFullScreenMode(context) : null,
    );
  }

  Widget _buildContent() {
    if (chart.state is SeriesLoading) {
      return LoadingIndicator();
    } else if (chart.state is SeriesNotLoaded) {
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
    } else if (chart.state is SeriesLoadedEmpty) {
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
      return chart.widget;
    }
  }

  void _openFullScreenMode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FullScreenChart(
            title: title,
            child: chart.widget,
          );
        },
      ),
    );
  }
}
