import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../pixel_adventure.dart';
import 'collision_block.dart';
import 'custom_hitbox.dart';
import 'utils.dart';
import 'fruit.dart';
import 'saw.dart';
import 'checkpoint.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  hit,
  appearing,
  disappearing
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  String character;
  
  Player({
    position,
    this.character = 'Mask Dude',
  }) : super(position: position);

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;

  final double _gravity = 9.8;
  final double _jumpForce = 260;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  bool gotHit = false;
  bool reachedCheckpoint = false;
  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  final Set<LogicalKeyboardKey> _keysPressed = {};

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    
    startingPosition = Vector2(position.x, position.y);

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    
    return super.onLoad();
  }

  @override
  void onRemove() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    super.onRemove();
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey;
    
    if (event is KeyDownEvent) {
      _keysPressed.add(key);
    } else if (event is KeyUpEvent) {
      _keysPressed.remove(key);
    }
    
    return false;
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit && !reachedCheckpoint) {
        _handleInput();
        _updatePlayerState();
        _updatePlayerMovement(fixedDeltaTime);
        _checkHorizontalCollisions();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }

      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  void _handleInput() {
    horizontalMovement = 0;
    
    final isLeftKeyPressed = _keysPressed.contains(LogicalKeyboardKey.keyA) ||
        _keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = _keysPressed.contains(LogicalKeyboardKey.keyD) ||
        _keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = _keysPressed.contains(LogicalKeyboardKey.space) ||
        _keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        _keysPressed.contains(LogicalKeyboardKey.keyW);
  }

//
// And here's the _reachedCheckpoint method with full debugging:
// In player.dart, update the _reachedCheckpoint method:

// In your player.dart, update the _reachedCheckpoint method:

void _reachedCheckpoint() async {
  print('🎯 PLAYER: _reachedCheckpoint() START');
  
  if (reachedCheckpoint) {
    print('⚠️ PLAYER: Already reached checkpoint, returning early');
    return;
  }
  
  
  // Adjust position for animation
  if (scale.x > 0) {
    position = position - Vector2.all(32);
  } else if (scale.x < 0) {
    position = position + Vector2(32, -32);
  }
  print('📍 PLAYER: Position adjusted');

  current = PlayerState.disappearing;
  print('🎬 PLAYER: Set animation to disappearing');

  // Short delay then move off screen
  await Future.delayed(const Duration(milliseconds: 300));
  
  // Move player off-screen to prevent further collisions
  position = Vector2.all(-10000);
  velocity = Vector2.zero();
  print('🚀 PLAYER: Moved off screen to prevent collisions');

  // Call the game's checkpoint handler
  print('📞 PLAYER: Calling game.onCheckpointReached()...');
  game.onCheckpointReached();
  print('✅ PLAYER: game.onCheckpointReached() called successfully');
  print('🎯 PLAYER: _reachedCheckpoint() END');
}

// Also update the onCollisionStart to be extra safe:
@override
void onCollisionStart(
    Set<Vector2> intersectionPoints, PositionComponent other) {
  print('💥 COLLISION: Player collided with ${other.runtimeType}');
  
  // If checkpoint reached, ignore ALL collisions
  if (reachedCheckpoint) {
    print('⚠️ COLLISION: Checkpoint reached, ignoring all collisions');
    return;
  }
  
  if (other is Fruit) {
    print('🍊 COLLISION: Hit fruit');
    other.collidedWithPlayer();
  }
  if (other is Saw) {
    print('🪚 COLLISION: Hit saw - respawning');
    _respawn();
  }
  // ⭐ REMOVED: Don't call _reachedCheckpoint here
  // The checkpoint will handle it and call player.triggerCheckpointSequence()
  if (other is Checkpoint) {
    print('🚩 COLLISION: Hit checkpoint - letting checkpoint handle logic');
    // Don't do anything here - let checkpoint decide
  }
  
  super.onCollisionStart(intersectionPoints, other);
}

void triggerCheckpointSequence() async {
  print('🎯 PLAYER: triggerCheckpointSequence() START (called by checkpoint)');
  
  if (reachedCheckpoint) {
    print('⚠️ PLAYER: Already reached checkpoint, returning early');
    return;
  }
  
  reachedCheckpoint = true;
  print('✅ PLAYER: Set reachedCheckpoint = true');
  
  // Adjust position for animation
  if (scale.x > 0) {
    position = position - Vector2.all(32);
  } else if (scale.x < 0) {
    position = position + Vector2(32, -32);
  }
  print('📍 PLAYER: Position adjusted');

  current = PlayerState.disappearing;
  print('🎬 PLAYER: Set animation to disappearing');

  // Short delay then move off screen
  await Future.delayed(const Duration(milliseconds: 300));
  
  // Move player off-screen to prevent further collisions
  position = Vector2.all(-10000);
  velocity = Vector2.zero();
  print('🚀 PLAYER: Moved off screen to prevent collisions');

  // Call the game's checkpoint handler
  print('📞 PLAYER: Calling game.onCheckpointReached()...');
  game.onCheckpointReached();
  print('✅ PLAYER: game.onCheckpointReached() called successfully');
  print('🎯 PLAYER: triggerCheckpointSequence() END');
}

// Also update _respawn to prevent respawning if checkpoint reached:
  void _respawn() async {
    if (reachedCheckpoint) {
      print('⚠️ RESPAWN: Checkpoint reached, ignoring respawn');
      return;
    }
    
    const canMoveDuration = Duration(milliseconds: 400);
    gotHit = true;
    current = PlayerState.hit;

    await animationTicker?.completed;
    animationTicker?.reset();

    scale.x = 1;
    position = startingPosition - Vector2.all(32);
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    velocity = Vector2.zero();
    position = startingPosition;
    _updatePlayerState();
    Future.delayed(canMoveDuration, () => gotHit = false);
  }

  void collidedwithEnemy() {
    _respawn();
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;

    // Use Hit animation for appearing/disappearing (special animations not needed)
    appearingAnimation = hitAnimation;
    disappearingAnimation = hitAnimation;

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.disappearing: disappearingAnimation,
    };

    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;
    if (velocity.y > 0) playerState = PlayerState.falling;
    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  // In your player.dart, update the _reachedCheckpoint metho
}