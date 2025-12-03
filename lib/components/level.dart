import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'background_tile.dart';
import 'collision_block.dart';
import 'fruit.dart';
import 'player.dart';
import 'saw.dart';
import '../pixel_adventure.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

@override
FutureOr<void> onLoad() async {
  print('=== Level: Starting onLoad ===');
  
  try {
    print('Level: Loading $levelName.tmx...');
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    print('Level: TMX loaded, size: ${level.size}');

    add(level);
    print('Level: TMX added to world');

    print('Level: Calling _scrollingBackground...');
    _scrollingBackground();
    
    print('Level: Calling _spawningObjects...');
    _spawningObjects();
    
    print('Level: Calling _addCollisions...');
    _addCollisions();
    
    print('=== Level: onLoad complete ===');
  } catch (e, stackTrace) {
    print('ERROR in Level.onLoad: $e');
    print('Stack trace: $stackTrace');
  }

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
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.scale.x = 1;
            add(player);
            break;
          case 'Fruit':
            final fruit = Fruit(
              fruit: spawnPoint.name.isNotEmpty ? spawnPoint.name : 'Orange',
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
            break;
          case 'Saw':
            final isVertical = spawnPoint.properties.getValue('isVertical') ?? false;
            final offNeg = (spawnPoint.properties.getValue('offNeg') ?? 0).toDouble();
            final offPos = (spawnPoint.properties.getValue('offPos') ?? 0).toDouble();
            final saw = Saw(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
            break;
          default:
        }
      }
    }
  }

void _addCollisions() {
  final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
  print('Collisions layer found: ${collisionsLayer != null}');

  if (collisionsLayer != null) {
    print('Total collision objects: ${collisionsLayer.objects.length}');
    
    for (final collision in collisionsLayer.objects) {
      print('Collision: class=${collision.class_}, pos=(${collision.x}, ${collision.y}), size=(${collision.width}, ${collision.height})');
      
      switch (collision.class_) {
        case 'Platform':
          final platform = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
            isPlatform: true,
          );
          collisionBlocks.add(platform);
          add(platform);
          print('✓ Platform added');
          break;
        default:
          final block = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          collisionBlocks.add(block);
          add(block);
          print('✓ Collision block added');
      }
    }
      player.collisionBlocks = collisionBlocks;
    } 
}
}