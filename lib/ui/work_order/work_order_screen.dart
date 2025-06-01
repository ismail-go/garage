import 'dart:math';

import 'package:flutter/material.dart';
import 'package:garage/core/base/base_state.dart';
import 'package:garage/gen/assets.gen.dart';
import 'package:garage/ui/work_order/work_order_view_model.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkOrderScreen extends StatefulWidget {
  final WorkOrderViewModel viewModel;

  const WorkOrderScreen({super.key, required this.viewModel});

  @override
  State<WorkOrderScreen> createState() => _WorkOrderScreenState(viewModel);
}

class _WorkOrderScreenState extends BaseState<WorkOrderViewModel, WorkOrderScreen> {
  _WorkOrderScreenState(super.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.repairmanIcon.svg(height: 24),
            SizedBox(width: 8),
            Text(viewModel.workOrder.repairmanName),
            SizedBox(width: 52),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.fromBorderSide(BorderSide(color: Colors.black12, width: 1)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(minRadius: 30, child: Icon(Icons.person, size: 36)),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(viewModel.workOrder.customerName, style: Theme.of(context).textTheme.titleLarge),
                      Text(viewModel.workOrder.vehicleId, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: Timeline.tileBuilder(
                theme: TimelineThemeData(
                  direction: Axis.horizontal,
                  connectorTheme: const ConnectorThemeData(
                    space: 30.0,
                    thickness: 5.0,
                  ),
                ),
                builder: TimelineTileBuilder.connected(
                  connectionDirection: ConnectionDirection.before,
                  itemExtentBuilder: (_, __) => MediaQuery.of(context).size.width / viewModel.processes.length,
                  oppositeContentsBuilder: (context, index) {
                    return buildStateIcon(index);
                  },
                  contentsBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        AppLocalizations.of(context)!.workOrderProcess(index, viewModel.processes[index]),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: viewModel.getColor(index),
                        ),
                      ),
                    );
                  },
                  indicatorBuilder: (_, index) {
                    Color color;
                    Widget? child;
                    if (index == viewModel.processIndex) {
                      color = viewModel.inProgressColor;
                      child = const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      );
                    } else if (index < viewModel.processIndex) {
                      color = viewModel.completeColor;
                      child = const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15.0,
                      );
                    } else {
                      color = viewModel.todoColor;
                    }

                    if (index <= viewModel.processIndex) {
                      return Stack(
                        children: [
                          CustomPaint(
                            size: const Size(30.0, 30.0),
                            painter: _BezierPainter(
                              color: color,
                              drawStart: index > 0,
                              drawEnd: index < viewModel.processIndex,
                            ),
                          ),
                          DotIndicator(
                            size: 30.0,
                            color: color,
                            child: child,
                          ),
                        ],
                      );
                    } else {
                      return Stack(
                        children: [
                          CustomPaint(
                            size: const Size(15.0, 15.0),
                            painter: _BezierPainter(
                              color: color,
                              drawEnd: index < viewModel.processes.length - 1,
                            ),
                          ),
                          OutlinedDotIndicator(
                            borderWidth: 4.0,
                            color: color,
                          ),
                        ],
                      );
                    }
                  },
                  connectorBuilder: (_, index, type) {
                    if (index > 0) {
                      if (index == viewModel.processIndex) {
                        final prevColor = viewModel.getColor(index - 1);
                        final color = viewModel.getColor(index);
                        List<Color> gradientColors;
                        if (type == ConnectorType.start) {
                          gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
                        } else {
                          gradientColors = [prevColor, Color.lerp(prevColor, color, 0.5)!];
                        }
                        return DecoratedLineConnector(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColors,
                            ),
                          ),
                        );
                      } else {
                        return SolidLineConnector(
                          color: viewModel.getColor(index),
                        );
                      }
                    } else {
                      return null;
                    }
                  },
                  itemCount: viewModel.processes.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding buildStateIcon(int index) {
    late Widget icon;
    switch (index) {
      case 0:
        icon = Assets.icons.truckIcon.svg(height: 20);
        break;
      case 1:
        icon = Assets.icons.repairmanIcon.svg(height: 20);
        break;
      case 2:
        icon = Assets.icons.truckIcon.svg(height: 20);
        break;
      case 3:
        icon = Assets.icons.truckIcon.svg(height: 20);
        break;
      case 4:
        icon = Assets.icons.truckIcon.svg(height: 20);
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: icon,
    );
  }
}

/// hardcoded bezier painter
/// TODO: Bezier curve into package component
class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    double angle;
    Offset offset1;
    Offset offset2;

    Path path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius, radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius, radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.drawStart != drawStart || oldDelegate.drawEnd != drawEnd;
  }
}
