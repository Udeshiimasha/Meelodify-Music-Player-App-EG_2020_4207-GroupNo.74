import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:melodify/controllers/player_contoller.dart';
import 'package:melodify/screens/home.dart';
import 'package:melodify/screens/favourites.dart';
import 'package:melodify/screens/category.dart';
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
  List<SongModel> allSongs = [];
  List<SongModel> filteredSongs = [];
  List<String> searchHistory = [];

  int _selectedIndex = 2;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Favourites(),
    SearchScreen(),
    Category(),
    Placeholder(), // Replace with your profile screen if you have one
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _widgetOptions[index]),
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSongs();
    title.addListener(_filterSongs);
  }

  @override
  void dispose() {
    title.removeListener(_filterSongs);
    title.dispose();
    super.dispose();
  }

  void _loadSongs() async {
    List<SongModel> songs = await playerController.audioQuery.querySongs(
      ignoreCase: true,
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: null,
      uriType: UriType.EXTERNAL,
    );

    setState(() {
      allSongs = songs;
      filteredSongs = songs;
    });
  }

  void _filterSongs() {
    setState(() {
      if (title.text.isEmpty) {
        filteredSongs = [];
      } else {
        filteredSongs = allSongs
            .where((song) =>
                song.displayNameWOExt
                    .toLowerCase()
                    .contains(title.text.toLowerCase()) ||
                (song.artist != null &&
                    song.artist!
                        .toLowerCase()
                        .contains(title.text.toLowerCase())))
            .toList();
      }
    });
  }

  void _addToSearchHistory(String query) {
    if (query.isNotEmpty && !searchHistory.contains(query)) {
      setState(() {
        searchHistory.insert(0, query);
        if (searchHistory.length > 10) {
          searchHistory.removeLast();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Search',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              decorationColor: Color.fromARGB(19, 39, 1, 46),
              fontSize: 25),
        ),
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
                    _filterSongs();
                  },
                ),
                filled: true,
                fillColor: const Color.fromARGB(223, 225, 113, 164),
                hintText: 'Search....',
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(19, 0, 0, 0),
                    fontSize: 20),
              ),
              onFieldSubmitted: (query) {
                _addToSearchHistory(query);
                _filterSongs();
              },
            ),
            Expanded(
              child: title.text.isEmpty
                  ? _buildSearchHistory()
                  : _buildFilteredSongs(),
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
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0
                      ? const Color.fromARGB(255, 255, 0, 204)
                      : Colors.black,
                ),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: _selectedIndex == 1
                      ? const Color.fromARGB(255, 255, 0, 204)
                      : Colors.black,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: _selectedIndex == 2
                      ? const Color.fromARGB(255, 255, 0, 204)
                      : Colors.black,
                ),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: Icon(
                  Icons.category,
                  color: _selectedIndex == 3
                      ? const Color.fromARGB(255, 255, 0, 204)
                      : Colors.black,
                ),
                onPressed: () => _onItemTapped(3),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 4
                      ? const Color.fromARGB(255, 255, 0, 204)
                      : Colors.black,
                ),
                onPressed: () => _onItemTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Stack(
      fit: StackFit.expand,
      children: [
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
              child: ListView.builder(
                itemCount: searchHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      tileColor: const Color.fromARGB(19, 50, 30, 47),
                      title: Text(
                        searchHistory[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      leading: const FaIcon(FontAwesomeIcons.history),
                      onTap: () {
                        title.text = searchHistory[index];
                        _filterSongs();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilteredSongs() {
    return filteredSongs.isEmpty
        ? const Center(
            child: Text("No Song Found", style: TextStyle()),
          )
        : Stack(
            fit: StackFit.expand,
            children: [
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
                    child: ListView.builder(
                      itemCount: filteredSongs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Obx(
                            () => ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              tileColor: const Color.fromARGB(19, 50, 30, 47),
                              title: Text(
                                filteredSongs[index].displayNameWOExt,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                "${filteredSongs[index].artist}",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 14.0,
                                ),
                              ),
                              leading: QueryArtworkWidget(
                                id: filteredSongs[index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget:
                                    const FaIcon(FontAwesomeIcons.music),
                              ),
                              trailing:
                                  playerController.playIndex.value == index &&
                                          playerController.isPlaying.value
                                      ? const Icon(Icons.play_arrow,
                                          color: Colors.black, size: 28)
                                      : null,
                              onTap: () {
                                Get.to(
                                  () => Player(
                                    data: filteredSongs,
                                  ),
                                  transition: Transition.downToUp,
                                );
                                playerController.playSong(
                                    filteredSongs[index].uri, index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
