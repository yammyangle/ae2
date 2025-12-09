import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:audioplayers/audioplayers.dart';
import 'components/level.dart';
import 'components/player.dart';

class PixelAdventure extends FlameGame with HasCollisionDetection {
  final VoidCallback? onLevelComplete;
  
  PixelAdventure({this.onLevelComplete});
  
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  
  late final CameraComponent cam;
  late Level gameWorld;
  
  bool playSounds = true;
  double soundVolume = 1.0;
  
  final AudioPlayer gameMusicPlayer = AudioPlayer();
  final AudioPlayer alertSoundPlayer = AudioPlayer();
  
  int totalFruits = 0;
  int collectedFruits = 0;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    
    if (playSounds) {
      await gameMusicPlayer.play(AssetSource('audio/game_music.mp3'));
      gameMusicPlayer.setReleaseMode(ReleaseMode.loop);
    }
    
    Player player = Player(character: 'Mask Dude');
    gameWorld = Level(levelName: 'Level-01', player: player);
    
    cam = CameraComponent.withFixedResolution(
      world: gameWorld,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    add(cam);
    add(gameWorld);

    return super.onLoad();
  }
  
  @override
  void onRemove() {
    gameMusicPlayer.stop();
    gameMusicPlayer.dispose();
    alertSoundPlayer.dispose();
    super.onRemove();
  }
  
  Future<void> playAlertSound() async {
    if (playSounds) {
      await alertSoundPlayer.play(AssetSource('audio/alert.mp3'));
    }
  }
  
  void registerFruit() {
    totalFruits++;
  }
  
  void collectFruit() {
    collectedFruits++;
  }
  
  bool areAllFruitsCollected() {
    return collectedFruits >= totalFruits;
  }
  
  void onCheckpointReached() {
    if (onLevelComplete != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        onLevelComplete!();
      });
    }
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
      setState(() {
        game = PixelAdventure(
          onLevelComplete: widget.onLevelComplete,
        );
      });
    }
  }

  @override
  void dispose() {
    game.gameMusicPlayer.stop();
    
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