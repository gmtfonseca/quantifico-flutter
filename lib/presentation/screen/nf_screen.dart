import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/nf_screen/barrel.dart';
import 'package:quantifico/presentation/shared/loading_indicator.dart';

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
              return const Center(child: Text('Error'));
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
        return Container(
          color: Colors.white,
          child: ListTile(
            isThreeLine: true,
            leading: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: nfScreenRecord.color,
                shape: BoxShape.circle,
              ),
            ),
            title: Text(nfScreenRecord.nf.number.toString()),
            subtitle: Text(nfScreenRecord.nf.customer.name.toString()),
          ),
        );
      },
    );
  }
}
