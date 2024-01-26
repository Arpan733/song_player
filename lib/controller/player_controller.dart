import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  var playIndex = 10000.obs;
  var isPlaying = false.obs;

  var position = ''.obs;
  var duration = ''.obs;

  var max = 0.0.obs;
  var value = 0.0.obs;

  @override
  void onInit() {
    checkPermissions();
    super.onInit();
  }

  @override
  onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  updatePosition() {
    audioPlayer.durationStream.listen((event) {
      duration.value = event.toString().split(".")[0];
      max.value = event!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((event) {
      position.value = event.toString().split(".")[0];
      value.value = event.inSeconds.toDouble();
    });
  }

  changeDurationToSecond(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  playSong(
      String? url, int index, String id, String title, List<SongModel> data) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(
        Uri.parse(url!),
        tag: MediaItem(
          id: id,
          title: title,
        ),
      ));
      audioPlayer.play();
      updatePosition();
      isPlaying(true);

      audioPlayer.playbackEventStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          playNextSong(data, event);
        }
      });
    } on Exception catch (e) {
      isPlaying(false);
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  playNextSong(List<SongModel> data, PlaybackEvent event) async {
    if (event.processingState == ProcessingState.completed) {
      await Future.delayed(
        const Duration(seconds: 1),
        () {
          playIndex.value = playIndex.value + 1;
          if (playIndex.value == data.length) {
            playSong(
              data[0].uri,
              0,
              data[0].id.toString(),
              data[0].title,
              data,
            );
          } else {
            playSong(
              data[playIndex.value + 1].uri,
              playIndex.value + 1,
              data[playIndex.value + 1].id.toString(),
              data[playIndex.value + 1].title,
              data,
            );
          }
        },
      );
    }

    updatePosition();
  }

  checkPermissions() async {
    var per = await Permission.storage.request();

    if (per.isDenied) {
      checkPermissions();
    }
  }
}
