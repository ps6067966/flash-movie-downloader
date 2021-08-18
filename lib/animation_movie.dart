import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_movie_downloader/const.dart';
import 'package:flash_movie_downloader/movie_card.dart';
import 'package:flutter/material.dart';

class AnimationMovie extends StatelessWidget {
  const AnimationMovie({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieSnapsot = FirebaseFirestore.instance
        .collection('movies')
        .where('movieCategory', isEqualTo: 'animation')
        .orderBy('id', descending: true)
        .snapshots();
    return Scaffold(
      appBar: appBar,
      body: StreamBuilder<QuerySnapshot>(
          stream: movieSnapsot,
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              final movieDocuments = snapshot.data?.docs;
              return ListView.builder(
                itemCount: movieDocuments?.length,
                itemBuilder: (ctx, index) => MovieCard(
                  movieDownloadLink: movieDocuments?[index]
                      ['movieDownloadLink'],
                  movieName: movieDocuments?[index]['movieName'],
                  movieImgUrl: movieDocuments?[index]['movieImgUrl'],
                ),
              );
            }
          }),
    );
  }
}
