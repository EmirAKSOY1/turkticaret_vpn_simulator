import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vpn_controller.dart';
import '../models/country.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VPNController controller = Get.put(VPNController());
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: _selectedTab == 2
            ? const SettingsScreen()
            : Column(
                children: [
                  _buildHeader(),
                  _buildSearchBar(),
                  Obx(() => controller.isConnected.value
                      ? _buildConnectionCard()
                      : const SizedBox(height: 24)),
                  _buildFreeLocationsTitle(),
                  Expanded(child: Obx(() => _buildCountryList())),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A5CFF), Color(0xFF3A7BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleIcon(Icons.grid_view_rounded),
          const Text(
            'Countries',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          _circleIcon(Icons.emoji_events_outlined),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: controller.searchCountries,
              style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
              decoration: const InputDecoration(
                hintText: 'Search For Country Or City',
                hintStyle: TextStyle(color: Color(0xFFB0B0B0), fontSize: 16),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.search, color: Color(0xFF1A5CFF), size: 26),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Connecting Time',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => Text(
                controller.getFormattedConnectionTime(),
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              )),
          const SizedBox(height: 18),
          Row(
            children: [
              _buildFlag(controller.connectionStats.value?.connectedCountry.flag ?? ''),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          controller.connectionStats.value?.connectedCountry.name ?? '',
                          style: const TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Obx(() => Text(
                          controller.connectionStats.value?.connectedCountry.city ?? '',
                          style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                          ),
                        )),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Stealth', style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 13)),
                  Obx(() => Text(
                        '${controller.connectionStats.value?.connectedCountry.strength ?? 0}%',
                        style: const TextStyle(
                          color: Color(0xFF1A5CFF),
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('Download',
                  '${controller.connectionStats.value?.downloadSpeed ?? 0} MB', Icons.download_rounded, Color(0xFF3DD598)),
              _buildStatCard('Upload',
                  '${controller.connectionStats.value?.uploadSpeed ?? 0} MB', Icons.upload_rounded, Color(0xFFFF6B6B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFF666666), fontSize: 13)),
              Text(value, style: const TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFreeLocationsTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Free Locations',
            style: TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => Text('(${controller.countries.length})', style: const TextStyle(color: Color(0xFF666666)))),
          const Spacer(),
          Icon(Icons.info_outline, color: Color(0xFFB0B0B0), size: 18),
        ],
      ),
    );
  }

  Widget _buildCountryList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: controller.countries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final country = controller.countries[index];
        return _buildCountryCard(country);
      },
    );
  }

  Widget _buildCountryCard(Country country) {
    final isActive = controller.isConnected.value && controller.selectedCountry.value == country;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: _buildFlag(country.flag),
        title: Text(country.name, style: const TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text('${country.locationCount} Locations', style: const TextStyle(color: Color(0xFF666666), fontSize: 13)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _powerButton(isActive, country),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFB0B0B0), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _powerButton(bool isActive, Country country) {
    return GestureDetector(
      onTap: () async {
        if (isActive) {
          controller.disconnect();
        } else {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('VPN Configuration'),
              content: const Text('VPN configuration will be set up. Do you want to continue?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
          if (result == true) {
            controller.selectCountry(country);
            controller.connect();
          }
        }
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1A5CFF) : Colors.white,
          border: Border.all(color: const Color(0xFF1A5CFF), width: 2),
          shape: BoxShape.circle,
          boxShadow: [
            if (isActive)
              const BoxShadow(
                color: Color(0x331A5CFF),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Icon(
          Icons.power_settings_new_rounded,
          color: isActive ? Colors.white : const Color(0xFF1A5CFF),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildFlag(String assetPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        assetPath,
        width: 40,
        height: 28,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 40,
            height: 28,
            color: Colors.grey[300],
            child: const Icon(Icons.flag, color: Colors.grey),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.map_rounded,
            label: 'Countries',
            active: _selectedTab == 0,
            onTap: () => setState(() => _selectedTab = 0),
          ),
          _NavBarItem(
            icon: Icons.wifi_off_rounded,
            label: 'Disconnect',
            active: _selectedTab == 1,
            onTap: () {
              setState(() => _selectedTab = 1);
              controller.disconnect();
            },
          ),
          _NavBarItem(
            icon: Icons.settings,
            label: 'Setting',
            active: _selectedTab == 2,
            onTap: () => setState(() => _selectedTab = 2),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;
  const _NavBarItem({required this.icon, required this.label, this.active = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? Color(0xFF1A5CFF) : Color(0xFFB0B0B0)),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: active ? Color(0xFF1A5CFF) : Color(0xFFB0B0B0),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
} 