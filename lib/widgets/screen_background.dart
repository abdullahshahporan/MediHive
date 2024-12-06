import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medi_hive/UI/utils/assets_path.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    Size screenSize=MediaQuery.sizeOf(context);
    return Stack(
      children: [
        SvgPicture.asset(
          Assetspath.backgroundSVG,
          fit: BoxFit.cover,
          height: screenSize.height,
          width: screenSize.width,
        ),
        child
      ],
    );
  }
}