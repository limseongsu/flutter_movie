import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie/models/movie.dart';


class ViewPage extends StatelessWidget {
  final Results movies;

  ViewPage(this.movies);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        titleTextStyle: TextStyle(color: Colors.black),
        title: Text(movies.title,
        style: TextStyle(color: Colors.black),),)
      ,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(movies.title,
            style: TextStyle(color: Colors.black),),
            Row(
              children: [
                Image.network('https://image.tmdb.org/t/p/w500/${movies.posterPath}',width: 250,height: 250,),

                Container(
                  width: 70,
                  height: 60,

                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(child: Text('${movies.voteCount.toString()}',textAlign: TextAlign.center,),
                        color: Colors.white,)
                  ),
                ),
                Container(

                  width: 70,
                  height: 60,

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(child: Text('★${movies.voteAverage.toString()}'),
                      color: Colors.white,),
                  ),
                ),
              ],
            ),
            Text(movies.overview)
          ],
        ),
      ),



    );
  }
}