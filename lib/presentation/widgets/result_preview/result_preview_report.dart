import 'package:appear_ai_image_editor/presentation/widgets/snack_bar_message.dart';
import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  const ReportButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.report, color: Colors.white),
      tooltip: "Report Issue",
      onPressed: () => _showReportDialog(context),
    );
  }

  void _showReportDialog(BuildContext context) {
    List<String> reportOptions = [
      "NSFW Content",
      "Image not loading",
      "Incorrect generation",
      "Poor quality image",
      "Other"
    ];
    String? selectedOption;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Report Issue"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Select the issue you encountered:"),
                  const SizedBox(height: 12),
                  ...reportOptions.map((option) {
                    return RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: selectedOption == null
                      ? null // Disable button if no option selected
                      : () {
                    // Handle sending the report
                    _sendReport(selectedOption!, context);
                  },
                  child: const Text("Send"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _sendReport(String reportType, BuildContext context) {
    Navigator.of(context).pop(); // Close the dialog
    showSnackBarMessage(
      title: 'Report',
      message: "Report submitted for: $reportType",
    );
  }
}
