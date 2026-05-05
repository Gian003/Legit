import 'package:flutter/material.dart';
import 'package:legit/services/premium_service.dart';

class PaywallDialog extends StatelessWidget {
  const PaywallDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A2E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Column(
              children: [
                Text('⭐', style: TextStyle(fontSize: 40)),
                SizedBox(height: 8),
                Text('Go Premium',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Unlock all features',
                    style: TextStyle(color: Colors.white60, fontSize: 14)),
              ],
            ),
          ),

          // Features list
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _FeatureRow('📷', 'Scan from Gallery',      true),
                _FeatureRow('∞',  'Unlimited daily scans',  true),
                _FeatureRow('📋', 'Full scan history',       true),
                _FeatureRow('📄', 'Export PDF reports',      true),
                const SizedBox(height: 16),
                const Text('₱99 / month',
                    style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                const Text('Cancel anytime',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final success = await PremiumService.upgradeToPremium();
                      if (context.mounted) {
                        Navigator.pop(context, success);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A2E),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Upgrade Now',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Maybe Later',
                      style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String icon, label;
  final bool included;
  const _FeatureRow(this.icon, this.label, this.included);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Icon(
            included ? Icons.check_circle : Icons.cancel,
            color: included ? Colors.green : Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }
}