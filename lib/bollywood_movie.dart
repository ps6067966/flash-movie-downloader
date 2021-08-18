import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'const.dart';
import 'movie_card.dart';

class BollywoodMovie extends StatelessWidget {
  const BollywoodMovie({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('movies')
              .where('movieCategory',isEqualTo: 'bollywood')
              .orderBy('id', descending: true)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              final movieDocuments = snapshot.data?.docs;
              return ListView.builder(
                itemCount: movieDocuments?.length,
                itemBuilder: (ctx, index) => MovieCard(
                  movieDownloadLink: movieDocuments?[index]['movieDownloadLink'],
                  movieName: movieDocuments?[index]['movieName'],
                  movieImgUrl: movieDocuments?[index]['movieImgUrl'],
                ),
              );
            }
          }),
    );
  }
}