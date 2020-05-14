import 'package:equatable/equatable.dart';
import 'package:quantifico/bloc/chart/special/barrel.dart';

abstract class InsightScreenState extends Equatable {
  const InsightScreenState();

  @override
  List<Object> get props => [];
}

class InsightScreenLoading extends InsightScreenState {}

class InsightScreenLoaded extends InsightScreenState {
  final AnnualSalesBloc annualSalesBloc;
  final CustomerSalesBloc customerSalesBloc;
  final CitySalesBloc citySalesBloc;
  final MonthlySalesBloc monthlySalesBloc;

  const InsightScreenLoaded({
    this.annualSalesBloc,
    this.customerSalesBloc,
    this.citySalesBloc,
    this.monthlySalesBloc,
  });

  @override
  List<Object> get props => [annualSalesBloc, customerSalesBloc];
}

class InsightScreenNotLoaded extends InsightScreenState {}
