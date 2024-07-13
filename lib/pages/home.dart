import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  @override
  void initState() {
    initPlaylist();
    super.initState();
  }

  void initPlaylist() async {
    await assetsAudioPlayer.open(
        autoStart: false,
        Playlist(audios: [
          Audio(metas: Metas(title: 'Song 1'), 'assets/1.mp3'),
          Audio(metas: Metas(title: 'Song 2'), 'assets/2.mp3'),
          Audio(metas: Metas(title: 'Song 3'), 'assets/3.mp3'),
          Audio(metas: Metas(title: 'Song 4'), 'assets/4.mp3'),
        ]));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                child: myStramBuilder()),
          ],
        ),
      ),
    );
  }

  Widget get getBtn {
    return assetsAudioPlayer.builderIsPlaying(builder: (context, isPlaying) {
      return FloatingActionButton.large(
        onPressed: () {
          if (isPlaying) {
            assetsAudioPlayer.pause();
          } else {
            assetsAudioPlayer.play();
          }
          setState(() {});
        },
        shape: const CircleBorder(),
        backgroundColor: Color.fromARGB(255, 235, 224, 236),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 40,
        ),
      );
    });
  }

  String convertSeconds(int seconds) {
    String mins = (seconds ~/ 60).toString();
    String secStr = (seconds % 60).toString();
    return '${mins.padLeft(2, '0')} ${secStr.padLeft(2, '0')}';
  }

  Widget myStramBuilder() {
    return StreamBuilder(
        stream: assetsAudioPlayer.realtimePlayingInfos,
        builder: (context, snapShots) {
          if (snapShots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  assetsAudioPlayer.getCurrentAudioTitle == ''
                      ? 'please choose song'
                      : assetsAudioPlayer.getCurrentAudioTitle,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 27,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: snapShots.data?.current?.index == 0
                            ? null
                            : () {
                                assetsAudioPlayer.previous();
                              },
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                        )),
                    getBtn,
                    IconButton(
                        onPressed: snapShots.data?.current?.index ==
                                (assetsAudioPlayer.playlist?.audios.length ??
                                        0) -
                                    1
                            ? null
                            : () {
                                assetsAudioPlayer.next();
                              },
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Slider(
                    activeColor: Colors.white,
                    inactiveColor: Colors.white,
                    value:
                        snapShots.data?.currentPosition.inSeconds.toDouble() ??
                            0.0,
                    min: 0,
                    max: snapShots.data?.duration.inSeconds.toDouble() ?? 0.0,
                    onChanged: (value) {}),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '${convertSeconds(snapShots.data?.currentPosition.inSeconds ?? 0)} /  ${convertSeconds(snapShots.data?.duration.inSeconds ?? 0)}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          );
        });
  }
}
