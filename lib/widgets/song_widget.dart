import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SongWidget extends StatefulWidget {
  final Audio audio;

  const SongWidget({required this.audio, super.key});

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool isPlaying = false;
  @override
  void initState() {
    assetsAudioPlayer.open(widget.audio, autoStart: false);
    assetsAudioPlayer.isPlaying.listen((event) {
      setState(() {
        isPlaying = event;
      });
    });
    super.initState();
  }

  void togglePlayPause() {
    if (isPlaying) {
      assetsAudioPlayer.pause();
    } else {
      assetsAudioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(widget.audio.metas.title ?? 'No Name'),
        leading: IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.blue,
            size: 30,
          ),
          onPressed: togglePlayPause,
        ),
        trailing: StreamBuilder(
            stream: assetsAudioPlayer.realtimePlayingInfos,
            builder: (context, snapshots) {
              if (snapshots.data == null) {
                return const SizedBox.shrink();
              }
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Text(!isPlaying
                  ? convertSeconds(snapshots.data?.duration.inSeconds ?? 0)
                  : convertSeconds(
                      snapshots.data?.currentPosition.inSeconds ?? 0));
            }),
      ),
    );
  }

  String convertSeconds(int seconds) {
    String mins = (seconds ~/ 60).toString();
    String secStr = (seconds % 60).toString();
    return '${mins.padLeft(2, '0')} : ${secStr.padLeft(2, '0')}';
  }
}
