import 'package:flutter/material.dart';
import 'package:jokegenerator/model/joke.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Joke? _joke; // Make _joke nullable

  @override
  void initState() {
    super.initState();
    fetchJoke();
  }

  Future<void> fetchJoke() async {
    final response = await http.get(
      Uri.parse('https://official-joke-api.appspot.com/jokes/random'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jokeData = json.decode(response.body);
      setState(() {
        _joke = Joke(
          type: jokeData['type'],
          setup: jokeData['setup'],
          punchline: jokeData['punchline'],
          id: jokeData['id'],
        );
      });
    } else {
      throw Exception('Failed to load joke');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke App'),
        centerTitle: true,
      ),
      body: Center(
        child: _joke != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _joke!.setup,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _joke!.punchline,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchJoke,
        tooltip: 'Next Joke',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
