import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavouritesController extends GetxController {
  var favourites = <SongModel>[].obs;

  void addFavourite(SongModel song) {
    if (!favourites.contains(song)) {
      favourites.add(song);
    }
  }

  void removeFavourite(SongModel song) {
    favourites.remove(song);
  }

  bool isFavourite(SongModel song) {
    return favourites.contains(song);
  }
}
