import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke generator',
      theme: ThemeData(),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Joke? _joke; // Make _joke nullable
  late String _errorMessage;

  @override
  void initState() {
    super.initState();
    _joke = Joke(type: '', setup: '', punchline: '', id: 0);
    _errorMessage = '';
    fetchJoke();
  }

  Future<void> fetchJoke() async {
    try {
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
          _errorMessage = ''; // Reset error message if request is successful
        });
      } else {
        throw Exception(
            'Failed to load joke. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joke Generator'),
        centerTitle: true,
      ),
      body: Center(
        child: _errorMessage.isNotEmpty
            ? Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _joke!.setup,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _joke!.punchline,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchJoke,
        tooltip: 'Next Joke',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class Joke {
  String type;
  String setup;
  String punchline;
  int id;

  Joke({
    required this.type,
    required this.setup,
    required this.punchline,
    required this.id,
  });
}
