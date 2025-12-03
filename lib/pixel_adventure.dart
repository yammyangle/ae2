import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'components/level.dart';
import 'components/player.dart';

class PixelAdventure extends FlameGame with HasCollisionDetection {
  final VoidCallback? onLevelComplete;
  
  PixelAdventure({this.onLevelComplete}) {
    print('🎮 GAME: PixelAdventure created with callback: ${onLevelComplete != null ? "YES" : "NO"}');
  }
  
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  
  late final CameraComponent cam;
  late Level gameWorld;
  
  bool playSounds = false;
  double soundVolume = 1.0;
  
  // ⭐ ADD FRUIT TRACKING
  int totalFruits = 0;
  int collectedFruits = 0;

  @override
  FutureOr<void> onLoad() async {
    print('=== PixelAdventure: Starting onLoad ===');
    
    try {
      print('Loading all images...');
      await images.loadAllImages();
      print('Images loaded successfully');
      
      print('Creating player...');
      Player player = Player(character: 'Mask Dude');
      print('Player created');
      
      print('Creating level...');
      gameWorld = Level(levelName: 'Level-01', player: player);
      print('Level created');
      
      print('Creating camera...');
      cam = CameraComponent.withFixedResolution(
        world: gameWorld,
        width: 640,
        height: 360,
      );
      cam.viewfinder.anchor = Anchor.topLeft;
      print('Camera created');

      print('Adding camera...');
      add(cam);
      print('Camera added');
      
      print('Adding world...');
      add(gameWorld);
      print('World added');
      
      print('=== PixelAdventure: onLoad complete ===');
    } catch (e, stackTrace) {
      print('ERROR in PixelAdventure.onLoad: $e');
      print('Stack trace: $stackTrace');
    }

    return super.onLoad();
  }
  
  // ⭐ ADD METHOD TO REGISTER FRUIT
  void registerFruit() {
    totalFruits++;
    print('🍊 GAME: Fruit registered. Total fruits: $totalFruits');
  }
  
  // ⭐ ADD METHOD TO COLLECT FRUIT
  void collectFruit() {
    collectedFruits++;
    print('🍊 GAME: Fruit collected! $collectedFruits / $totalFruits');
  }
  
  // ⭐ ADD METHOD TO CHECK IF ALL FRUITS COLLECTED
  bool areAllFruitsCollected() {
    final allCollected = collectedFruits >= totalFruits;
    print('🍊 GAME: All fruits collected? $allCollected ($collectedFruits / $totalFruits)');
    return allCollected;
  }
  
  void onCheckpointReached() {
    print('🎯 GAME: onCheckpointReached called!');
    print('🎯 GAME: onLevelComplete callback is: ${onLevelComplete != null ? "PRESENT" : "NULL"}');
    
    if (onLevelComplete == null) {
      print('❌ GAME: ERROR - onLevelComplete is NULL! Cannot return to story!');
      return;
    }
    
    Future.delayed(const Duration(milliseconds: 500), () {
      print('⏰ GAME: Delay completed, calling onLevelComplete callback...');
      try {
        onLevelComplete!();
        print('✅ GAME: onLevelComplete callback executed successfully!');
      } catch (e, stackTrace) {
        print('❌ GAME: ERROR calling onLevelComplete: $e');
        print('Stack trace: $stackTrace');
      }
    });
  }
  
  void loadNextLevel() {
    removeWhere((component) => component is Level);
    Player player = Player(character: 'Mask Dude');
    gameWorld = Level(levelName: 'Level-01', player: player);
    cam.world = gameWorld;
    add(gameWorld);
  }
}

class PixelAdventureScreen extends StatefulWidget {
  final VoidCallback? onLevelComplete;
  
  const PixelAdventureScreen({
    super.key,
    this.onLevelComplete,
  });

  @override
  State<PixelAdventureScreen> createState() => _PixelAdventureScreenState();
}

class _PixelAdventureScreenState extends State<PixelAdventureScreen> {
  late PixelAdventure game;

  @override
  void initState() {
    super.initState();
    print('=== Initializing PixelAdventureScreen ===');
    print('📞 SCREEN: widget.onLevelComplete is: ${widget.onLevelComplete != null ? "PRESENT" : "NULL"}');
    
    game = PixelAdventure(
      onLevelComplete: widget.onLevelComplete,
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (kDebugMode) {
      print('=== Hot reload detected, recreating game ===');
      setState(() {
        game = PixelAdventure(
          onLevelComplete: widget.onLevelComplete,
        );
      });
    }
  }

  @override
  void dispose() {
    print('=== Disposing PixelAdventureScreen ===');
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