import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:InstaReels/VideoPlayer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class GenrateVideoFrompath extends StatefulWidget {
  final String path;
  const GenrateVideoFrompath(this.path, {super.key});
  @override
  _GenrateVideoFrompathState createState() => _GenrateVideoFrompathState();
}

class _GenrateVideoFrompathState extends State<GenrateVideoFrompath> {
  var uint8list = null;
  bool loading = true;
  @override
  void initState() {
    genrateThumb();
    loading = false;
    super.initState();
  }

  genrateThumb() async {
    await VideoThumbnail.thumbnailData(
      video: widget.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
          500, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 100,
    ).then((value) {
      uint8list = value;
      loading = false;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (uint8list == null) {
        return Container(
      color: Colors.transparent,
      child: CupertinoActivityIndicator()
        );
        }

    return Container(
      color: Colors.transparent,
      child: loading 
          ? CupertinoActivityIndicator()
          : InkWell(
              onTap: () {
                Get.to(VideoPlayer(widget.path));
              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                  // height: 60,
                  // width: 60,
                decoration: BoxDecoration(
                                    // color: Colors.red,

                  borderRadius: BorderRadius.circular(20),

                  image: DecorationImage(image: MemoryImage(uint8list),fit: BoxFit.cover)
                ),
                
              ),
              ClipOval(
                child: Container(
                  color: Colors.black38,
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.play_arrow,size: 30,color: Colors.white,),
                )),
              )
                ],
              )),
    );
  }
}
