import 'package:flutter/material.dart';

class Category {
  final int categoryid;
  final String cattitle;
  final String catdesc;
  final IconData caticon;
                  
 
  Category(
      {required this.categoryid, required this.cattitle, required this.catdesc, this.caticon = Icons.favorite});
}