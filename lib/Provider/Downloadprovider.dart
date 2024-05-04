import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class VideoDownloadProvider extends ChangeNotifier {
  double _downloadProgress = 0.0;
  bool _isDownloading = false;

  double get downloadProgress => _downloadProgress;
  bool get isDownloading => _isDownloading;

  Future<void> downloadVideo(BuildContext context, String url) async {
    if (url.contains('facebook') ||
        url.contains('instagram') ||
        url.contains('youtube') ||
        url.contains('tiktok')) {
      if (url.contains('stories') && url.contains('instagram')) {
        _isDownloading = true;
        notifyListeners();
        Storydown(url);
      } else {
        _isDownloading = true;
        notifyListeners();
        //Generel Video Download
        var uri = Uri.https(
          'social-media-video-downloader.p.rapidapi.com',
          '/smvd/get/all',
          {'url': url},
        );

        final headers = {
          'X-RapidAPI-Key':
              '7c6c88394bmsh78748b39ef90971p16b981jsn5c205dc0e5e0',
          'X-RapidAPI-Host': 'social-media-video-downloader.p.rapidapi.com'
        };

        final response = await http.get(uri, headers: headers);

        if (response.statusCode == 200) {
          notifyListeners();
          _isDownloading = true;
          print('responce ok');
          final jsonData = jsonDecode(response.body);
          final links = jsonData['links'];
          String videoname = jsonData['title'];
          final availableQualities = <String>[];
          for (var item in jsonData['links']) {
            availableQualities.add(item['quality']);
          }

          for (var item in jsonData['links']) {
            availableQualities.add(item['quality']);
          }
          Future<String?> showdialog(List<String> availableQualities) async {
            return await showDialog<String>(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.grey.shade500,
                  title: const Text('Select Video Quality'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: availableQualities.take(5).map((quality) {
                        return TextButton(
                          onPressed: () => Navigator.pop(context, quality),
                          child: Text(quality),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          }

          final selectedQuality = await showdialog(availableQualities);
          if (selectedQuality != null) {
            for (var item in links) {
              if (item['quality'] == selectedQuality) {
                final downloadLink = item['link'];
                if (selectedQuality == 'mp3' || selectedQuality == 'audio') {
                  download(downloadLink, '$Title.mp3');
                } else {
                  download(downloadLink, '$Title.mp4');
                }
                break;
              }
            }
          }
        } else {
          Fluttertoast.showToast(msg: 'No Quality Selected');
          _isDownloading = false;
          notifyListeners();
        }
      }
    } else if (url.contains('www') ||
        url.contains('https') ||
        url.contains('http')) {
      _isDownloading = true;

      download(
          url,
          url.contains('video')
              ? 'download.mp4'
              : url.contains('mp4')
                  ? 'download.mp4'
                  : url.contains('jpg')
                      ? 'download.jpg'
                      : url.contains('image')
                          ? 'download.jpg'
                          : url.contains('pdf')
                              ? 'download.pdf'
                              : 'download');
    } else {
      Fluttertoast.showToast(msg: 'Invalid Url');
    }
  }

  Future<String?> showdialog(
      List<String> availableQualities, BuildContext context) async {
    return await showDialog<String>(
      barrierDismissible: false,
      // Notice the return type
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Select Video Quality'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: availableQualities.take(5).map((quality) {
                return TextButton(
                  onPressed: () => Navigator.pop(context, quality),
                  child: Text(quality),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void download(
    String url,
    String Filename,
  ) {
    FileDownloader.downloadFile(
      onDownloadRequestIdReceived: (downloadId) {
        Fluttertoast.showToast(msg: 'Download Started');
      },
      name: Filename,
      url: url,
      onDownloadError: (errorMessage) {
        showerrortoast();
        _downloadProgress = 0.0;
        _isDownloading = false;
        notifyListeners();
      },
      onProgress: (fileName, progress) {
        _downloadProgress = progress;
        notifyListeners();
        print(progress);
      },
      onDownloadCompleted: (path) {
        _downloadProgress = 0.0;
        _isDownloading = false;
        notifyListeners();
        print(path);
        Fluttertoast.showToast(msg: 'Download Complete');
      },
    );
  }

  void showerrortoast() {
    Fluttertoast.showToast(msg: 'Error Could not Download');
  }

  void Storydown(String url) async {
    print('tapped');
    var headers = {
      'X-RapidAPI-Key': '7c6c88394bmsh78748b39ef90971p16b981jsn5c205dc0e5e0',
      'X-RapidAPI-Host':
          'instagram-post-reels-stories-downloader.p.rapidapi.com',
    };

    var params = {
      'url': url,
    };

    var uri = Uri.https(
        'instagram-post-reels-stories-downloader.p.rapidapi.com',
        '/instagram/',
        params);

    try {
      var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var result = data['result'] as List;

        String url = result[0]['url'];
        String type = result[0]['type'];
        if (type.contains('image')) {
          download(url, 'story.jpg');
        } else {
          download(url, 'story.mp4');
        }
      } else {
        _isDownloading = false;
        notifyListeners();
        Fluttertoast.showToast(msg: 'Server Error');
      }
    } catch (e) {
      _isDownloading = false;
      notifyListeners();
      showerrortoast();
    }
  }
}
