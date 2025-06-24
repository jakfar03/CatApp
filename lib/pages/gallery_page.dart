import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<String> _catImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCatGallery();
  }

  Future<void> fetchCatGallery() async {
    setState(() => _isLoading = true);
    final url = Uri.parse(
      'https://api.thecatapi.com/v1/images/search?limit=10',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _catImages = data
              .map<String>((item) => item['url'] as String)
              .toList();
        });
      }
    } catch (e) {
      print('Error fetching gallery: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cat Gallery')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _catImages.length,
              itemBuilder: (context, index) {
                return Image.network(_catImages[index], fit: BoxFit.cover);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchCatGallery,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
