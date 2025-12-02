import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame/parallax.dart';
import 'package:flame/collisions.dart';

class PixelAdventure extends FlameGame with HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  
  late final CameraComponent cam;
  late Level gameWorld;
  
  bool playSounds = false;
  double soundVolume = 1.0;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    
    gameWorld = Level();
    
    cam = CameraComponent.withFixedResolution(
      world: gameWorld,
      width: 640,
      height: 360,
    );

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, gameWorld]);

    return super.onLoad();
  }
  
  void loadNextLevel() {
    removeWhere((component) => component is Level);
    gameWorld = Level();
    cam.world = gameWorld;
    add(gameWorld);
  }
}

class Level extends World with HasGameReference<PixelAdventure> {
  late TiledComponent level;
  Player? player;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('Level-01.tmx', Vector2.all(16));
    add(level);
    
    _scrollingBackground();
    _spawningObjects();
    _addCollisions();
    
    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('Background');

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue('BackgroundColor');
      final backgroundTile = BackgroundTile(
        color: backgroundColor ?? 'Gray',
        position: Vector2(0, 0),
        pixelGame: game,
      );
      add(backgroundTile);
    }
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoint');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player = Player(
              character: 'Mask Dude',
              position: Vector2(spawnPoint.x, spawnPoint.y),
            );
            add(player!);
            break;
          case 'Fruit':
            final fruit = Fruit(
              fruit: spawnPoint.name.isNotEmpty ? spawnPoint.name : 'Orange',
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
            break;
          default:
        }
      }
      
      if (player == null) {
        player = Player(
          character: 'Mask Dude',
          position: Vector2(100, 100),
        );
        add(player!);
      }
    } else {
      player = Player(
        character: 'Mask Dude',
        position: Vector2(100, 100),
      );
      add(player!);
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
      
      if (player != null) {
        player!.collisionBlocks = collisionBlocks;
      }
    }
  }
}

// KEEP ONLY ONE BackgroundTile - this one
class BackgroundTile extends ParallaxComponent {
  final String color;
  final PixelAdventure pixelGame;
  
  BackgroundTile({
    this.color = 'Gray',
    Vector2? position,
    required this.pixelGame,
  }) : super(position: position);

  final double scrollSpeed = 40;

  @override
  FutureOr<void> onLoad() async {
    priority = -10;
    size = Vector2.all(64);
    
    parallax = await pixelGame.loadParallax(
      [ParallaxImageData('Background/$color.png')],
      baseVelocity: Vector2(0, -scrollSpeed),
      repeat: ImageRepeat.repeat,
      fill: LayerFill.none,
    );
    
    return super.onLoad();
  }
}

// KEEP ONLY ONE Fruit - this one
class Fruit extends SpriteAnimationComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  final String fruit;
  
  Fruit({
    this.fruit = 'Orange',
    Vector2? position,
    Vector2? size,
  }) : super(position: position, size: size);

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    
    return super.onLoad();
  }

  void collidedWithPlayer() async {
    if (!collected) {
      collected = true;
      
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );
      
      await animationTicker?.completed;
      removeFromParent();
    }
  }
}

// KEEP ONLY ONE CollisionBlock - this one
class CollisionBlock extends PositionComponent {
  bool isPlatform;
  
  CollisionBlock({
    required Vector2 position,
    required Vector2 size,
    this.isPlatform = false,
  }) : super(position: position, size: size);
}

// KEEP ONLY ONE CustomHitbox - this one
class CustomHitbox {
  final double offsetX;
  final double offsetY;
  final double width;
  final double height;

  CustomHitbox({
    required this.offsetX,
    required this.offsetY,
    required this.width,
    required this.height,
  });
}

// KEEP ONLY ONE checkCollision - this one
bool checkCollision(Player player, CollisionBlock block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;
  
  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;
  
  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;
  
  return (fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}

// KEEP ONLY ONE PlayerState - this one
enum PlayerState {
  idle,
  running,
  jumping,
  falling,
}

// KEEP ONLY ONE Player class
class Player extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  String character;
  
  Player({
    Vector2? position,
    this.character = 'Mask Dude',
  }) : super(position: position);

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;

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

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedCheckpoint) {
      if (other is Fruit) other.collidedWithPlayer();
    }
    super.onCollisionStart(intersectionPoints, other);
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

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
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
}

class PixelAdventureScreen extends StatefulWidget {
  const PixelAdventureScreen({super.key});

  @override
  State<PixelAdventureScreen> createState() => _PixelAdventureScreenState();
}

class _PixelAdventureScreenState extends State<PixelAdventureScreen> {
  late PixelAdventure game;

  @override
  void initState() {
    super.initState();
    game = PixelAdventure();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (kDebugMode) {
      setState(() {
        game = PixelAdventure();
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        key: ValueKey(game),
        game: game,
      ),
    );
  }
}