import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/controllers/favourites_controller.dart';
import 'package:melodify/screens/category.dart';
import 'package:melodify/screens/home.dart';
import 'package:melodify/screens/player.dart';
import 'package:melodify/screens/profile.dart';
import 'package:melodify/screens/searchscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  TextEditingController title = TextEditingController();
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Favourites(),
    SearchScreen(),
    Category(),
    Profile(),
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

  final FavouritesController favouritesController =
      Get.put(FavouritesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Favourites',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
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
        elevation: 25.0,
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/images/body_pic.jpg", // Your background image
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 255, 131, 187).withOpacity(0.8),
                  const Color.fromARGB(255, 234, 187, 209).withOpacity(0.8),
                ],
              ),
            ),
            height: double.infinity,
            width: double.infinity,
          ),
          Obx(() {
            if (favouritesController.favourites.isEmpty) {
              return Center(
                child: Text(
                  'No favourite songs added.',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: favouritesController.favourites.length,
                itemBuilder: (context, index) {
                  SongModel song = favouritesController.favourites[index];
                  return ListTile(
                    leading: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Icon(Icons.music_note),
                    ),
                    title: Text(
                      song.displayNameWOExt,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      song.artist ?? 'Unknown Artist',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        favouritesController.removeFavourite(song);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Player(data: [song]),
                        ),
                      );
                    },
                  );
                },
              );
            }
          }),
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
              Color.fromARGB(255, 252, 250, 251),
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
}
