import 'location.dart';

class Country {
  final String name;
  final String flag;
  final String city;
  final int locationCount;
  final int strength;
  final List<Location> locations;

  Country({
    required this.name,
    required this.flag,
    required this.city,
    required this.locationCount,
    required this.strength,
    required this.locations,
  });
} 