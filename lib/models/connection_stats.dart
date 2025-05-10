import 'country.dart';

class ConnectionStats {
  final double downloadSpeed;
  final double uploadSpeed;
  final Duration connectedTime;
  final Country connectedCountry;

  ConnectionStats({
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.connectedTime,
    required this.connectedCountry,
  });
} 