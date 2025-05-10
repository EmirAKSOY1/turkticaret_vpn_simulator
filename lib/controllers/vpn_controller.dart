import 'package:get/get.dart';
import '../models/country.dart';
import '../models/connection_stats.dart';
import '../services/mock_data_service.dart';
import 'dart:async';

class VPNController extends GetxController {
  final Rx<Country?> selectedCountry = Rx<Country?>(null);
  final RxBool isConnected = false.obs;
  final Rx<ConnectionStats?> connectionStats = Rx<ConnectionStats?>(null);
  final RxList<Country> countries = <Country>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<Duration> liveConnectionTime = Duration.zero.obs;
  final RxBool isConnecting = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    loadCountries();
  }

  void loadCountries() {
    countries.value = MockDataService.mockCountries;
  }

  void searchCountries(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      countries.value = MockDataService.mockCountries;
    } else {
      countries.value = MockDataService.mockCountries
          .where((country) =>
              country.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void selectCountry(Country country) {
    selectedCountry.value = country;
  }

  Future<void> connect() async {
    if (selectedCountry.value != null) {
      isConnecting.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isConnected.value = true;
      connectionStats.value = ConnectionStats(
        downloadSpeed: MockDataService.mockConnectionStats.downloadSpeed,
        uploadSpeed: MockDataService.mockConnectionStats.uploadSpeed,
        connectedTime: Duration.zero,
        connectedCountry: selectedCountry.value!,
      );
      liveConnectionTime.value = Duration.zero;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        liveConnectionTime.value += const Duration(seconds: 1);
      });
      isConnecting.value = false;
    }
  }

  void disconnect() {
    isConnected.value = false;
    connectionStats.value = null;
    _timer?.cancel();
    liveConnectionTime.value = Duration.zero;
    isConnecting.value = false;
  }

  String getFormattedConnectionTime() {
    if (!isConnected.value) return '00:00:00';
    final duration = liveConnectionTime.value;
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
} 