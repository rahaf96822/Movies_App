import 'package:flutter/material.dart';
import 'package:moviesapp/models/trailer_model.dart';
import 'package:moviesapp/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class TrailerBloc{
  final repository = Repository();
  final movieFetcher = PublishSubject<TrailerModel>();

  Observable<TrailerModel> get allTrailer => movieFetcher.stream;

  fetchAllTrailers(int movieId) async {
    TrailerModel itemModel = await repository.fetchTrailers(movieId);
    movieFetcher.sink.add(itemModel);
  }

  dispose(){
    movieFetcher.close();
  }
}

final bloc_trailer = TrailerBloc();