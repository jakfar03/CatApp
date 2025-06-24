import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _catImageUrl;
  bool _isLoading = false;
  Color _backgroundColor = Colors.white;

  final List<Color> _colors = [
    Colors.white,
    Colors.lightBlue.shade50,
    Colors.pink.shade50,
    Colors.yellow.shade50,
    Colors.green.shade50,
    Colors.orange.shade50,
    Colors.purple.shade50,
  ];

  @override
  void initState() {
    super.initState();
    fetchRandomCat();
  }

  Future<void> fetchRandomCat() async {
    setState(() => _isLoading = true);
    final url = Uri.parse('https://api.thecatapi.com/v1/images/search');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() => _catImageUrl = data[0]['url']);
      }
    } catch (e) {
      print('Error fetching cat: $e');
    }
    setState(() => _isLoading = false);
  }

  void _changeBackgroundColor() {
    final random = Random();
    Color newColor;
    do {
      newColor = _colors[random.nextInt(_colors.length)];
    } while (newColor == _backgroundColor); // Hindari warna yang sama
    setState(() {
      _backgroundColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(title: const Text('Random Cat')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _catImageUrl == null
            ? const Text('Failed to load image')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(_catImageUrl!, height: 300),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: fetchRandomCat,
                    icon: const Icon(Icons.refresh),
                    label: const Text('New Cat'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _changeBackgroundColor,
                    icon: const Icon(Icons.format_paint),
                    label: const Text('Change Background'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade100,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
