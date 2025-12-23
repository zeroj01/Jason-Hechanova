import 'package:flutter/material.dart';
import 'package:my_first_app/class_data.dart';

class SportDetailsPage extends StatelessWidget {
  final BallClass ball;

  const SportDetailsPage({super.key, required this.ball});

  @override
  Widget build(BuildContext context) {
    final ballName = ball.name.replaceAll('_', ' ');
    
    return Scaffold(
      appBar: AppBar(
        title: Text(ballName),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                ball.imagePath,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            // History Section
            _buildSectionTitle(Icons.history_edu_rounded, 'History of the Sport'),
            _buildSectionBody(_getSportHistory(ball.name)),
            
            const SizedBox(height: 24),

            // How to Play Section
            _buildSectionTitle(Icons.play_circle_outline_rounded, 'How to Play'),
            _buildSectionBody(_getHowToPlay(ball.name)),

            const SizedBox(height: 24),

            // Fun Facts Section
            _buildSectionTitle(Icons.lightbulb_outline_rounded, 'Fun Facts'),
            _buildSectionBody(_getFunFacts(ball.name)),

            const SizedBox(height: 24),

            // Ball Specs Section
            _buildSectionTitle(Icons.straighten_rounded, 'Ball Specifications'),
            _buildSectionBody(_getBallSpecs(ball.name)),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 28),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ],
    );
  }

  Widget _buildSectionBody(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 38.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade800, height: 1.5),
      ),
    );
  }

  // --- Content Helpers ---

  String _getSportHistory(String ballName) {
    switch (ballName) {
      case 'American Football':
        return 'American football evolved in the USA from soccer and rugby in the late 19th century. The first game was played in 1869.';
      case 'Table Tennis Ball':
        return 'Originating in Victorian England as a parlor game, it was popularized globally and became an Olympic sport in 1988.';
      case 'Baseball':
        return 'Evolving from older bat-and-ball games like rounders, baseball became the "national pastime" of the US in the mid-1800s.';
      case 'Basketball':
        return 'Invented in 1891 by Dr. James Naismith in Springfield, Massachusetts, using a peach basket and a soccer ball.';
      case 'Football':
        return 'The most popular sport in the world, its modern rules were codified in England in 1863, though ball games date back millennia.';
      case 'Bowling Ball':
        return 'Bowling traces back to ancient Egypt. Modern 10-pin bowling was popularized in the US during the 19th century.';
      case 'Cricket Ball':
        return 'Cricket originated in southeast England in the 16th century. By the 18th century, it was the national sport of England.';
      case 'Hockey Puck':
        return 'Ice hockey developed in Canada in the mid-19th century. The first indoor game was played in Montreal in 1875.';
      case 'Tennis Ball':
        return 'Modern tennis originated in Birmingham, England, in the late 19th century as "lawn tennis" played on grass.';
      case 'Shuttlecock':
        return 'Badminton evolved from "poona" in India. British officers brought it to England in the 1870s.';
      default:
        return 'History details are coming soon!';
    }
  }

  String _getHowToPlay(String ballName) {
    switch (ballName) {
      case 'American Football':
        return 'Two teams of 11 players try to move an oval ball to the opponent\'s end zone to score touchdowns.';
      case 'Table Tennis Ball':
        return 'Players hit a lightweight ball across a table divided by a net using small paddles.';
      case 'Baseball':
        return 'Batters try to hit a pitched ball and run around four bases to score runs while the fielding team tries to get them out.';
      case 'Basketball':
        return 'Two teams of 5 players try to shoot a ball through a hoop 10 feet high while dribbling and passing.';
      case 'Football':
        return 'Two teams of 11 players try to kick a round ball into the opponent\'s goal. Only goalkeepers can use their hands.';
      case 'Bowling Ball':
        return 'Players roll a heavy ball down a lane to knock down ten pins arranged in a triangle.';
      case 'Cricket Ball':
        return 'A bat-and-ball game played between two teams of 11 players on a field with a central pitch.';
      case 'Hockey Puck':
        return 'Two teams use sticks to shoot a rubber disc (puck) into the opponent\'s goal on an ice rink.';
      case 'Tennis Ball':
        return 'Players use rackets to hit a ball over a net into the opponent\'s court, trying to make it unreturnable.';
      case 'Shuttlecock':
        return 'Players hit a feathered projectile (shuttlecock) over a high net using lightweight rackets.';
      default:
        return 'Rules for this sport are coming soon!';
    }
  }

  String _getFunFacts(String ballName) {
    switch (ballName) {
      case 'American Football':
        return '• An NFL ball is cowhide, not pigskin.\n• The Super Bowl is the biggest US sporting event.';
      case 'Table Tennis Ball':
        return '• Can reach speeds of 100 mph.\n• Originally played with cigar box lids.';
      case 'Baseball':
        return '• 108 double stitches on a ball.\n• Baseballs were originally brown.';
      case 'Basketball':
        return '• Originally played with a soccer ball.\n• Slam dunks were once banned in the NCAA.';
      case 'Football':
        return '• The world cup is watched by billions.\n• Most balls are made in Sialkot, Pakistan.';
      case 'Bowling Ball':
        return '• Bowling balls used to be made of wood.\n• The first balls were made of rubber in 1905.';
      case 'Cricket Ball':
        return '• They are traditionally red, but white is used for night matches.\n• The core is made of cork.';
      case 'Hockey Puck':
        return '• Pucks are frozen before games to prevent them from bouncing.\n• They are made of vulcanized rubber.';
      case 'Tennis Ball':
        return '• Yellow balls were introduced to make them more visible on TV.\n• Wimbledon uses over 50,000 balls per year.';
      case 'Shuttlecock':
        return '• The best ones are made from the left wing of a goose.\n• It is the fastest racket sport in the world.';
      default:
        return 'Interesting facts are coming soon!';
    }
  }

  String _getBallSpecs(String ballName) {
    switch (ballName) {
      case 'American Football':
        return '• Prolate Spheroid\n• Weight: 14–15 oz\n• Length: ~11 in.';
      case 'Table Tennis Ball':
        return '• Diameter: 40mm\n• Weight: 2.7g\n• Material: Polymer/Celluloid.';
      case 'Baseball':
        return '• Weight: 5–5.25 oz\n• Core: Cork and rubber\n• Cover: Leather.';
      case 'Basketball':
        return '• Circumference: 29.5 in (Size 7)\n• Weight: 22 oz\n• Material: Synthetic/Leather.';
      case 'Football':
        return '• Circumference: 27–28 in\n• Weight: 14–16 oz\n• Pressure: 8.5–15.6 psi.';
      case 'Bowling Ball':
        return '• Diameter: 8.5 in\n• Weight: 6–16 lbs\n• Material: Plastic/Urethane/Resin.';
      case 'Cricket Ball':
        return '• Circumference: 8.81–9 in\n• Weight: 5.5–5.75 oz\n• Cover: Tanned Leather.';
      case 'Hockey Puck':
        return '• Diameter: 3 in\n• Thickness: 1 in\n• Weight: 5.5–6 oz.';
      case 'Tennis Ball':
        return '• Diameter: 2.57–2.70 in\n• Weight: 2–2.1 oz\n• Surface: Optic Yellow Felt.';
      case 'Shuttlecock':
        return '• Weight: 4.74–5.50 g\n• Feathers: 16 total\n• Base: Cork.';
      default:
        return 'Specifications are coming soon!';
    }
  }
}
