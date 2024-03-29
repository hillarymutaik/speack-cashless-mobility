import 'package:flutter/material.dart';

import '../components/colors_frave.dart';

class FraveIndicatorTabBar extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _FravePainterIndicator(this, onChanged);
}

class _FravePainterIndicator extends BoxPainter {
  final FraveIndicatorTabBar decoration;

  _FravePainterIndicator(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Rect rect;

    rect = Offset(offset.dx + 6, (configuration.size!.height - 3)) &
        Size(configuration.size!.width - 12, 3);

    final paint = Paint()
      ..color = ColorsFrave.primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
        RRect.fromRectAndCorners(rect,
            topLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0)),
        paint);
  }
}
