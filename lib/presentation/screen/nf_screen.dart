import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/nf_screen/barrel.dart';
import 'package:quantifico/data/model/nf/nf_screen_record.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';
import 'package:quantifico/util/date_util.dart';
import 'package:quantifico/util/number_util.dart';

class NfScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffe0e0e0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: BlocBuilder<NfScreenBloc, NfScreenState>(
          builder: (context, state) {
            if (state is NfScreenLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  final bloc = BlocProvider.of<NfScreenBloc>(context);
                  bloc.add(const LoadNfScreen());
                },
                child: _buildNfs(context, state),
              );
            } else if (state is NfScreenLoading) {
              return const LoadingIndicator();
            } else {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não foi possível carregar suas Notas Fiscais'),
                    const SizedBox(width: 5),
                    Icon(Icons.sentiment_dissatisfied),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildNfs(BuildContext context, NfScreenLoaded state) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 5),
      itemCount: state.nfScreenRecords.length,
      itemBuilder: (context, index) {
        final nfScreenRecord = state.nfScreenRecords[index];
        return _buildNfTile(nfScreenRecord);
      },
    );
  }

  Widget _buildNfTile(NfScreenRecord nfScreenRecord) {
    return Container(
      color: Colors.white,
      height: 100,
      child: Row(
        children: [
          Container(
            color: nfScreenRecord.color,
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nfScreenRecord.nf.series,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  nfScreenRecord.nf.number.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDate(nfScreenRecord.nf.date)),
                      Text(formatCurrency(nfScreenRecord.nf.totalAmount)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          nfScreenRecord.nf.customer.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
