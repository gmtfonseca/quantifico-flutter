export 'annual_sales_record.dart';
export 'customer_sales_record.dart';
export 'city_sales_record.dart';
export 'monthly_sales_record.dart';

import 'package:flutter/material.dart';
import 'package:quantifico/bloc/chart/chart_state.dart';

class Chart {
  final String name;
  final ChartState state;
  final Widget widget;

  const Chart({this.name, this.state, this.widget});
}
