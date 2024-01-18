import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/controllers/player_contoller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatefulWidget {
  final List<SongModel> data;
  const Player({super.key, required this.data});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 2,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(fit: StackFit.expand, children: [
          Image.asset(
            "assets/images/player2.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 255, 131, 187).withOpacity(0.8),
                  const Color.fromARGB(255, 234, 187, 209).withOpacity(0.8)
                ],
              ),
            ),
            height: double.infinity,
            width: double.infinity,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Obx(
                      () => Expanded(
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          height: 300,
                          width: 300,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: QueryArtworkWidget(
                            id: widget.data[controller.playIndex.value].id,
                            type: ArtworkType.AUDIO,
                            artworkHeight: double.infinity,
                            artworkWidth: double.infinity,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              size: 48,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(19, 63, 25, 50),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Obx(
                        () => Column(
                          children: [
                            Text(
                              widget.data[controller.playIndex.value]
                                  .displayNameWOExt,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              widget.data[controller.playIndex.value].artist
                                  .toString(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Obx(
                              () => Row(
                                children: [
                                  Text(
                                    controller.position.value,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Expanded(
                                    child: Slider(
                                      thumbColor: Colors.pink,
                                      inactiveColor: Colors.white,
                                      min: const Duration(seconds: 0)
                                          .inSeconds
                                          .toDouble(),
                                      max: controller.max.value,
                                      value: controller.value.value,
                                      onChanged: (newValue) {
                                        controller.changeDurationToSeconds(
                                            newValue.toInt());
                                        newValue = newValue;
                                      },
                                    ),
                                  ),
                                  Text(
                                    controller.duration.value,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.playSong(
                                        widget
                                            .data[
                                                controller.playIndex.value - 1]
                                            .uri,
                                        controller.playIndex.value - 1);
                                  },
                                  icon: const Icon(Icons.skip_previous_rounded),
                                  iconSize: 40,
                                  color: Colors.black,
                                ),
                                Obx(
                                  () => CircleAvatar(
                                    radius: 35,
                                    foregroundColor: const Color.fromARGB(
                                        223, 241, 167, 203),
                                    backgroundColor: Colors.black,
                                    child: Transform.scale(
                                      scale: 1.35,
                                      child: IconButton(
                                        onPressed: () {
                                          if (controller.isPlaying.value) {
                                            controller.audioPlayer.pause();
                                            controller.isPlaying(false);
                                          } else {
                                            controller.audioPlayer.play();
                                            controller.isPlaying(true);
                                          }
                                        },
                                        icon: controller.isPlaying.value
                                            ? const Icon(Icons.pause)
                                            : const Icon(
                                                Icons.play_arrow_rounded,
                                              ),
                                        iconSize: 50,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.playSong(
                                        widget
                                            .data[
                                                controller.playIndex.value + 1]
                                            .uri,
                                        controller.playIndex.value + 1);
                                  },
                                  icon: const Icon(Icons.skip_next_rounded),
                                  iconSize: 40,
                                  color: Colors.black,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
        ])
        // Stack(
        //   fit: StackFit.expand,
        //   children: [
        //     Image.asset(
        //       "assets/images/player2.jpg",
        //       fit: BoxFit.cover,
        //     ),
        //     ShaderMask(
        //       shaderCallback: (rect) {
        //         return LinearGradient(
        //             begin: Alignment.topCenter,
        //             end: Alignment.bottomCenter,
        //             colors: [
        //               Colors.white,
        //               Colors.white.withOpacity(0.5),
        //               Colors.white.withOpacity(0.0),
        //             ],
        //             stops: const [
        //               0.0,
        //               0.4,
        //               0.6
        //             ]).createShader(rect);
        //       },
        //       blendMode: BlendMode.dstOut,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //             gradient: LinearGradient(
        //                 begin: Alignment.topCenter,
        //                 end: Alignment.bottomCenter,
        //                 colors: [
        //               Color.fromARGB(255, 247, 146, 191),
        //               Color.fromARGB(255, 255, 0, 119)
        //             ])),
        //       ),
        //     )
        //   ],
        // ),
        );
  }
}
