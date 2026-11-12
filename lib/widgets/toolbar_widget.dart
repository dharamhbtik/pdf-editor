import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_editor_provider.dart';

class ToolbarWidget extends StatelessWidget {
  const ToolbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfEditorProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Row(
            children: [
              // Page navigation
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: provider.currentPageIndex > 0
                    ? provider.previousPage
                    : null,
                tooltip: 'Previous Page',
              ),
              
              Text(
                'Page ${provider.currentPageIndex + 1} of ${provider.totalPages}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: provider.currentPageIndex < provider.totalPages - 1
                    ? provider.nextPage
                    : null,
                tooltip: 'Next Page',
              ),
              
              const SizedBox(width: 24),
              
              // Unsaved changes indicator
              if (provider.hasUnsavedChanges)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Unsaved Changes',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              
              const Spacer(),
              
              // Deselect button
              if (provider.selectedTextElement != null ||
                  provider.selectedImageElement != null)
                TextButton.icon(
                  onPressed: provider.deselectAll,
                  icon: const Icon(Icons.clear),
                  label: const Text('Deselect'),
                ),
            ],
          ),
        );
      },
    );
  }
}
