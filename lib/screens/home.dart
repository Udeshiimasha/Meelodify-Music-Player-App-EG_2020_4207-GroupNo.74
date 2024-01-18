import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:melodify/controllers/player_contoller.dart';
import 'package:melodify/screens/authentication/global/toast.dart';
import 'package:melodify/screens/authentication/login.dart';
import 'package:melodify/screens/favourites.dart';
import 'package:melodify/screens/player.dart';
import 'package:melodify/screens/searchscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Melodify",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () {
              showToast(message: "User is successfully Signed Out");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignIn()),
              );
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 248, 0, 194),
                Color.fromARGB(255, 255, 131, 187)
              ],
            ),
          ),
        ),
        elevation: 25.0,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<SongModel>>(
            future: controller.audioQuery.querySongs(
                ignoreCase: true,
                orderType: OrderType.ASC_OR_SMALLER,
                sortType: null,
                uriType: UriType.EXTERNAL),
            builder: (BuildContext contex, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No Song Found", style: TextStyle()),
                );
              } else {
                return Stack(fit: StackFit.expand, children: [
                  Image.asset(
                    "assets/images/body_pic.jpg",
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color.fromARGB(255, 255, 131, 187)
                              .withOpacity(0.8),
                          const Color.fromARGB(255, 234, 187, 209)
                              .withOpacity(0.8)
                        ],
                      ),
                    ),
                    height: double.infinity,
                    width: double.infinity,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                child: Obx(
                                  () => ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    tileColor:
                                        const Color.fromARGB(19, 50, 30, 47),
                                    title: Text(
                                      snapshot.data![index].displayNameWOExt,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${snapshot.data![index].artist}",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    leading: QueryArtworkWidget(
                                      id: snapshot.data![index].id,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget:
                                          const FaIcon(FontAwesomeIcons.music),
                                    ),
                                    trailing:
                                        controller.playIndex.value == index &&
                                                controller.isPlaying.value
                                            ? const Icon(Icons.play_arrow,
                                                color: Colors.black, size: 28)
                                            : null,
                                    onTap: () {
                                      Get.to(
                                        () => Player(
                                          data: snapshot.data!,
                                        ),
                                        transition: Transition.downToUp,
                                      );
                                      controller.playSong(
                                          snapshot.data![index].uri, index);
                                    },
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ]);
              }
            },
          ),
          // Positioned(
          //       bottom: 0,
          //       left: 0,
          //       right: 0,
          //       child: MiniPlayer(),
          //     ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60.0,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 234, 187, 209),
              Color.fromARGB(255, 252, 250, 251)
            ],
          ),
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Colors.black,
                  //fill: ,
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const HomePage()),
                  // );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Favourites()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
