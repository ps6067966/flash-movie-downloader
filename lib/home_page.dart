import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_movie_downloader/animation_movie.dart';
import 'package:flash_movie_downloader/bollywood_movie.dart';
import 'package:flash_movie_downloader/highresolution_movie.dart';
import 'package:flash_movie_downloader/movie_card.dart';
import 'package:flash_movie_downloader/dualaudio_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'const.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: unused_field
  Future<void>? _launched;

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Stream<QuerySnapshot> updateSnapshot =
    //     FirebaseFirestore.instance.collection("updateapp").snapshots();
    final similarButtonStyle = ButtonStyle(
      elevation: MaterialStateProperty.all(30),
      shadowColor: MaterialStateProperty.all(Colors.yellowAccent),
      backgroundColor: MaterialStateProperty.all(Colors.black),
      side:
          MaterialStateProperty.all(BorderSide(color: Colors.lightBlueAccent)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
    );

    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber[300]!,
          //  actions: [Text(${updateSnapshot.forEach((element) {return })})],
            title: Text(
              'Flash Movie Downloader',
              style: TextStyle(color: Colors.red),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Shimmer(
                        color: Colors.cyanAccent,
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: similarButtonStyle,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => AnimationMovie()));
                            },
                            child: const Text(
                              'Animation Movies',
                              style: similarTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Shimmer(
                        color: Colors.cyanAccent,
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: similarButtonStyle,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => DualAudioMovie()));
                            },
                            child: const Text(
                              'Dual Audio Movies',
                              style: similarTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Shimmer(
                        color: Colors.cyanAccent,
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: similarButtonStyle,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => HighResolutionMovie()));
                            },
                            child: const Text(
                              '1080p Movies',
                              style: similarTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Shimmer(
                        color: Colors.cyanAccent,
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: similarButtonStyle,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => BollywoodMovie()));
                            },
                            child: const Text(
                              'Bollywood Movies',
                              style: similarTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GlowText(
                  'Recent Movies',
                  glowColor: Colors.indigoAccent[100],
                  style: TextStyle(
                      color: Colors.indigoAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.w800),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("movies")
                        .orderBy("id", descending: true)
                        .limit(10)
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        final data = snapshot.data?.docs;
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data?.length,
                            itemBuilder: (context, index) {
                              return MovieCard(
                                movieName: data?[index]['movieName'],
                                movieDownloadLink: data?[index]
                                    ['movieDownloadLink'],
                                movieImgUrl: data?[index]['movieImgUrl'],
                              );
                            });
                      }
                    }),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _launched =
                              _launchInBrowser('https://wa.me/+918058301863');
                        });
                      },
                      child: Text('Buy Source Code'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.cyanAccent[400]),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Made with ♥ in India',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
