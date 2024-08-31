import 'package:digisong_etr/components/category_item.dart';
import 'package:digisong_etr/components/footer.dart';
import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/data/category_list.dart';
import 'package:digisong_etr/screens/search_screen.dart';
import 'package:digisong_etr/screens/song_screen.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final player;
  const CategoryScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            color: backColor,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => SearchScreen(
                                player: player,
                              )),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 24.0,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    label: const Text(
                      'Search',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SongScreen(player: player)));
                    },
                    icon: const Icon(
                      Icons.mic,
                      size: 24.0,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    label: const Text('All', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 2),
              itemBuilder: ((_, index) => CategoryItem(
                    category: CategoryList[index],
                    player: player,
                  )),
              itemCount: CategoryList.length,
            ),
          ),
          FooterPlayer(player: player),
        ],
      )),
    );
  }
}
