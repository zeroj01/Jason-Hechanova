import 'package:flutter/material.dart';

class BallClass {
  final String name;
  final String imagePath;
  final String description;

  BallClass({
    required this.name,
    required this.imagePath,
    required this.description,
  });
}

// Correctly placed Table Tennis Ball in the second position
final List<BallClass> ballClasses = [
  BallClass(
    name: 'American Football',
    imagePath: 'assets/classes/americanfootball.jpg',
    description: 'An oval-shaped ball used in American and Canadian football.',
  ),
  BallClass(
    name: 'Table Tennis Ball',
    imagePath: 'assets/classes/tabletennis.jpg',
    description: 'A lightweight, hollow ball used in table tennis (ping-pong).',
  ),
  BallClass(
    name: 'Baseball',
    imagePath: 'assets/classes/baseball.jpg',
    description: 'A small, hard ball used in the sport of baseball.',
  ),
  BallClass(
    name: 'Basketball',
    imagePath: 'assets/classes/basketball.jpg',
    description: 'A large, inflatable ball used in the sport of basketball.',
  ),
  BallClass(
    name: 'Football',
    imagePath: 'assets/classes/soccer.jpg',
    description: 'A round ball used in the sport of association football (soccer).',
  ),
  BallClass(
    name: 'Bowling Ball',
    imagePath: 'assets/classes/bowlingball.jpg',
    description: 'A heavy, solid ball used to knock down pins in bowling.',
  ),
  BallClass(
    name: 'Cricket Ball',
    // Fixed the missing quote and comma
    imagePath: 'assets/classes/cricketball.jpg',
    description: 'A hard, solid ball used in the sport of cricket.',
  ),
  BallClass(
    name: 'Hockey Puck',
    imagePath: 'assets/classes/hockeypuck_2.jpg',
    description: 'A vulcanized rubber disc used in the sport of ice hockey.',
  ),
  BallClass(
    name: 'Tennis Ball',
    imagePath: 'assets/classes/tennisball.jpeg',
    description: 'A felt-covered rubber ball used in the sport of tennis.',
  ),
  BallClass(
    name: 'Shuttlecock',
    imagePath: 'assets/classes/shuttlecock.jpg',
    description: 'A high-drag projectile used in the sport of badminton.',
  ),
];
