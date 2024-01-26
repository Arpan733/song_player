import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_player/controller/player_controller.dart';
import 'package:media_player/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade800,
        title: const Text(
          'Player',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              return Container(
                padding: const EdgeInsets.all(5),
                color: Colors.indigo.shade800,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 90,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Obx(
                        () => ListTile(
                          title: Text(
                            snapshot.data![index].title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data![index].artist.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.ARTIST,
                            nullArtworkWidget: const Icon(
                              Icons.music_note_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          trailing: controller.playIndex.value == index &&
                                  controller.isPlaying.value
                              ? const Icon(
                                  Icons.play_arrow_outlined,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : null,
                          onTap: () {
                            if (index != controller.playIndex.value) {
                              controller.playSong(
                                snapshot.data![index].uri.toString(),
                                index,
                                snapshot.data![index].id.toString(),
                                snapshot.data![index].title.toString(),
                                snapshot.data!,
                              );
                            }
                            Get.to(() => Player(
                                  data: snapshot.data!,
                                ));
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: const Text(
                  'No songs found.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
          } else {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
        },
      ),
    );
  }
}
