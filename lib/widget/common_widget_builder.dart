import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonWidgetBuilder {  
  static Widget loadNetworkImage(url, {width: 100.0, height: 100.0, EdgeInsets padding: const EdgeInsets.all(0), linearProcess: true, roundRadius = 0.0 }) {
    Widget img = CachedNetworkImage(
      placeholder: (context, url) => (
        linearProcess ? LinearProgressIndicator() : 
        Container(
          width: width, height: height,
          child: Center(child: CircularProgressIndicator())
        )
      ),
      imageUrl: url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 1500),
    );

    Widget res;
    if (roundRadius != 0.0) {
      res = ClipRRect(
        child: img, clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(roundRadius)
      );
    } else {
      res = img;
    }

    return Container(
      padding: padding,
      child: Center(
        child: res,
      )
    );
  }
}