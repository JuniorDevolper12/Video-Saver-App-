import 'package:api_test/Provider/Downloadprovider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'downloaded.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    copytext();
  }

  String copiedtext = '';

  final urlcontroller = TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    copytext();
  }

  void copytext() {
    FlutterClipboard.paste().then((value) {
      if (value.contains('http') || value.contains('www')) {
        Fluttertoast.showToast(msg: 'Link Copied From Clipboard');
        setState(() {
          copiedtext = value;
          urlcontroller.text = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoDownloadProvider>(
      create: (_) => VideoDownloadProvider(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VideoList(),
                  ),
                );
              },
              icon: const Icon(Icons.download, color: Colors.white),
            )
          ],
          backgroundColor: Colors.teal,
          titleTextStyle: GoogleFonts.aBeeZee(
            textStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          title: const Text('Video Saver'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Center(
              child: Consumer<VideoDownloadProvider>(
                builder: (context, provider, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text('Paste Any Url From Any Social Media',
                            style: GoogleFonts.aBeeZee(
                              textStyle: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: TextField(
                            controller: urlcontroller,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.add,
                                  color: Colors.red,
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        urlcontroller.text = '';
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.blue,
                                    )),
                                hintText: 'Enter or Paste Url',
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2)),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                          ),
                        ),
                      ),
                      // .. Download Button
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: GestureDetector(
                            onTap: () {
                              if (urlcontroller.text.isNotEmpty) {
                                FocusScope.of(context).unfocus();
                                provider.downloadVideo(
                                    context, urlcontroller.text);
                              } else {
                                Fluttertoast.showToast(msg: 'Empty Url');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(20)),
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: provider.isDownloading
                                  ? const Center(
                                      child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 3))),
                                    )
                                  : Center(
                                      child: Text('Download Video',
                                          style: GoogleFonts.aBeeZee(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          )),
                                    ),
                            )),
                      ),

                      if (provider.isDownloading)
                        Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: CircularPercentIndicator(
                              header: const Text('Download Progress'),
                              progressColor: Colors.green,
                              animation: true,
                              animateFromLastPercent: true,
                              center: Text(
                                  (provider.downloadProgress / 100).toString()),
                              radius: 40,
                              percent: provider.downloadProgress > 0
                                  ? provider.downloadProgress / 100
                                  : 0 / 100,
                            )),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
