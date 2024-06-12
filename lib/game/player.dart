import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:hackathon_2024/game/car.dart';
import 'package:hackathon_2024/game/crosswalk.dart';
import 'package:hackathon_2024/game/target.dart';
import 'package:hackathon_2024/game/wall.dart';

class Player extends SpriteComponent with HasGameRef, CollisionCallbacks {
  bool isMoving = false;
  late ShapeHitbox hitbox;
  Vector2 previousPosition = Vector2.zero();

  void startMove() {
    isMoving = true;
  }

  void stopMove() {
    isMoving = false;
  }

  void move(Vector2 movement) {
    if (isMoving) {
      previousPosition.setFrom(position);
      position.add(movement);
    }
  }

  @override
  void onLoad() {
    super.onLoad();
    hitbox = RectangleHitbox()
      ..width = width * 0.8
      ..height = height * 0.8;
    add(hitbox);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Wall) {
      HapticFeedback.heavyImpact();
      isMoving = false;
      position.setFrom(previousPosition); // Revert to previous position
    } else if (other is Car) {
      HapticFeedback.vibrate();
      isMoving = false;
      position.setFrom(Vector2(170, 250)); // Revert to start of crosswalk
    } else if (other is Target) {
      // Winning State - Maybe exciting vibration or sound?
      position.setZero();
    } else if (other is Crosswalk) {
      Future.microtask(() async {
        for (int i = 0; i < 3; i++) {
          HapticFeedback.mediumImpact();
          await Future.delayed(const Duration(milliseconds: 200));
        }
      });
    }
  }
}