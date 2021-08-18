import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:path_provider/path_provider.dart';

class MovieCard extends StatefulWidget {
  final String movieImgUrl;
  final String movieName;
  final String movieDownloadLink;
  MovieCard({
    required this.movieDownloadLink,
    required this.movieName,
    required this.movieImgUrl,
    Key? key,
  }) : super(key: key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  var taskId;
  int progress = 0;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {
        progress = data[2];
      });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    String? downloadTaskId;
    final similarButtonStyleforCardButton = ButtonStyle(
      elevation: MaterialStateProperty.all(30),
      shadowColor: MaterialStateProperty.all(Colors.yellowAccent),
      backgroundColor: MaterialStateProperty.all(Colors.amberAccent),
      side:
          MaterialStateProperty.all(BorderSide(color: Colors.lightBlueAccent)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
    );
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 20,
        child: Row(
          children: [
            Container(
              height: 230,
              width: 140,
              child: CachedNetworkImage(
                imageUrl: "${widget.movieImgUrl}",
                fit: BoxFit.fitHeight,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GlowText(
                        '${widget.movieName}',
                        glowColor: Colors.cyanAccent,
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Text(
                      'Downloading Progress: $progress%',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            Directory? appDocDir =
                                await getExternalStorageDirectory();
                            downloadTaskId = await FlutterDownloader.enqueue(
                              url: '${widget.movieDownloadLink}',
                              savedDir: appDocDir!.path,
                              fileName: '${widget.movieName}',
                              showNotification: true,
                              openFileFromNotification: true,
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                            side: MaterialStateProperty.all(
                                BorderSide(color: Colors.greenAccent)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          child: Text(
                            'Download',
                            style: TextStyle(
                                color: Colors.pinkAccent, fontSize: 20),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: similarButtonStyleforCardButton,
                              onPressed: () async {
                                downloadTaskId = await FlutterDownloader.resume(
                                    taskId: '$downloadTaskId');
                              },
                              child: Icon(Icons.play_arrow)),
                          ElevatedButton(
                              style: similarButtonStyleforCardButton,
                              onPressed: () async {
                                downloadTaskId = await FlutterDownloader.pause(
                                    taskId: '$downloadTaskId');
                              },
                              child: Icon(Icons.pause)),
                          ElevatedButton(
                              style: similarButtonStyleforCardButton,
                              onPressed: () async {
                                downloadTaskId = await FlutterDownloader.cancel(
                                    taskId: '$downloadTaskId');
                              },
                              child: Icon(
                                Icons.clear,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
