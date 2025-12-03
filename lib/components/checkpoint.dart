import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../pixel_adventure.dart';
import 'player.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  
  bool _activated = false;
  Player? _collidingPlayer;
  
  Checkpoint({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      position: Vector2(18, 56),
      size: Vector2(12, 8),
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(64),
      ),
    );
    
    print('🚩 CHECKPOINT: Checkpoint loaded at $position');
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !_activated) {
      print('🚩 CHECKPOINT: Player touched checkpoint!');
      _collidingPlayer = other;
      _reachedCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachedCheckpoint() async {
    if (_activated) {
      print('⚠️ CHECKPOINT: Already activated, ignoring');
      return;
    }
    
    // Play flag animation
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 26,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );

    await animationTicker?.completed;

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
      ),
    );
    
    print('🎉 CHECKPOINT: Flag animation complete!');
    
    // ⭐ NOW trigger the player's checkpoint sequence
    if (_collidingPlayer != null) {
      print('📞 CHECKPOINT: Calling player.triggerCheckpointSequence()...');
      _collidingPlayer!.triggerCheckpointSequence();
    } else {
      print('❌ CHECKPOINT: No player reference found!');
    }
  }
  
  // Show visual feedback when checkpoint is locked
  void _showLockedAnimation() async {
    print('🔒 CHECKPOINT: Showing locked feedback...');
    
    // Flash the checkpoint to show it's locked
    final originalOpacity = opacity;
    
    for (int i = 0; i < 3; i++) {
      opacity = 0.3;
      await Future.delayed(const Duration(milliseconds: 100));
      opacity = originalOpacity;
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    print('🔒 CHECKPOINT: Locked animation complete');
  }
}