import 'package:flutter/material.dart';

/// iPhone 16e Screen Dimensions
/// Width: 390 logical points (pt)
/// Height: 844 logical points (pt)
/// Device Pixel Ratio: 3.0
class IPhone16ProWrapper extends StatelessWidget {
  final Widget child;
  
  // iPhone 16e dimensions in logical points
  static const double deviceWidth = 390.0;
  static const double deviceHeight = 844.0;
  static const double devicePixelRatio = 3.0;

  const IPhone16ProWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Override MediaQuery to use iPhone 16 Pro dimensions
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        size: const Size(deviceWidth, deviceHeight),
        devicePixelRatio: devicePixelRatio,
      ),
      child: child,
    );
  }
}
