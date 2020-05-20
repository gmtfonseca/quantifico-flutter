import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantifico/bloc/nf_screen/barrel.dart';
import 'package:quantifico/data/model/nf/nf_screen_filter.dart';
import 'package:quantifico/data/model/nf/nf_screen_record.dart';
import 'package:quantifico/data/repository/nf_repository.dart';
import 'package:meta/meta.dart';

class NfScreenBloc extends Bloc<NfScreenEvent, NfScreenState> {
  final NfRepository nfRepository;
  NfScreenFilter _activeFilter;
  int _page = 1;
  int _colorIdx = 0;

  NfScreenBloc({@required this.nfRepository});

  @override
  NfScreenState get initialState => NfScreenLoading();

  @override
  Stream<NfScreenState> mapEventToState(NfScreenEvent event) async* {
    if (event is LoadNfScreen) {
      yield* _mapLoadNfScreenToState();
    } else if (event is LoadMoreNfScreen) {
      yield* _mapLoadMoreNfScreenToState();
    } else if (event is UpdateFilterNfScreen) {
      yield* _mapUpdateFilterNfScreenToState(event);
    }
  }

  Stream<NfScreenState> _mapLoadNfScreenToState() async* {
    try {
      yield NfScreenLoading();
      _page = 1;
      final nfs = await nfRepository.getNfs(
        initialDate: _activeFilter?.initialDate,
        endDate: _activeFilter?.endDate,
        customerName: _activeFilter?.customerName,
        page: _page,
      );
      _colorIdx = 0;
      final nfScreenRecords = nfs.map((nf) => NfScreenRecord(color: getColor(), nf: nf)).toList();
      yield NfScreenLoaded(
        nfScreenRecords: nfScreenRecords,
        activeFilter: _activeFilter,
      );
    } catch (e) {
      yield NfScreenNotLoaded();
    }
  }

  Stream<NfScreenState> _mapLoadMoreNfScreenToState() async* {
    if (state is NfScreenLoaded) {
      final nfScreenLoadedState = state as NfScreenLoaded;
      try {
        yield NfScreenLoadingMore(
          nfScreenRecords: nfScreenLoadedState.nfScreenRecords,
          activeFilter: _activeFilter,
        );
        _page += 1;
        final extendedNfScreenRecords = List<NfScreenRecord>.from(nfScreenLoadedState.nfScreenRecords);
        final nfs = await nfRepository.getNfs(
          initialDate: _activeFilter?.initialDate,
          endDate: _activeFilter?.endDate,
          customerName: _activeFilter?.customerName,
          page: _page,
        );
        final nfScreenRecords = nfs.map((nf) => NfScreenRecord(color: getColor(), nf: nf)).toList();
        extendedNfScreenRecords.addAll(nfScreenRecords);
        yield NfScreenLoaded(
          nfScreenRecords: extendedNfScreenRecords,
          activeFilter: _activeFilter,
        );
      } catch (e) {
        yield NfScreenNotLoaded();
      }
    }
  }

  Stream<NfScreenState> _mapUpdateFilterNfScreenToState(UpdateFilterNfScreen event) async* {
    try {
      _activeFilter = NfScreenFilter(
        initialDate: event.filter?.initialDate,
        endDate: event.filter?.endDate,
        customerName: event.filter?.customerName,
      );
      yield* _mapLoadNfScreenToState();
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
      Colors.orange,
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
