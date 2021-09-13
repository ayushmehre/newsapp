import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

getVideoThumbnail(String videoUrl) async {
  final fileName = await VideoThumbnail.thumbnailFile(
    video: videoUrl,
    thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.PNG,
    maxHeight: 450,
    maxWidth:
        400, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    quality: 100,
  );
  File file = File(fileName!);
  return file;
}
