import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_player/controller/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

class Player extends StatefulWidget {
  final List<SongModel> data;

  const Player({Key? key, required this.data}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade800,
                  shape: BoxShape.circle,
                ),
                child: Obx(
                  () => QueryArtworkWidget(
                    id: widget.data[controller.playIndex.value].id,
                    type: ArtworkType.ARTIST,
                    artworkHeight: double.infinity,
                    artworkWidth: double.infinity,
                    nullArtworkWidget: const Icon(
                      Icons.music_note_outlined,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.indigo.shade800,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Obx(
                () => Column(
                  children: [
                    TextScroll(
                      widget.data[controller.playIndex.value].title,
                      mode: TextScrollMode.endless,
                      velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                      delayBefore: const Duration(milliseconds: 1000),
                      pauseBetween: const Duration(milliseconds: 500),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.data[controller.playIndex.value].artist.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            controller.position.value,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              min: Duration.zero.inSeconds.toDouble(),
                              max: controller.max.value,
                              value: controller.value.value,
                              thumbColor: Colors.indigo,
                              onChanged: (newValue) {
                                controller
                                    .changeDurationToSecond(newValue.toInt());
                                newValue = newValue;
                              },
                            ),
                          ),
                          Text(
                            controller.duration.value,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (controller.playIndex.value == 0) {
                              controller.playSong(
                                widget.data[widget.data.length - 1].uri,
                                widget.data.length - 1,
                                widget.data[controller.playIndex.value - 1].id
                                    .toString(),
                                widget
                                    .data[controller.playIndex.value - 1].title,
                                widget.data,
                              );
                            } else {
                              controller.playSong(
                                widget.data[controller.playIndex.value - 1].uri,
                                controller.playIndex.value - 1,
                                widget.data[controller.playIndex.value - 1].id
                                    .toString(),
                                widget
                                    .data[controller.playIndex.value - 1].title,
                                widget.data,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Obx(
                          () => IconButton(
                            onPressed: () {
                              if (controller.isPlaying.value) {
                                controller.audioPlayer.stop();
                                controller.isPlaying(false);
                              } else {
                                controller.audioPlayer.play();
                                controller.isPlaying(true);
                              }
                            },
                            icon: Icon(
                              controller.isPlaying.value
                                  ? Icons.pause_circle_filled_outlined
                                  : Icons.play_circle_filled_outlined,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (controller.playIndex.value + 1 ==
                                widget.data.length) {
                              controller.playSong(
                                widget.data[0].uri,
                                0,
                                widget.data[0].id.toString(),
                                widget.data[0].title,
                                widget.data,
                              );
                            } else {
                              controller.playSong(
                                widget.data[controller.playIndex.value + 1].uri,
                                controller.playIndex.value + 1,
                                widget.data[controller.playIndex.value + 1].id
                                    .toString(),
                                widget
                                    .data[controller.playIndex.value + 1].title,
                                widget.data,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
