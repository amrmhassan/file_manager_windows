// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:windows_app/helpers/mouse_data/mouse_controller.dart';

List<Position> positions = [
  Position(0, 0),
  Position(0, 100),
  Position(100, 100),
  Position(1000, 500),
];

Future<void> handleMoveMouseTest(Duration d) async {
  await moveMouse(0, 0, d);
}

Future<void> moveMouse(
  int x,
  int y, [
  Duration duration = Duration.zero,
]) async {
  MouseController mouseController = MouseController();

  Position targetPoint = Position(x, y);
  Position currentMousePosition = mouseController.mousePosition;
  double distance = getDistance(currentMousePosition, targetPoint);

  // Calculate the number of steps based on the duration and the distance.
  int numSteps = (distance / 100).ceil();
  int stepDelay = duration.inMilliseconds ~/ numSteps;

  // Calculate the distance to move on each step.
  double dx = (x - currentMousePosition.x) / numSteps;
  double dy = (y - currentMousePosition.y) / numSteps;

  // Move the cursor in small steps.
  for (int i = 0; i < numSteps; i++) {
    int nextX = (currentMousePosition.x + dx * i).round();
    int nextY = (currentMousePosition.y + dy * i).round();
    mouseController.setCursorPosition(nextX, nextY);
    await Future.delayed(Duration(milliseconds: stepDelay));
  }
}

double getDistance(Position p1, Position p2) {
  double d = sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2));
  return d;
}
