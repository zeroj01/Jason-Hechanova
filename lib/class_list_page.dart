import 'package:flutter/material.dart';
import 'package:my_first_app/class_data.dart';
import 'package:my_first_app/sport_details_page.dart';

class ClassListPage extends StatelessWidget {
  final VoidCallback onNavigateToClassifier;

  const ClassListPage({super.key, required this.onNavigateToClassifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: GridView.builder(
        itemCount: ballClasses.length,
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          // Changed aspect ratio for a cleaner, image-focused card
          childAspectRatio: 0.9, 
        ),
        itemBuilder: (context, index) {
          final ball = ballClasses[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SportDetailsPage(ball: ball),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(
                      ball.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.sports_soccer, size: 50, color: Colors.grey));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ball.name.replaceAll('_', ' '),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
