import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_editor_provider.dart';

class EditorPanel extends StatelessWidget {
  const EditorPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfEditorProvider>(
      builder: (context, provider, _) {
        if (provider.selectedTextElement != null) {
          return _buildTextEditor(context, provider);
        }
        
        if (provider.selectedImageElement != null) {
          return _buildImageEditor(context, provider);
        }
        
        return const SizedBox.shrink();
      },
    );
  }
  
  Widget _buildTextEditor(BuildContext context, PdfEditorProvider provider) {
    final textElement = provider.selectedTextElement!;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          left: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Text',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Text content
            TextField(
              controller: TextEditingController(text: textElement.text),
              decoration: const InputDecoration(
                labelText: 'Text Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              onChanged: (value) {
                provider.updateTextElement(
                  textElement.copyWith(text: value),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Font size
            Row(
              children: [
                const Text('Font Size:'),
                const SizedBox(width: 12),
                Expanded(
                  child: Slider(
                    value: textElement.fontSize,
                    min: 8,
                    max: 72,
                    divisions: 64,
                    label: textElement.fontSize.toStringAsFixed(0),
                    onChanged: (value) {
                      provider.updateTextElement(
                        textElement.copyWith(fontSize: value),
                      );
                    },
                  ),
                ),
                Text(textElement.fontSize.toStringAsFixed(0)),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Text alignment
            const Text('Alignment:'),
            const SizedBox(height: 8),
            SegmentedButton<TextAlign>(
              segments: const [
                ButtonSegment(
                  value: TextAlign.left,
                  icon: Icon(Icons.format_align_left),
                ),
                ButtonSegment(
                  value: TextAlign.center,
                  icon: Icon(Icons.format_align_center),
                ),
                ButtonSegment(
                  value: TextAlign.right,
                  icon: Icon(Icons.format_align_right),
                ),
                ButtonSegment(
                  value: TextAlign.justify,
                  icon: Icon(Icons.format_align_justify),
                ),
              ],
              selected: {textElement.alignment},
              onSelectionChanged: (Set<TextAlign> newSelection) {
                provider.updateTextElement(
                  textElement.copyWith(alignment: newSelection.first),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Bold and Italic
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Bold'),
                    value: textElement.isBold,
                    onChanged: (value) {
                      provider.updateTextElement(
                        textElement.copyWith(isBold: value),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Italic'),
                    value: textElement.isItalic,
                    onChanged: (value) {
                      provider.updateTextElement(
                        textElement.copyWith(isItalic: value),
                      );
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Delete button
            FilledButton.icon(
              onPressed: () {
                provider.deleteTextElement(textElement.id);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete Text'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildImageEditor(BuildContext context, PdfEditorProvider provider) {
    final imageElement = provider.selectedImageElement!;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          left: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit Image',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Image preview
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.memory(
                imageElement.imageBytes,
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Image info
            Text('Size: ${imageElement.width.toInt()} x ${imageElement.height.toInt()}'),
            
            const SizedBox(height: 24),
            
            // Replace button
            FilledButton.icon(
              onPressed: () {
                provider.replaceImage(imageElement.id);
              },
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Replace Image'),
            ),
            
            const SizedBox(height: 12),
            
            // Delete button
            FilledButton.icon(
              onPressed: () {
                provider.deleteImageElement(imageElement.id);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete Image'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
