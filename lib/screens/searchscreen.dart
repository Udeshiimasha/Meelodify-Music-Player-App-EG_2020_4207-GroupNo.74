import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:melodify/controllers/player_contoller.dart';
import 'package:melodify/screens/home.dart';
import 'package:melodify/screens/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController title = TextEditingController();
  final PlayerController playerController = Get.find();
  String search = '';

  // void _runFilter(String enteredKeyword) {
  //   List<Map<String, dynamic>> results = [];
  //   if (enteredKeyword.isEmpty) {
  //     //results = AudioQuery.querySongs.snapshot.data;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              decorationColor: Color.fromARGB(19, 39, 1, 46),
              fontSize: 24),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.queue_music_sharp,
        //       color: Colors.black,
        //     ),
        //     onPressed: () {},
        //   ),
        // ],
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
        elevation: 20,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              cursorColor: Colors.pink,
              keyboardType: TextInputType.text,
              controller: title,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 207, 4, 163),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color.fromARGB(255, 207, 4, 163),
                  ),
                  onPressed: () {
                    title.text = '';
                  },
                ),
                filled: true,
                fillColor: const Color.fromARGB(223, 225, 113, 164),
                hintText: 'Search for songs....',
                //border: const OutlineInputBorder(
                //borderRadius: BorderRadius.circular(20),
                //borderSide: const BorderSide(color: Colors.black)),
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(19, 0, 0, 0),
                    fontSize: 20),
              ),
              // onChanged: (String? value) {
              //   print(value);

              //   // setState(() {
              //   //   search = value.toString();
              //   // });
              // },
            ),
            Expanded(
              child: FutureBuilder<List<SongModel>>(
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
                                        tileColor: const Color.fromARGB(
                                            19, 50, 30, 47),
                                        title: Text(
                                          snapshot
                                              .data![index].displayNameWOExt,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${snapshot.data![index].artist}",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        leading: QueryArtworkWidget(
                                          id: snapshot.data![index].id,
                                          type: ArtworkType.AUDIO,
                                          nullArtworkWidget: const FaIcon(
                                              FontAwesomeIcons.music),
                                        ),
                                        trailing: controller.playIndex.value ==
                                                    index &&
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
            ),
          ],
        ),
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
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const Favourites()),
                  // );
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
