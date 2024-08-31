import 'package:digisong_etr/constants/style_constants.dart';
import 'package:digisong_etr/models/category.dart';
import 'package:digisong_etr/screens/filtered_category_screen.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final player;
  const CategoryItem({super.key, required this.category, required this.player});

  @override
  Widget build(BuildContext context) {
  
    return GestureDetector(
      onTap: (){
        print(category.categoryid);
       Navigator.push(context, MaterialPageRoute(builder: (context) => FilteredCategoryScreen(category: category, player: player)));
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              // color: category.backColor,
              gradient: LinearGradient(
                  colors: [red.withOpacity(0.75), red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  category.caticon,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  category.cattitle,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          )),
    );
  }
}
