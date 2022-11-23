import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Video App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _controller;
  bool startedPlaying = false;
  Duration currentMomentVideo = Duration.zero;
  bool isClick = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
    _controller.play();
  }

  Duration findCurrentMomentVideo() {
    setState(() {
      currentMomentVideo = _controller.value.position;
    });
    return currentMomentVideo;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                GestureDetector(
                  child: VideoPlayer(_controller),
                  onTap: () {
                    setState(() {
                      isClick = !isClick;
                    });
                  },
                ),
                !isClick
                    ? const SizedBox.shrink()
                    : Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          _controller.seekTo(
                              _controller.value.position -
                                  const Duration(seconds: 5));
                        },
                        icon: const Icon(Icons.replay_5),
                        iconSize: 50.0,
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: () {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        },
                        icon: const Icon(Icons.play_arrow),
                        iconSize: 50.0,
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: () {
                          _controller.seekTo(
                              _controller.value.position +
                                  const Duration(seconds: 5));
                        },
                        icon: const Icon(Icons.forward_5),
                        iconSize: 50.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 90,
            child: Stack(
              children: [
                Container(
                  height: 90,
                  color: Colors.black,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Slider(
                    value: findCurrentMomentVideo().inMilliseconds.toDouble(),
                    max: _controller.value.duration.inMilliseconds.toDouble(),
                    onChanged: (double value) {
                      _controller.seekTo(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15.0,
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ((_controller.value.position.inMilliseconds / 1000).toStringAsFixed(2).replaceFirst('.', ':').padLeft(5, '0')),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          // '${_controller.value.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}:${(_controller.value.duration.inMilliseconds.remainder(1000).toString().padLeft(2, '0'))}',
                          ((_controller.value.duration.inMilliseconds / 1000).toStringAsFixed(2).replaceFirst('.', ':').padLeft(5, '0')),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}