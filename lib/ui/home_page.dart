import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _buscar;

  late int _offSet;

  Future _getGifs() async {
    http.Response response;

    // ignore: unnecessary_null_comparison
    if (_buscar == null) {
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/trending?api_key=aaVClH3IDxPutSQeutFyZrw8OXYS1wHA&limit=25&rating=g'));
    } else {
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=aaVClH3IDxPutSQeutFyZrw8OXYS1wHA&q=$_buscar&limit=25&offset=$_offSet&rating=g&lang=pt'));
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Pesquise aqui!',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Container();
                      } else {
                        return _criarTabelaGif(context, snapshot);
                      }
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _criarTabelaGif(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: snapshot.data['data'].length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Image.network(
            snapshot.data['data'][index]['images']['fixed_height']['url'],
            height: 200.0,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
