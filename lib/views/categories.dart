import 'dart:convert';

import 'package:flutter/material.dart';

import '../view_model/wallpaper_model.dart';
import 'package:http/http.dart' as http;

import '../widgets/brand_name.dart';

class Categories extends StatefulWidget {
  final String categoriesName;
  const Categories({Key? key, required this.categoriesName}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final TextEditingController _controller = TextEditingController();
  List<WallPaperModel> wallpapers = [];
  getSearchPhoto(String data) async {
    final url = "https://api.pexels.com/v1/search?query=$data&per_page=10";
    var response =
        await http.get(Uri.parse(url), headers: {"Authorization": "t8BVCxCGZh6QwGVYbbPwdqYS1tPzBKnxlysuAf6GssNi5SxpXpVl0lAw"});
    // print(response.body);
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      //print(element);
      WallPaperModel wallPaperModel = WallPaperModel.fromMap(element);
      wallpapers.add(wallPaperModel);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSearchPhoto(widget.categoriesName);
    // _controller.text = widget.searchData;
  }
  List images = [];
  int page = 1;


 Future<void> loadMoreImages() async {
  page++; // Increment the page number
  const perPage = 20;
  final url = "https://api.pexels.com/v1/curated?per_page=$perPage&page=$page"; // Fix the URL parameter
  final response = await http.get(Uri.parse(url),
      headers: {"Authorization": "t8BVCxCGZh6QwGVYbbPwdqYS1tPzBKnxlysuAf6GssNi5SxpXpVl0lAw"});
  final jsonData = jsonDecode(response.body);
  jsonData["photos"].forEach((element) {
    WallPaperModel wallPaperModel = WallPaperModel.fromMap(element);
    wallpapers.add(wallPaperModel);
  });
  setState(() {});
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          title: BrandName(),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: wallPaperList(wallpapers, context),
            ),
            
          ],
          
        ),
       floatingActionButton: wallpapers.isEmpty
    ? null
    : FloatingActionButton(
        onPressed: () {
          // Add your action here
          loadMoreImages();
        },
        child: const Icon(Icons.replay_circle_filled_rounded),
      ),
        
        );

        

  
  }
  
}
