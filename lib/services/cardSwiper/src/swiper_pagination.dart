import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:quiztoyou/services/cardSwiper/src/swiper.dart';
import 'package:quiztoyou/services/cardSwiper/src/swiper_plugin.dart';
import 'package:quiztoyou/services/cardSwiper/widgets/flutter_page_indicator/flutter_page_indicator.dart';

class FractionPaginationBuilder extends SwiperPlugin {
  ///color ,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  ///color when active,if set null , will be Theme.of(context).primaryColor
  final Color? activeColor;

  ////font size
  final double fontSize;

  ///font size when active
  final double activeFontSize;

  final Key? key;

  const FractionPaginationBuilder(
      {this.color,
      this.fontSize: 20.0,
      this.key,
      this.activeColor,
      this.activeFontSize: 35.0});

  @override
  Widget build(BuildContext context, SwiperPluginConfig? config) {
    final ThemeData themeData = Theme.of(context);
    final Color activeColor = this.activeColor ?? themeData.primaryColor;
    final Color color = this.color ?? themeData.scaffoldBackgroundColor;

    if (Axis.vertical == config!.scrollDirection) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${config.activeIndex! + 1}',
            style: TextStyle(color: activeColor, fontSize: activeFontSize),
          ),
          Text(
            '/',
            style: TextStyle(color: color, fontSize: fontSize),
          ),
          Text(
            '${config.itemCount}',
            style: TextStyle(color: color, fontSize: fontSize),
          )
        ],
      );
    } else {
      return Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${config.activeIndex! + 1}',
            style: TextStyle(color: activeColor, fontSize: activeFontSize),
          ),
          Text(
            ' / ${config.itemCount}',
            style: TextStyle(color: color, fontSize: fontSize),
          )
        ],
      );
    }
  }
}

class RectSwiperPaginationBuilder extends SwiperPlugin {
  ///color when current index,if set null , will be Theme.of(context).primaryColor
  final Color? activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  ///Size of the rect when activate
  final Size activeSize;

  ///Size of the rect
  final Size size;

  /// Space between rects
  final double space;

  final Key? key;

  const RectSwiperPaginationBuilder(
      {this.activeColor,
      this.color,
      this.key,
      this.size: const Size(10.0, 2.0),
      this.activeSize: const Size(10.0, 2.0),
      this.space: 3.0});

  @override
  Widget build(BuildContext context, SwiperPluginConfig? config) {
    final ThemeData themeData = Theme.of(context);
    final Color activeColor = this.activeColor ?? themeData.primaryColor;
    final Color color = this.color ?? themeData.scaffoldBackgroundColor;

    final List<Widget> list = [];

    if (config!.itemCount! > 20) {
      // ignore: avoid_print
      print(
          'The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this sitituation');
    }

    final int itemCount = config.itemCount!;
    final int? activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      final bool active = i == activeIndex;
      final Size size = active ? this.activeSize : this.size;
      list.add(SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          color: active ? activeColor : color,
          key: Key('pagination_$i'),
          margin: EdgeInsets.all(space),
        ),
      ));
    }

    if (config.scrollDirection == Axis.vertical) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    }
  }
}

class DotSwiperPaginationBuilder extends SwiperPlugin {
  ///color when current index,if set null , will be Theme.of(context).primaryColor
  final Color? activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  ///Size of the dot when activate
  final double activeSize;

  ///Size of the dot
  final double size;

  /// Space between dots
  final double space;

  final Key? key;

  const DotSwiperPaginationBuilder(
      {this.activeColor,
      this.color,
      this.key,
      this.size: 10.0,
      this.activeSize: 10.0,
      this.space: 3.0});

  @override
  Widget build(BuildContext context, SwiperPluginConfig? config) {
    if (config!.itemCount! > 20) {
      // ignore: avoid_print
      print(
          'The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this sitituation');
    }
    Color? activeColor = this.activeColor;
    Color? color = this.color;

    if (activeColor == null || color == null) {
      final ThemeData themeData = Theme.of(context);
      activeColor = this.activeColor ?? themeData.primaryColor;
      color = this.color ?? themeData.scaffoldBackgroundColor;
    }

    if (config.indicatorLayout != PageIndicatorLayout.NONE &&
        config.layout == SwiperLayout.DEFAULT) {
      return PageIndicator(
        count: config.itemCount,
        controller: config.pageController,
        layout: config.indicatorLayout,
        size: size,
        activeColor: activeColor,
        color: color,
        space: space,
      );
    }

    final List<Widget> list = [];

    final int itemCount = config.itemCount!;
    final int? activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      final bool active = i == activeIndex;
      list.add(Container(
        key: Key('pagination_$i'),
        margin: EdgeInsets.all(space),
        child: ClipOval(
          child: Container(
            color: active ? activeColor : color,
            width: active ? activeSize : size,
            height: active ? activeSize : size,
          ),
        ),
      ));
    }

    if (config.scrollDirection == Axis.vertical) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    }
  }
}

typedef Widget SwiperPaginationBuilder(
    BuildContext context, SwiperPluginConfig? config);

class SwiperCustomPagination extends SwiperPlugin {
  final SwiperPaginationBuilder builder;

  SwiperCustomPagination({required this.builder});

  @override
  Widget build(BuildContext context, SwiperPluginConfig? config) {
    return builder(context, config);
  }
}

class SwiperPagination extends SwiperPlugin {
  /// dot style pagination
  static const SwiperPlugin dots = DotSwiperPaginationBuilder();

  /// fraction style pagination
  static const SwiperPlugin fraction = FractionPaginationBuilder();

  static const SwiperPlugin rect = RectSwiperPaginationBuilder();

  /// Alignment.bottomCenter by default when scrollDirection== Axis.horizontal
  /// Alignment.centerRight by default when scrollDirection== Axis.vertical
  final Alignment? alignment;

  /// Distance between pagination and the container
  final EdgeInsetsGeometry margin;

  /// Build the widet
  final SwiperPlugin builder;

  final Key? key;

  const SwiperPagination(
      {this.alignment,
      this.key,
      this.margin: const EdgeInsets.all(10.0),
      this.builder: SwiperPagination.dots});

  Widget build(BuildContext context, SwiperPluginConfig? config) {
    final Alignment alignment = this.alignment ??
        (config!.scrollDirection == Axis.horizontal
            ? Alignment.bottomCenter
            : Alignment.centerRight);
    Widget child = Container(
      margin: margin,
      child: this.builder.build(context, config),
    );
    if (!config!.outer!) {
      child = Align(
        key: key,
        alignment: alignment,
        child: child,
      );
    }
    return child;
  }
}