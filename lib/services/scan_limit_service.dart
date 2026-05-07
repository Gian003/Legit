import 'package:shared_preferences/shared_preferences.dart';

class ScanLimitService {
  static const _keyCount = 'daily_scan_count';
  static const _keyDate  = 'scan_date';
  static const _freeLimit = 10;

  static Future<bool> canScan() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString(_keyDate) ?? '';

    // Reset count if it's a new day
    if (savedDate != today) {
      await prefs.setString(_keyDate, today);
      await prefs.setInt(_keyCount, 0);
      return true;
    }

    final count = prefs.getInt(_keyCount) ?? 0;
    return count < _freeLimit;
  }

  static Future<void> incrementScanCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_keyCount) ?? 0;
    await prefs.setInt(_keyCount, count + 1);
  }

  static Future<int> remainingScans() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString(_keyDate) ?? '';
    if (savedDate != today) return _freeLimit;
    final count = prefs.getInt(_keyCount) ?? 0;
    return (_freeLimit - count).clamp(0, _freeLimit);
  }
}