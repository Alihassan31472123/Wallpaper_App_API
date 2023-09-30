

import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/brand_name.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  const ImageView({Key? key, required this.imgUrl}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
    var filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        title: BrandName(),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Hero(
                tag: widget.imgUrl,
                child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.network(
                      widget.imgUrl,
                      fit: BoxFit.cover,
                    )),
              ),

              Positioned(bottom: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.bottomCenter,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(onTap: (){_save();
                        print("a na");},
                        child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xff1C1B1B),width: 3),
                                borderRadius: BorderRadius.circular(25),
                                color: const Color(0xff1C1B1B).withOpacity(0.8),
                                // gradient: LinearGradient(colors:
                                // [
                                //   Color(0x36FFFFFF),
                                //   Color(0x0FFFFFFF,),
                                // ],
                                //     begin: FractionalOffset.topLeft,
                                //     end: FractionalOffset.bottomRight)
                            ),
                            child: Column(
                              children: const [
                                SizedBox(height: 2,),
                                Text("Download wallpaper",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),),
                                SizedBox(
                                  height: 3,
                                ),
                                Text("Image will be saved in gallery",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white70),
                                      ),
                                SizedBox(
                                  height: 3,
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height:10,
                      ),
                      Container(
                        width: 70,
                        decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xff1C1B1B),width: 3),
                                borderRadius: BorderRadius.circular(25),
                                color: const Color(0xff1C1B1B).withOpacity(0.8),
                                // gradient: LinearGradient(colors:
                                // [
                                //   Color(0x36FFFFFF),
                                //   Color(0x0FFFFFFF,),
                                // ],
                                //     begin: FractionalOffset.topLeft,
                                //     end: FractionalOffset.bottomRight)
                            ),
                        child: Center(child: const Text("Cancel",style: TextStyle(color: Colors.white),))),
                      const SizedBox(
                        height: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }





  
   void _save() async {
    var response = await Dio().get(
      widget.imgUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 100,
    );

    if (result['isSuccess']) {
      _showMessage("Image saved in gallery.");
    } else {
      _showMessage("Failed to save image.");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

   _askPermission() async {
  if (Platform.isAndroid) {
    var permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
      // Permission granted
    } else {
      // Permission denied or permanently denied
      if (await Permission.storage.isPermanentlyDenied) {
        openAppSettings(); // Open app settings to allow the user to manually grant permissions
      }
    }
  } else { 
    // Handle iOS permission request
    // ...
  }
}



    