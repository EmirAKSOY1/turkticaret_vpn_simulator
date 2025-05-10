import '../models/country.dart';
import '../models/connection_stats.dart';
import '../models/location.dart';

class MockDataService {
  static final List<Country> mockCountries = [
    Country(
      name: 'Italy',
      flag: 'assets/flags/italy.png',
      city: '',
      locationCount: 4,
      strength: 70,
      locations: [
        Location(name: 'Rome', isFree: true),
        Location(name: 'Milan', isFree: false),
        Location(name: 'Naples', isFree: true),
        Location(name: 'Turin', isFree: false),
      ],
    ),
    Country(
      name: 'Netherlands',
      flag: 'assets/flags/netherlands.png',
      city: 'Amsterdam',
      locationCount: 12,
      strength: 85,
      locations: [
        Location(name: 'Amsterdam', isFree: true),
        Location(name: 'Rotterdam', isFree: false),
        Location(name: 'Utrecht', isFree: true),
        Location(name: 'Eindhoven', isFree: false),
      ],
    ),
    Country(
      name: 'Germany',
      flag: 'assets/flags/germany.png',
      city: '',
      locationCount: 10,
      strength: 90,
      locations: [
        Location(name: 'Berlin', isFree: true),
        Location(name: 'Munich', isFree: false),
        Location(name: 'Frankfurt', isFree: true),
        Location(name: 'Hamburg', isFree: false),
        Location(name: 'Stuttgart', isFree: false),
      ],
    ),
  ];

  static final ConnectionStats mockConnectionStats = ConnectionStats(
    downloadSpeed: 527,
    uploadSpeed: 49,
    connectedTime: Duration(hours: 2, minutes: 41, seconds: 52),
    connectedCountry: mockCountries[1],
  );
} 