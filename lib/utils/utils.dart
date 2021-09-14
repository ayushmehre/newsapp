import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/widgets/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

getVideoThumbnail(String videoUrl) async {
  final fileName = await VideoThumbnail.thumbnailFile(
    video: videoUrl,
    thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.PNG,
    maxHeight: 450,
    maxWidth: 400,
    // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    quality: 100,
  );
  File file = File(fileName!);
  return file;
}

Future<File?> pickVideo(BuildContext context) async {
  final videoInfo = FlutterVideoInfo();
  final selected = ImagePicker();
  final selectedImage = await selected.pickVideo(source: ImageSource.gallery);
  var video = await videoInfo.getVideoInfo(selectedImage!.path);

    File _file = File(selectedImage.path);
    VideoPlayerController.file(File(selectedImage.path));

    var endDuration = (video!.duration)! / 1000 <= 60;
    var startDuration = (video.duration)! / 1000 >= 10;
    var lengthSync = _file.lengthSync();
    var filelength = (lengthSync / 1024 / 1024) <= 50;
    if (!startDuration) {
      showErrorDialog(
          context, "Error", "Please select file greater then 10 seconds");
      return null;
    }
    if (!endDuration) {
      showErrorDialog(
          context, "Error", "Please select file less then 60 seconds");
      return null;
    }
    if (!filelength) {
      showErrorDialog(
          context, "Error", "File size should not be greater then 50MB");
      return null;
    }
    return _file;
}
