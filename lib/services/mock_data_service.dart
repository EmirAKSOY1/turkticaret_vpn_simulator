import '../models/country.dart';
import '../models/connection_stats.dart';

class MockDataService {
  static final List<Country> mockCountries = [
    Country(
      name: 'Italy',
      flag: 'assets/flags/italy.png',
      city: '',
      locationCount: 4,
      strength: 70,
    ),
    Country(
      name: 'Netherlands',
      flag: 'assets/flags/netherlands.png',
      city: 'Amsterdam',
      locationCount: 12,
      strength: 85,
    ),
    Country(
      name: 'Germany',
      flag: 'assets/flags/germany.png',
      city: '',
      locationCount: 10,
      strength: 90,
    ),
  ];

  static final ConnectionStats mockConnectionStats = ConnectionStats(
    downloadSpeed: 527,
    uploadSpeed: 49,
    connectedTime: Duration(hours: 0, minutes: 0, seconds: 0),
    connectedCountry: mockCountries[1],
  );
} 