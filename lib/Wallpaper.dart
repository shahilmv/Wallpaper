import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/FullScreen.dart';

class Wallpepar extends StatefulWidget {
  @override
  _WallpeparState createState() => _WallpeparState();
}

class _WallpeparState extends State<Wallpepar> {
  List images = [];
  int page = 1;
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
        headers: {
          "Authorization":
              "563492ad6f91700001000001ae939dc170f341b2aa375faea3358c9b"
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      print(images[0]);
    });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        "https://api.pexels.com/v1/curated?page=80&page=" + page.toString();
    await http.get(Uri.parse(url), headers: {
      "Authorization":
          "563492ad6f91700001000001ae939dc170f341b2aa375faea3358c9b"
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result["photos"]);
      });
      print(images.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Expanded(
                    child: StaggeredGridView.countBuilder(
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 4.0,
                        crossAxisCount: 4,
                        itemCount: images.length,
                        staggeredTileBuilder: (index) =>
                            new StaggeredTile.count(2, index.isEven ? 2 : 1),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullScreen(
                                            imageurl: images[index]["src"]
                                                ["large2x"],
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                elevation: 5,
                                margin: EdgeInsets.all(3),
                                child: Image.network(
                                  images[index]['src']['tiny'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        })),
              ],
            ),
          ),
          Positioned(
              bottom: 30,
              top: 750,
              right: 110,
              left: 110,
              child: InkWell(
                onTap: () {
                  loadmore();
                },
                child: Card(
                  color: Colors.black,
                  child: Center(
                      child: Text(
                    "Load more Image",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ))
        ],
      ),
    );
  }
}
