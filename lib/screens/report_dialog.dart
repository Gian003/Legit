import 'package:flutter/material.dart';
import 'package:legit/models/product_model.dart';

class ReportDialog extends StatefulWidget {
  final Product product;
  const ReportDialog({super.key, required this.product});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String? _selectedReason;
  final _otherController = TextEditingController();
  final _reasons = ['Expired', 'Fake', 'Smuggled'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('What would you like to report it?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chip selector (Expired / Fake / Smuggled)
          Wrap(
            spacing: 8,
            children: _reasons.map((r) => ChoiceChip(
              label: Text(r),
              selected: _selectedReason == r,
              onSelected: (_) => setState(() => _selectedReason = r),
              selectedColor: Colors.red,
              labelStyle: TextStyle(
                color: _selectedReason == r ? Colors.white : Colors.black,
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Other:'),
          const SizedBox(height: 8),
          TextField(
            controller: _otherController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Type here..',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Report', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _submit() {
    // TODO: send report to your backend
    Navigator.pop(context);
    ScaffoldMessenger.of(context.mounted ? context : context)
        .showSnackBar(const SnackBar(content: Text('Report submitted!')));
  }
}