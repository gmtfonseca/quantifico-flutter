import 'package:flutter/material.dart';
import 'package:quantifico/bloc/chart/chart_state.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/presentation/shared/chart/full_screen_chart.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';

class ChartContainer extends StatelessWidget {
  final String title;
  final ChartState chartState;
  final Widget chart;
  final Widget filterDialog;
  final double height;

  ChartContainer({
    Key key,
    this.title,
    @required this.chartState,
    @required this.chart,
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
          children: _buildOptions(context),
        ),
      ],
    );
  }

  List<Widget> _buildOptions(BuildContext context) {
    final options = [
      IconButton(
        icon: Icon(Icons.favorite_border),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.fullscreen),
        onPressed: () => _openFullScreenMode(context),
      ),
    ];

    if (filterDialog != null) {
      options.add(
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            showDialog(
              context: context,
              child: filterDialog,
            );
          },
        ),
      );
    }
    return options;
  }

  Widget _buildContent() {
    if (chartState is SeriesLoading) {
      return LoadingIndicator();
    } else if (chartState is SeriesNotLoaded) {
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
    } else if (chartState is SeriesLoadedEmpty) {
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
      return chart;
    }
  }

  void _openFullScreenMode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FullScreenChart(
            title: title,
            child: chart,
          );
        },
      ),
    );
  }
}
