import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:InstaReels/Controller/instagram_login.dart';
import 'package:InstaReels/model/insta_post_with_login.dart';
import 'package:InstaReels/model/insta_post_without_login.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart' as wb;
import 'package:external_path/external_path.dart';
import 'dart:math';

class DownloadController extends GetxController {
  var processing = false.obs;
  bool isLogin = false;
  String? path;
  var box = GetStorage();
  Dio dio = Dio();
  Random random = new Random();

  Future<String?> _startDownload(String link, BuildContext context) async {
    // Asking for video storage permission 
    await Permission.storage.request();
    isLogin = false;
    // Checking for Cookies
    final cookieManager = wb.WebviewCookieManager();
    final gotCookies = await cookieManager.getCookies('https://www.instagram.com/');
    // is Cookie found then set isLogin to true
    if (gotCookies.length > 0) isLogin = true;

    // Build the url
    var linkParts = link.replaceAll(" ", "").split("/");
    var url = '${linkParts[0]}//${linkParts[2]}/${linkParts[3]}/${linkParts[4]}' + "?__a=1&__d=dis";
    // Make Http requiest to get the download link of video
    print(url);
    var httpClient = new HttpClient();
    String? videoURLLLLL;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      print(request);
      print("REQUEST");
      gotCookies.forEach((element) {
        request.cookies.add(Cookie(element.name, element.value));
      });
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        print(data);
        print("data");
          // print(data["graphql"]["shortcode_media"]["display_resources"]);
        if (isLogin) {
          print("LOGIN");
          InstaPostWithLogin postWithLogin = InstaPostWithLogin.fromJson(data);
          videoURLLLLL = postWithLogin.items?.first.videoVersions?.first.url;
        } else {
          print("WITHOUT LOGIN");
          InstaPostWithoutLogin post = InstaPostWithoutLogin.fromJson(data);
          videoURLLLLL = post.graphql?.shortcodeMedia?.videoUrl;
        }
      }else{
              await Navigator.push(context, MaterialPageRoute(builder: (_) => InstaLogin()));

      }
    } catch (exception) {

      await Navigator.push(context, MaterialPageRoute(builder: (_) => InstaLogin()));
    }

    // Download video & save
    if (videoURLLLLL == null) {
      return null;
    } else {
     String path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
        print(path);
      // var appDocDir = await getTemporaryDirectory();
      // String savePath = appDocDir.path + "/temp.mp4";
      // print(savePath);
      var name = "${path}/${random.nextInt(90)+ random.nextInt(100)}.mp4";
     var res = await dio.download(videoURLLLLL, name);
     return name;
    //  print(res);
    }
  }

  downloadReal(String link, BuildContext context) async {
    print(link);
    processing.value = true;
    try {
      path = null;
      update();
      await _startDownload(link, context).then((value) {
        print(value);
        print("VALUE");
        if (value == null) throw Exception();
        path = value;
        update();
        List allVideosPath = box.read("allVideo") ?? [];
        print(allVideosPath);
        allVideosPath.add(path);
        box.write("allVideo", allVideosPath);
      });
    } catch (e) {}
    processing.value = false;
  }
}
