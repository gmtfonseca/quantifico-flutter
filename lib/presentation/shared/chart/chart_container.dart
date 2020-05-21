import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart_container/barrel.dart';
import 'package:quantifico/presentation/shared/chart/chart.dart';
import 'package:quantifico/presentation/shared/chart/full_screen_chart.dart';

class ChartContainer extends StatelessWidget {
  final String title;
  final ChartContainerBloc bloc;
  final Chart chart;
  final VoidCallback onStarOrUnstar;
  final double height;

  const ChartContainer({
    Key key,
    @required this.bloc,
    @required this.chart,
    @required this.title,
    this.onStarOrUnstar,
    this.height = 420,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Material(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: chart,
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
        return Container(
          color: state is ChartContainerLoaded ? state.color : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: _buildTitle(state),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _buildOptions(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(ChartContainerState state) {
    const fontSize = 16.0;
    if (state is ChartContainerLoaded) {
      return Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      );
    } else {
      return Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: Colors.black45,
        ),
      );
    }
  }

  List<Widget> _buildOptions(BuildContext context, ChartContainerState state) {
    final options = [
      _buildStarButton(state),
      _buildFilterButton(context, state),
      _buildFullScreenButton(context, state),
    ];

    return options;
  }

  Widget _buildStarButton(ChartContainerState state) {
    if (state is ChartContainerLoaded) {
      return IconButton(
        icon: Icon(state.isStarred ? Icons.star : Icons.star_border, color: Colors.white),
        onPressed: () {
          if (state.isStarred) {
            bloc.add(const UnstarChart());
          } else {
            bloc.add(const StarChart());
          }
          if (onStarOrUnstar != null) {
            onStarOrUnstar();
          }
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.star_border),
        onPressed: null,
      );
    }
  }

  Widget _buildFilterButton(BuildContext context, ChartContainerState state) {
    if (state is ChartContainerLoaded) {
      return IconButton(
          icon: Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {
            showDialog<Widget>(
              context: context,
              builder: (BuildContext context) => chart.buildFilterDialog(),
            );
          });
    } else {
      return IconButton(
        icon: Icon(Icons.filter_list),
        onPressed: null,
      );
    }
  }

  Widget _buildFullScreenButton(BuildContext context, ChartContainerState state) {
    return IconButton(
      icon: state is ChartContainerLoaded ? Icon(Icons.fullscreen, color: Colors.white) : Icon(Icons.fullscreen),
      onPressed: state is ChartContainerLoaded ? () => _openFullScreenMode(context, state.color) : null,
    );
  }

  void _openFullScreenMode(BuildContext context, Color appBarColor) {
    Navigator.push(
      context,
      MaterialPageRoute<FullScreenChart>(
        builder: (context) {
          return FullScreenChart(
            title: title,
            appBarColor: appBarColor,
            child: chart,
          );
        },
      ),
    );
  }
}
