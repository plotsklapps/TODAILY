import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MosaicCloud extends MultiChildRenderObjectWidget {
  final double spacing;

  const MosaicCloud({super.key, required super.children, this.spacing = 4.0});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMosaicCloudBox(spacing: spacing);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderMosaicCloudBox renderObject,
  ) {
    renderObject.spacing = spacing;
  }
}

class _MosaicCloudParentData extends ContainerBoxParentData<RenderBox> {}

class RenderMosaicCloudBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _MosaicCloudParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _MosaicCloudParentData> {
  double _spacing;

  RenderMosaicCloudBox({required double spacing}) : _spacing = spacing;

  double get spacing => _spacing;

  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _MosaicCloudParentData) {
      child.parentData = _MosaicCloudParentData();
    }
  }

  @override
  void performLayout() {
    if (firstChild == null) {
      size = Size.zero;
      return;
    }

    final List<Rect> calculatedRects = [];
    RenderBox? child = firstChild;
    final List<RenderBox> children = [];

    // Layout children with loose constraints to get their preferred sizes
    while (child != null) {
      final childParentData = child.parentData as _MosaicCloudParentData;
      children.add(child);

      child.layout(const BoxConstraints(), parentUsesSize: true);
      final childSize = child.size;

      Rect childRect;
      if (calculatedRects.isEmpty) {
        childRect = Offset.zero & childSize;
      } else {
        childRect = _findNextPosition(childSize, calculatedRects);
      }
      calculatedRects.add(childRect);
      child = childParentData.nextSibling;
    }

    Rect boundingBox = calculatedRects.reduce((a, b) => a.expandToInclude(b));

    double scale = 1.0;
    if (boundingBox.width > constraints.maxWidth) {
      scale = constraints.maxWidth / boundingBox.width;
    }
    if (boundingBox.height * scale > constraints.maxHeight) {
      scale = constraints.maxHeight / boundingBox.height;
    }

    final Matrix4 transform = Matrix4.identity()..scale(scale, scale);

    final Offset offsetToOrigin = -boundingBox.topLeft;

    for (int i = 0; i < children.length; i++) {
      final childParentData = children[i].parentData as _MosaicCloudParentData;
      final initialOffset = calculatedRects[i].topLeft + offsetToOrigin;
      childParentData.offset = MatrixUtils.transformPoint(
        transform,
        initialOffset,
      );

      children[i].layout(
        BoxConstraints.tight(calculatedRects[i].size * scale),
        parentUsesSize: true,
      );
    }

    size = constraints.constrain(boundingBox.size * scale);
  }

  Rect _findNextPosition(Size childSize, List<Rect> placedRects) {
    const double angleStep = 0.2;
    double step = 10.0;
    double angle = 0.0;
    double distance = step;
    int turns = 0;

    while (true) {
      final point =
          Offset(distance * cos(angle), distance * sin(angle)) +
          placedRects.first.center;

      final candidateRect = Rect.fromCenter(
        center: point,
        width: childSize.width,
        height: childSize.height,
      );

      bool intersects = false;
      for (final rect in placedRects) {
        if (candidateRect.overlaps(rect.inflate(spacing))) {
          intersects = true;
          break;
        }
      }

      if (!intersects) {
        return candidateRect;
      }

      angle += angleStep;
      if (angle > 2 * pi) {
        angle = 0;
        turns++;
        distance += step * (turns / 2);
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
