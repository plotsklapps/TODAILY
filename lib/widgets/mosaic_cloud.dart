import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MosaicCloud extends MultiChildRenderObjectWidget {
  const MosaicCloud({
    required super.children,
    super.key,
    this.spacing = 4.0,
  });
  final double spacing;

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
  RenderMosaicCloudBox({required double spacing}) : _spacing = spacing;
  double _spacing;

  double get spacing {
    return _spacing;
  }

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

    final List<Rect> calculatedRects = <Rect>[];
    RenderBox? child = firstChild;
    final List<RenderBox> children = <RenderBox>[];

    // Layout children with loose constraints to get their preferred sizes
    while (child != null) {
      final _MosaicCloudParentData childParentData =
          child.parentData! as _MosaicCloudParentData;
      children.add(child);

      child.layout(const BoxConstraints(), parentUsesSize: true);
      final Size childSize = child.size;

      Rect childRect;
      if (calculatedRects.isEmpty) {
        childRect = Offset.zero & childSize;
      } else {
        childRect = _findNextPosition(childSize, calculatedRects);
      }
      calculatedRects.add(childRect);
      child = childParentData.nextSibling;
    }

    final Rect boundingBox = calculatedRects.reduce(
      (Rect a, Rect b) {
        return a.expandToInclude(b);
      },
    );

    double scale = 1;
    if (boundingBox.width > constraints.maxWidth) {
      scale = constraints.maxWidth / boundingBox.width;
    }
    if (boundingBox.height * scale > constraints.maxHeight) {
      scale = constraints.maxHeight / boundingBox.height;
    }

    final Matrix4 transform = Matrix4.diagonal3Values(scale, scale, 1);

    final Offset offsetToOrigin = -boundingBox.topLeft;

    for (int i = 0; i < children.length; i++) {
      final _MosaicCloudParentData childParentData =
          children[i].parentData! as _MosaicCloudParentData;
      final Offset initialOffset = calculatedRects[i].topLeft + offsetToOrigin;
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
    const double step = 10;
    double angle = 0;
    double distance = step;
    int turns = 0;

    while (true) {
      final Offset point =
          Offset(distance * cos(angle), distance * sin(angle)) +
          placedRects.first.center;

      final Rect candidateRect = Rect.fromCenter(
        center: point,
        width: childSize.width,
        height: childSize.height,
      );

      bool intersects = false;
      for (final Rect rect in placedRects) {
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
