import 'package:flutter/material.dart';
import 'package:melodify/screens/home.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favourites',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              decorationColor: Color.fromARGB(19, 39, 1, 46)),
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
        elevation: 25.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 131, 187),
              Color.fromARGB(255, 234, 187, 209)
            ],
          ),
        ),
        // height: double.infinity,
        // width: double.infinity,
        // child: const Scaffold(
        //   backgroundColor: Colors.transparent,
        // ),
      ),

      // Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: const Text('Go back to Screen 1'),
      //   ),
      // ),

      bottomNavigationBar: Container(
        height: 60.0,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 245, 142, 211),
              Color.fromARGB(255, 250, 232, 240)
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Favourites()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_box,
                  color: Colors.black,
                ),
                onPressed: () {},
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
