import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_editor_provider.dart';

class PdfViewerWidget extends StatelessWidget {
  const PdfViewerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfEditorProvider>(
      builder: (context, provider, _) {
        final page = provider.currentPage;
        
        if (page == null) {
          return const Center(child: Text('No page to display'));
        }
        
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Container(
                width: page.width,
                height: page.height,
                color: Colors.white,
                child: Stack(
                  children: [
                    // Render text elements
                    ...page.textElements.map((text) => Positioned(
                      left: text.x,
                      top: text.y,
                      width: text.width,
                      child: GestureDetector(
                        onTap: () => provider.selectTextElement(text),
                        child: Container(
                          decoration: BoxDecoration(
                            border: provider.selectedTextElement?.id == text.id
                                ? Border.all(color: Colors.blue, width: 2)
                                : null,
                          ),
                          child: Text(
                            text.text,
                            style: TextStyle(
                              fontSize: text.fontSize,
                              fontFamily: text.fontFamily,
                              fontWeight: text.isBold ? FontWeight.bold : FontWeight.normal,
                              fontStyle: text.isItalic ? FontStyle.italic : FontStyle.normal,
                              color: text.color,
                            ),
                            textAlign: text.alignment,
                          ),
                        ),
                      ),
                    )),
                    
                    // Render image elements
                    ...page.imageElements.where((img) => !img.isDeleted).map((img) => Positioned(
                      left: img.x,
                      top: img.y,
                      width: img.width,
                      height: img.height,
                      child: GestureDetector(
                        onTap: () => provider.selectImageElement(img),
                        child: Container(
                          decoration: BoxDecoration(
                            border: provider.selectedImageElement?.id == img.id
                                ? Border.all(color: Colors.blue, width: 2)
                                : null,
                          ),
                          child: Image.memory(
                            img.imageBytes,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
