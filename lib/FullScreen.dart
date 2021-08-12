

import 'package:image_downloader/image_downloader.dart';

import 'package:flutter/material.dart';


class FullScreen extends StatefulWidget {
  final String imageurl;

  const FullScreen({Key key, this.imageurl}) : super(key: key);
  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> setDownload() async {
    var imageId = await ImageDownloader.downloadImage(widget.imageurl);
    var file = await ImageDownloader.findName(imageId);
    var path= await ImageDownloader.findPath(imageId);
    var mimetype= await ImageDownloader.findMimeType(imageId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Image.network(widget.imageurl),
              ),
            ),
            InkWell(
              onTap: () {
                setDownload();
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 60,
                  child: Center(
                      child: IconButton(
                        icon: Icon(Icons.arrow_circle_down,color: Colors.white,size: 50,),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
