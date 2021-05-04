import 'package:flutter/material.dart';

import 'albumImage.dart';

const _itemCounts = 20;

class AlbumFlowDetailPage extends StatelessWidget {
  final String image;
  final double angle;
  final int index;

  const AlbumFlowDetailPage({
    Key? key,
    required this.image,
    required this.angle,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 0.7;
    final margin = 20.0;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: null,
          ),
        ],
        title: Column(
          children: [
            Text('Detail Page'),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: _albumDetailWidget(margin, imageSize, size),
    );
  }

  Widget _albumDetailWidget(double margin, double imageSize, Size size) {
    return Stack(
      children: [
        Positioned.fill(
          left: margin / 2,
          right: margin / 2,
          top: imageSize - margin,
          bottom: 0.0,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 40),
              itemCount: _itemCounts,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  child: ListTile(
                    title: Text(
                      'Random Song ${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    trailing: Text('3:33'),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          width: imageSize,
          height: imageSize,
          top: 10,
          left: (size.width - imageSize) / 2,
          child: AlbumImage(
            image: image,
            angle: angle,
            index: this.index,
          ),
        ),
        /*
        Positioned(
          left: margin,
          top: margin,
          child: BackButton(
            color: Colors.white,
          ),
        ),
        */
      ],
    );
  }
}
