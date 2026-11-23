import 'dart:convert';

import 'package:flutter/material.dart';

/// An image from an embedded data URI (the gym photos travel as base64
/// data URIs, exactly as in the React edition).
class DataImage extends StatelessWidget {
  const DataImage(this.uri, {super.key, this.height, this.width, this.fit = BoxFit.cover});

  final String uri;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    try {
      final bytes = base64Decode(uri.split(',').last);
      return Image.memory(bytes, height: height, width: width, fit: fit);
    } catch (_) {
      return Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
        child: const Icon(Icons.fitness_center, color: Colors.grey),
      );
    }
  }
}
