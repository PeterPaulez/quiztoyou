import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vector_math/vector_math.dart' as vector;

class AlbumImage extends StatelessWidget {
  final String image;
  final double angle;

  const AlbumImage({
    Key? key,
    required this.image,
    required this.angle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: image,
      flightShuttleBuilder: (
        context,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        final Widget toHero = toHeroContext.widget;
        final Widget fromHero = fromHeroContext.widget;
        return AnimatedBuilder(
          animation: animation,
          child:
              flightDirection == HeroFlightDirection.push ? toHero : fromHero,
          builder: (context, child) {
            double newValue = 0.0;
            if (flightDirection == HeroFlightDirection.push) {
              newValue = lerpDouble((360.0 - angle.abs()), 0, animation.value)!;
            } else {
              newValue = lerpDouble(
                  0, (angle.abs() - 360).abs(), 1 - animation.value)!;
            }
            return Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateX(vector.radians(newValue)),
              child: child,
            );
          },
        );
      },
      child: Card(
        color: Colors.black,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
