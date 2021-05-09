import 'package:flutter/material.dart';
import 'package:flutter_movie/models/movie.dart';
import 'package:flutter_movie/viewpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'movie_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider<MovieInfo>(create: (_) => MovieInfo()),
    ],
    child: MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
    primarySwatch: Colors.blue,
    ),
      home: MovieSearch(),
    ),
    );
  }
}

class MovieSearch extends StatefulWidget {
  @override
  _MovieSearchState createState() => _MovieSearchState();
}

class _MovieSearchState extends State<MovieSearch> {

  final _controller = TextEditingController();
  final List<Results> moviesItems = [];
  List<Results> movies = [];


  Future<Movie> fetchData() async {
    var uri = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=a64533e7ece6c72731da47c9c8bc691f&language=ko-KR&page=1');
    var response = await http.get(uri);

    Movie result = Movie.fromJson(json.decode(response.body));
    return result;
  }

  @override
  void initState() {
    super.initState();
    Provider.of<MovieInfo>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {

    MovieInfo movieInfo = Provider.of(context);
    Movie result = movieInfo.result;

    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('MOVIE Search',
        style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
              onChanged: (text) {
                setState(() {
                  movieInfo.filteredItems.clear();
                  for (var item in movieInfo.movies) {
                    if (item.title.contains(text)) {
                      movieInfo.filteredItems.add(item);
                    }
                  }
                });
            }
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 2 / 3.7,
              children: _buildItems(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Results movies) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewPage(movies)),
        );
      },
      child: Column(
        children: <Widget>[
          Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Hero(
              tag: movies.posterPath,
              child: Image.network('https://image.tmdb.org/t/p/w500/${movies.posterPath}'),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                movies.title,
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }


  List<Widget> _buildItems() {
    MovieInfo movieInfo = Provider.of(context);
    Movie result = movieInfo.result;

    if (_controller.text.isEmpty) {
      return result.results.map((e) => _buildItem(e)).toList();
    }
    return movieInfo.filteredItems.map((e) => _buildItem(e)).toList();
  }

}