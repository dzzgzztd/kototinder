import 'package:flutter/material.dart';
import 'cat_card.dart';
import 'cat_api.dart';
import 'cat_action_buttons.dart';

// Основной экран приложения
class CatHomeScreen extends StatefulWidget {
  const CatHomeScreen({super.key});

  @override
  CatHomeScreenState createState() => CatHomeScreenState();
}

class CatHomeScreenState extends State<CatHomeScreen> {
  int _likeCount = 0;
  String _imageUrl = '';
  String _breedName = '';
  String _breedDescription = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCat();
  }

  Future<void> _fetchCat() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final catData = await fetchCatWithBreed();

      if (!mounted) return;

      if (catData['breeds'] != null && catData['breeds'].isNotEmpty) {
        setState(() {
          _imageUrl = catData['url'];
          _breedName = catData['breeds'][0]['name'];
          _breedDescription = catData['breeds'][0]['description'];
        });
      } else {
        setState(() {
          _imageUrl = '';
          _breedName = 'Unknown';
          _breedDescription = '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки котика: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _likeCat() {
    setState(() {
      _likeCount++;
    });
    _fetchCat();
  }

  void _dislikeCat() {
    _fetchCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/title.png', height: 40),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CatCard(
                  imageUrl: _imageUrl,
                  breedName: _breedName,
                  breedDescription: _breedDescription,
                  onLike: _likeCat,
                  onDislike: _dislikeCat,
                ),
              ],
            ),
      bottomNavigationBar: CatActionButtons(
        likeCount: _likeCount,
        onLike: _likeCat,
        onDislike: _dislikeCat,
      ),
    );
  }
}
