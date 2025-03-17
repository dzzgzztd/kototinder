import 'package:flutter/material.dart';
import 'cat_details_screen.dart';

// Карточка котика
class CatCard extends StatelessWidget {
  final String imageUrl;
  final String breedName;
  final String breedDescription;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const CatCard({
    super.key,
    required this.imageUrl,
    required this.breedName,
    required this.breedDescription,
    required this.onLike,
    required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Название породы
        Text(
          breedName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Оборачиваем карточку в Dismissible для реализации анимации свайпов
        Dismissible(
          key: ValueKey(imageUrl),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              onLike();
            } else {
              onDislike();
            }
          },

          // Подсказки при свайпе
          background: Container(
            color: Colors.green.withAlpha(77),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.thumb_up, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red..withAlpha(77),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.thumb_down, color: Colors.white),
          ),

          child: GestureDetector(
            // Переход на экран деталей по нажатию
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CatDetailsScreen(
                        imageUrl: imageUrl,
                        breedName: breedName,
                        breedDescription: breedDescription,
                      ),
                ),
              );
            },

            // Изображение котика с подгонкой под ширину экрана
            child: Builder(
              builder: (context) {
                final screenWidth = MediaQuery.of(context).size.width;

                return SizedBox(
                  width: screenWidth,
                  child: Image.network(imageUrl, fit: BoxFit.fitWidth),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
