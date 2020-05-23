import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/chart_container/barrel.dart';
import 'package:quantifico/config.dart';
import 'package:quantifico/presentation/chart/shared/chart.dart';
import 'package:quantifico/presentation/chart/shared/full_screen_chart.dart';

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
    SizeConfig().init(context);
    final borderRadius = BorderRadius.circular(11);
    return Container(
      height: height,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
          child: Material(
            borderRadius: borderRadius,
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: chart,
                  ),
                )
              ],
            ),
          ),
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
          decoration: BoxDecoration(
            color: state is ChartContainerLoaded ? state.color : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
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
    return Text(
      title,
      style: TextStyle(
        fontSize: SizeConfig.safeBlockHorizontal * 3.3,
        fontWeight: FontWeight.w400,
        color: state is ChartContainerLoaded ? Colors.white : Colors.black45,
      ),
    );
  }

  List<Widget> _buildOptions(
    BuildContext context,
    ChartContainerState state,
  ) {
    final iconSize = SizeConfig.safeBlockHorizontal * 4.5;
    final options = [
      _buildStarButton(state, iconSize),
      _buildRefreshButton(state, iconSize),
      _buildFilterButton(context, state, iconSize),
      _buildFullScreenButton(context, state, iconSize),
    ];

    return options;
  }

  Widget _buildStarButton(
    ChartContainerState state,
    double iconSize,
  ) {
    if (state is ChartContainerLoaded) {
      return IconButton(
        icon: Icon(
          state.isStarred ? Icons.star : Icons.star_border,
          color: Colors.white,
          size: iconSize,
        ),
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
        icon: Icon(
          Icons.star_border,
          size: iconSize,
        ),
        onPressed: null,
      );
    }
  }

  Widget _buildRefreshButton(
    ChartContainerState state,
    double iconSize,
  ) {
    if (state is ChartContainerLoaded) {
      return IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: () {
            bloc.add(const RefreshChart());
          });
    } else {
      return IconButton(
        icon: Icon(
          Icons.refresh,
          color: Colors.black45,
          size: iconSize,
        ),
        onPressed: null,
      );
    }
  }

  Widget _buildFilterButton(
    BuildContext context,
    ChartContainerState state,
    double iconSize,
  ) {
    if (state is ChartContainerLoaded) {
      return IconButton(
          icon: Icon(
            Icons.filter_list,
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: () {
            showDialog<Widget>(
              context: context,
              builder: (BuildContext context) => chart.buildFilterDialog(),
            );
          });
    } else {
      return IconButton(
        icon: Icon(
          Icons.filter_list,
          size: iconSize,
        ),
        onPressed: null,
      );
    }
  }

  Widget _buildFullScreenButton(
    BuildContext context,
    ChartContainerState state,
    double iconSize,
  ) {
    if (state is ChartContainerLoaded) {
      return IconButton(
        icon: Icon(
          Icons.fullscreen,
          color: Colors.white,
          size: iconSize,
        ),
        onPressed: () => _openFullScreenMode(context, state.color),
      );
    } else {
      return IconButton(
        icon: Icon(
          Icons.fullscreen,
          size: iconSize,
        ),
        onPressed: null,
      );
    }
  }

  void _openFullScreenMode(BuildContext context, Color appBarColor) {
    final fullScreenRoute = PageRouteBuilder<FullScreenChart>(
      pageBuilder: (context, animation, secondaryAnimation) => FullScreenChart(
        title: title,
        appBarColor: appBarColor,
        child: chart,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );

    Navigator.of(context).push(fullScreenRoute);
  }
}
