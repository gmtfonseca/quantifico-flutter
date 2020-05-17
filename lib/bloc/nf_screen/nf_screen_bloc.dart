import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/nf_screen/barrel.dart';
import 'package:quantifico/data/model/nf/nf_screen_record.dart';
import 'package:quantifico/data/repository/nf_repository.dart';
import 'package:meta/meta.dart';

class NfScreenBloc extends Bloc<NfScreenEvent, NfScreenState> {
  final NfRepository nfRepository;
  int _colorIdx = 0;

  NfScreenBloc({@required this.nfRepository});

  @override
  NfScreenState get initialState => NfScreenLoading();

  @override
  Stream<NfScreenState> mapEventToState(NfScreenEvent event) async* {
    if (event is LoadNfScreen) {
      yield* _mapLoadNfScreenToState();
    }
  }

  Stream<NfScreenState> _mapLoadNfScreenToState() async* {
    try {
      yield NfScreenLoading();
      final nfs = await nfRepository.getNfs();
      _colorIdx = 9;
      final nfScreenRecords = nfs.map((nf) => NfScreenRecord(color: getColor(), nf: nf)).toList();
      yield NfScreenLoaded(nfScreenRecords: nfScreenRecords);
    } catch (e) {
      yield NfScreenNotLoaded();
    }
  }

  Color getColor() {
    final colors = [
      Colors.red,
      Colors.indigo,
      Colors.green,
      Colors.blue,
      Colors.amber,
      Colors.deepPurple,
    ];

    if (_colorIdx >= colors.length) {
      _colorIdx = 0;
    }

    final currColor = colors[_colorIdx];
    _colorIdx += 1;
    return currColor;
  }
}
