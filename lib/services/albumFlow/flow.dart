import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math.dart' as vector;

import 'album.dart';
import 'albumImage.dart';
import 'albumDetail.dart';

const itemHeight = 220.0;
const itemFactor = 0.6;

class AlbumFlowPage extends StatefulWidget {
  @override
  _AlbumFlowPageState createState() => _AlbumFlowPageState();
}

class _AlbumFlowPageState extends State<AlbumFlowPage> {
  bool isGoingDown = false;

  final _pageController = PageController();
  final _pageNotifier = ValueNotifier<double>(0.0);
  double _lastOffset = 0.0;
  int numberOfElements = 30;

  void _scrollListener() {
    _pageNotifier.value = _pageController.offset;

    if (_lastOffset < _pageNotifier.value) {
      isGoingDown = false;
    } else {
      isGoingDown = true;
    }
    _lastOffset = _pageNotifier.value;
  }

  Future<List<Album>> _loadData() async {
    final jsonData = await rootBundle.loadString('assets/albums.json');
    final result = (json.decode(jsonData)['topalbums']['album'] as List)
        .map((item) => Album.fromJson(item))
        .toList();
    return result;
  }

  void _onTapAlbum(String image, double angle, int index) {
    final page = AlbumFlowDetailPage(
      image: image,
      angle: angle,
      index: index,
    );
    Navigator.of(context).push(
      PageRouteBuilder<Null>(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: page,
          );
        },
        transitionDuration: Duration(milliseconds: 700),
      ),
    );
  }

  @override
  void initState() {
    _pageController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_scrollListener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<List<Album>>(
                future: _loadData(),
                builder: (context, snapshot) {
                  return Positioned(
                    child: snapshot.hasData
                        ? ValueListenableBuilder<double>(
                            valueListenable: _pageNotifier,
                            builder: (context, value, child) {
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    top: 55, left: 25, right: 25),
                                controller: _pageController,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final t =
                                      (index * itemHeight * itemFactor - value)
                                              .abs() /
                                          numberOfElements;
                                  final rotationY =
                                      lerpDouble(0.0, 5, t)! - 360.0;
                                  return Align(
                                    alignment: Alignment.center,
                                    heightFactor: itemFactor,
                                    child: Transform(
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.002)
                                        ..rotateX(vector.radians(rotationY)),
                                      alignment: Alignment.center,
                                      child: InkWell(
                                        onTap: () {
                                          _onTapAlbum(
                                              snapshot.data![index].image,
                                              rotationY,
                                              index);
                                        },
                                        child: SizedBox(
                                          height: itemHeight,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Positioned.fill(
                                                child: AlbumImage(
                                                  image: snapshot
                                                      .data![index].image,
                                                  angle: rotationY,
                                                  index: index,
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black87,
                                                        spreadRadius: 15,
                                                        blurRadius: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            })
                        : Center(
                            child: const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          ),
                  );
                }),
            Positioned(
              bottom: 0,
              child: Container(
                  color: Colors.pinkAccent,
                  width: MediaQuery.of(context).size.width,
                  height: 170,
                  child: Text(
                    'Days of the calendar',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
