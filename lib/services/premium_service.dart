import 'package:shared_preferences/shared_preferences.dart';

class PremiumService {
  static const _keyPremium = 'is_premium';

  static Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPremium) ?? false;
  }

  static Future<bool> upgradeToPremium() async {
    final prefs = await SharedPreferences.getInstance();
    // TODO: trigger real payment flow here
    await prefs.setBool(_keyPremium, true);
    return true;
  }

  static Future<void> cancelPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPremium, false);
  }
}