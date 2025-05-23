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
  Map<int, bool> expandedCountries = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : const Color(0xFF666666);
    final borderColor = isDark ? Colors.grey[700]! : const Color(0xFF1A5CFF);
    final iconColor = isDark ? Colors.white : const Color(0xFF1A5CFF);
    return Scaffold(
      backgroundColor: scaffoldBg,
      bottomNavigationBar: _buildBottomNavBar(context, iconColor),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: _selectedTab == 2
              ? const SettingsScreen(key: ValueKey('settings'))
              : Column(
                  key: ValueKey('main'),
                  children: [
                    _buildHeader(isDark),
                    _buildSearchBar(cardColor, textColor, iconColor),
                    Obx(() {
                      if (controller.isConnecting.value) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Column(
                            children: [
                              CircularProgressIndicator(color: iconColor),
                              const SizedBox(height: 16),
                              Text('Connecting...', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      } else if (controller.isConnected.value) {
                        return _buildConnectionCard(cardColor, textColor, subTextColor, iconColor);
                      } else {
                        return const SizedBox(height: 24);
                      }
                    }),
                    _buildFreeLocationsTitle(textColor, subTextColor),
                    Expanded(child: Obx(() => _buildCountryList(cardColor, textColor, subTextColor, borderColor, iconColor))),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF23242B), const Color(0xFF181A20)]
              : [const Color(0xFF1A5CFF), const Color(0xFF3A7BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleIcon(Icons.grid_view_rounded, isDark),
          Text(
            'Countries',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          _circleIcon(Icons.emoji_events_outlined, isDark),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isDark ? 0.08 : 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
  Widget _buildSearchBar(Color cardColor, Color textColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: cardColor,
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
              style: TextStyle(fontSize: 16, color: textColor),
              decoration: InputDecoration(
                hintText: 'Search For Country Or City',
                hintStyle: TextStyle(color: iconColor.withOpacity(0.5), fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.search, color: iconColor, size: 26),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(Color cardColor, Color textColor, Color? subTextColor, Color iconColor) {
    final download = controller.connectionStats.value?.downloadSpeed ?? 0;
    final upload = controller.connectionStats.value?.uploadSpeed ?? 0;
    final maxSpeed = 1000.0;
    final country = controller.connectionStats.value?.connectedCountry;
    final city = controller.connectedLocation.value?.name ?? '';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: cardColor,
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
          Text(
            'Connecting Time',
            style: TextStyle(
              color: subTextColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => Text(
                controller.getFormattedConnectionTime(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              )),
          const SizedBox(height: 18),
          Row(
            children: [
              _buildFlag(country?.flag ?? ''),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country?.name ?? '',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      city,
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Stealth', style: TextStyle(color: subTextColor, fontSize: 13)),
                  Obx(() => Text(
                        '${controller.connectionStats.value?.connectedCountry.strength ?? 0}%',
                        style: TextStyle(
                          color: iconColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          _AnimatedSpeedBar(
            label: 'Download',
            value: download,
            max: maxSpeed,
            color: const Color(0xFF3DD598),
            textColor: textColor,
            subTextColor: subTextColor,
            icon: Icons.download_rounded,
          ),
          const SizedBox(height: 12),
          _AnimatedSpeedBar(
            label: 'Upload',
            value: upload,
            max: maxSpeed,
            color: const Color(0xFFFF6B6B),
            textColor: textColor,
            subTextColor: subTextColor,
            icon: Icons.upload_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color iconColor, Color textColor, Color? subTextColor) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: subTextColor, fontSize: 13)),
              Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFreeLocationsTitle(Color textColor, Color? subTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: Row(
        children: [
          Text(
            'Free Locations',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => Text('(${controller.countries.length})', style: TextStyle(color: subTextColor))),
          const Spacer(),
          Icon(Icons.info_outline, color: subTextColor, size: 18),
        ],
      ),
    );
  }

  Widget _buildCountryList(Color cardColor, Color textColor, Color? subTextColor, Color borderColor, Color iconColor) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: controller.countries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final country = controller.countries[index];
        final isExpanded = expandedCountries[index] ?? false;
        return Column(
          children: [
            _buildCountryCard(country, cardColor, textColor, subTextColor, borderColor, iconColor, index, isExpanded),
            if (isExpanded) _buildLocationList(country, cardColor, textColor, subTextColor, iconColor),
          ],
        );
      },
    );
  }

  Widget _buildCountryCard(Country country, Color cardColor, Color textColor, Color? subTextColor, Color borderColor, Color iconColor, int index, bool isExpanded) {
    final isActive = controller.isConnected.value && controller.selectedCountry.value == country;
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
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
        title: Text(country.name, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text('${country.locations.length} Locations', style: TextStyle(color: subTextColor, fontSize: 13)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _powerButton(isActive, country, borderColor, iconColor, cardColor),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  expandedCountries[index] = !(expandedCountries[index] ?? false);
                });
              },
              child: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(Icons.arrow_forward_ios_rounded, color: subTextColor, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationList(Country country, Color cardColor, Color textColor, Color? subTextColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: country.locations.map((location) {
          return ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            leading: Icon(
              location.isFree ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
              color: location.isFree ? Colors.green : Colors.red,
              size: 20,
            ),
            title: Text(location.name, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
            trailing: location.isFree
                ? (controller.connectedLocation.value?.name == location.name && controller.isConnected.value
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          minimumSize: const Size(40, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          shadowColor: Colors.grey.withOpacity(0.18),
                        ),
                        onPressed: null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check_circle, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text('Connected', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      )
                    : _ModernConnectButton(
                        onTap: () async {
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
                            await controller.connect(location: location);
                          }
                        },
                      ))
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Pro', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
          );
        }).toList(),
      ),
    );
  }

  Widget _powerButton(bool isActive, Country country, Color borderColor, Color iconColor, Color cardColor) {
    return GestureDetector(
      onTap: () async {
        if (isActive) {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Disconnect VPN'),
              content: const Text('Are you sure you want to disconnect the VPN?'),
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
            await _showDisconnectingAnimation();
            controller.disconnect();
          }
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
          color: isActive ? iconColor : cardColor,
          border: Border.all(color: borderColor, width: 2),
          shape: BoxShape.circle,
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: iconColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Icon(
          Icons.power_settings_new_rounded,
          color: isActive ? cardColor : iconColor,
          size: 20,
        ),
      ),
    );
  }

  Future<void> _showDisconnectingAnimation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              const Text('Disconnecting...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context, rootNavigator: true).pop();
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

  Widget _buildBottomNavBar(BuildContext context, Color iconColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: const [
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
            iconColor: iconColor,
          ),
          _NavBarItem(
            icon: Icons.wifi_off_rounded,
            label: 'Disconnect',
            active: _selectedTab == 1,
            onTap: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Disconnect VPN'),
                  content: const Text('Are you sure you want to disconnect the VPN?'),
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
                await _showDisconnectingAnimation();
                controller.disconnect();
              } else {
                setState(() => _selectedTab = 0);
              }
            },
            iconColor: iconColor,
          ),
          _NavBarItem(
            icon: Icons.settings,
            label: 'Setting',
            active: _selectedTab == 2,
            onTap: () => setState(() => _selectedTab = 2),
            iconColor: iconColor,
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
  final Color iconColor;
  const _NavBarItem({required this.icon, required this.label, this.active = false, this.onTap, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? iconColor : const Color(0xFFB0B0B0)),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: active ? iconColor : const Color(0xFFB0B0B0),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedSpeedBar extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final Color color;
  final Color textColor;
  final Color? subTextColor;
  final IconData icon;
  const _AnimatedSpeedBar({
    required this.label,
    required this.value,
    required this.max,
    required this.color,
    required this.textColor,
    required this.subTextColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: subTextColor, fontSize: 13)),
            const Spacer(),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: value),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, animatedValue, child) {
                return Text(
                  '${animatedValue.toStringAsFixed(0)} MB',
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: (value / max).clamp(0.0, 1.0)),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, animatedValue, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: animatedValue,
                minHeight: 10,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ModernConnectButton extends StatefulWidget {
  final Future<void> Function() onTap;
  const _ModernConnectButton({required this.onTap, Key? key}) : super(key: key);

  @override
  State<_ModernConnectButton> createState() => _ModernConnectButtonState();
}

class _ModernConnectButtonState extends State<_ModernConnectButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: const Size(40, 32),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        shadowColor: Colors.green.withOpacity(0.18),
      ),
      onPressed: () async {
        if (_loading) return;
        setState(() => _loading = true);
        await widget.onTap();
        setState(() => _loading = false);
      },
      child: _loading
          ? const SizedBox(width: 24, height: 18, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))))
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.power_settings_new_rounded, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text('Connect', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
    );
  }
} 