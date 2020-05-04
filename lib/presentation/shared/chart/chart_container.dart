import 'package:flutter/material.dart';
import 'package:quantifico/bloc/chart/chart_state.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';

class ChartContainer extends StatelessWidget {
  final String title;
  final ChartState chartState;
  final Widget chart;
  final Widget filtersDialog;

  ChartContainer({
    Key key,
    this.title,
    @required this.chartState,
    @required this.chart,
    this.filtersDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Card(
        elevation: 10,
        child: Column(
          children: [
            _buildHeader(context),
            Divider(),
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
            style: Theme.of(context).textTheme.title,
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
      )
    ];

    if (filtersDialog != null) {
      options.add(
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            showDialog(
              context: context,
              child: filtersDialog,
            );
          },
        ),
      );
    }
    return options;
  }

  Widget _buildContent() {
    if (chartState is DataLoading) {
      return LoadingIndicator();
    } else if (chartState is DataNotLoaded) {
      return Center(child: Text('An occurred while loading the data'));
    } else {
      return chart;
    }
  }
}
