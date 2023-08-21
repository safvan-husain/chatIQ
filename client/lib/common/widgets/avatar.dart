import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';

Widget avatarPreview(DrawableRoot svgRoot) {
  return Container(
    height: 180.0,
    width: 180.0,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: CustomPaint(
      painter: MyPainter(svgRoot, const Size(180.0, 180.0)),
      child: Container(),
    ),
  );
}

class MyPainter extends CustomPainter {
  MyPainter(this.svg, this.size);

  final DrawableRoot svg;
  final Size size;
  @override
  void paint(Canvas canvas, Size size) {
    svg.scaleCanvasToViewBox(canvas, size);
    svg.clipCanvasToViewBox(canvas);
    svg.draw(canvas, Rect.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Future<Widget> showAvatar(
  double size, {
  String? svgCode,
  String? username,
}) async {
  DrawableRoot? svgRoot;
  if (svgCode != null) {
    svgRoot = await _generateSvg(svgCode: svgCode);
  } else if (username != null) {
    svgRoot = await _generateSvg(username: username);
  } else {
    svgRoot = await _generateSvg();
  }
  if (svgRoot == null) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
  return Container(
    height: size,
    width: size,
    decoration: const BoxDecoration(
      color: Colors.grey,
      shape: BoxShape.circle,
    ),
    child: CustomPaint(
      painter: MyPainter(svgRoot, Size(size, size)),
      child: Container(),
    ),
  );
}

Future<DrawableRoot?> _generateSvg({String? svgCode, String? username}) async {
  svgCode ??= multiavatar('X-SLAYER');
  if (username != null) {
    svgCode = multiavatar(username);
  }
  return SvgWrapper(svgCode).generateLogo();
}

class SvgWrapper {
  final String rawSvg;

  SvgWrapper(this.rawSvg);

  Future<DrawableRoot?> generateLogo() async {
    try {
      return await svg.fromSvgString(rawSvg, rawSvg);
    } catch (e) {
      print(e);
      throw Error();
    }
  }
}
