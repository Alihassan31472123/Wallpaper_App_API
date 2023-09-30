import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wallpaper4k/views/search_view.dart';
import 'package:http/http.dart' as http;
import '../data/data.dart';
import '../view_model/categories_model.dart';
import '../view_model/wallpaper_model.dart';
import '../widgets/brand_name.dart';
import '../widgets/categories_tile.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {



late final AnimationController _controller2 = AnimationController( 
  duration : const Duration(seconds: 3),
  vsync: this)..repeat();
void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
 List images = [];
  int page = 1;



  List<CategoriesModel> categories = [];
  List<WallPaperModel> wallpapers = [];
  final TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();


@override




  getTrendingPhotos() async {
    const url = "https://api.pexels.com/v1/curated?per_page=90";
    var response =
        await http.get(Uri.parse(url), headers: {"Authorization": "t8BVCxCGZh6QwGVYbbPwdqYS1tPzBKnxlysuAf6GssNi5SxpXpVl0lAw"});
    print(response.body.toString());
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      //print(element);
      WallPaperModel wallPaperModel = WallPaperModel.fromMap(element);
      wallpapers.add(wallPaperModel);
    });
    setState(() {});
  }

  void loadCategories() {
    categories = getCategories();
    setState(() {});
  }

  @override
 @override
void initState() {
  super.initState();
  getTrendingPhotos();
  loadCategories();
  _scrollController.addListener(() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User reached the end, load more images
      loadMoreImages();
    }
  });
}


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
          elevation: 0,
          title: BrandName(),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                 boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.shade300,
                        offset: new Offset(
                          3.3,
                          3.3,
                        ),
                      )
                    ],
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xfff5f8fD)),
                  
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        hintText: "Search", border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SearchView(searchData: _controller.text)));
                      },
                      icon: const Icon(Icons.search)),
                      
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 100,
                // child: ListView.builder(itemCount: categories.length,
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemBuilder: (context, index) => CategoriesTile(imgUrl: categories[index].imgUrl,
                //     title:categories[index].categoriesName)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    ...categories
                        .map((category) => CategoriesTile(
                              imgUrl: category.imgUrl,
                              title: category.categoriesName,
                            ))
                        .toList(),
                  ]),
                )),
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
        child: Icon(Icons.replay_circle_filled_rounded),
      ),

        );
  }
}
