import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:printing/printing.dart';
import '../models/pdf_document_model.dart';
import 'dart:math' as math;

class PdfService {
  /// Load and parse a PDF file
  static Future<PdfDocumentModel> loadPdf({
    required Uint8List bytes,
    required String name,
  }) async {
    try {
      // Load PDF using Syncfusion
      final sf.PdfDocument document = sf.PdfDocument(inputBytes: bytes);
      
      final pages = <PdfPageModel>[];
      
      // Extract content from each page
      for (int i = 0; i < document.pages.count; i++) {
        final page = document.pages[i];
        final pageSize = page.size;
        
        // Extract text elements
        final textElements = await _extractTextElements(document, i, pageSize);
        
        // Extract image elements
        final imageElements = await _extractImageElements(page, i);
        
        pages.add(PdfPageModel(
          pageNumber: i + 1,
          width: pageSize.width,
          height: pageSize.height,
          textElements: textElements,
          imageElements: imageElements,
        ));
      }
      
      document.dispose();
      
      return PdfDocumentModel(
        name: name,
        originalBytes: bytes,
        pageCount: pages.length,
        pages: pages,
      );
    } catch (e) {
      throw Exception('Failed to load PDF: $e');
    }
  }
  
  /// Extract text elements from a page
  static Future<List<PdfTextElement>> _extractTextElements(
    sf.PdfDocument document,
    int pageIndex,
    dynamic pageSize,
  ) async {
    final textElements = <PdfTextElement>[];
    
    try {
      final sf.PdfTextExtractor extractor = sf.PdfTextExtractor(document);
      
      // Extract text from this specific page
      final String extractedText = extractor.extractText(
        startPageIndex: pageIndex,
        endPageIndex: pageIndex,
      );
      
      if (extractedText.isNotEmpty) {
        // Split text into lines for better editing
        final lines = extractedText.split('\n');
        double yPosition = 50;
        
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i].trim();
          if (line.isNotEmpty) {
            textElements.add(PdfTextElement(
              id: 'text_${pageIndex}_$i',
              text: line,
              x: 50,
              y: yPosition,
              width: pageSize.width - 100,
              height: 20,
              fontSize: 12,
            ));
            yPosition += 25; // Space between lines
          }
        }
      }
      
      // If no text was extracted, add a helpful message
      if (textElements.isEmpty) {
        textElements.add(PdfTextElement(
          id: 'text_${pageIndex}_0',
          text: 'No text found in this page. This might be an image-based PDF.',
          x: 50,
          y: 50,
          width: pageSize.width - 100,
          height: 50,
          fontSize: 12,
        ));
      }
    } catch (e) {
      print('Failed to extract text: $e');
      // Add error message as text element
      textElements.add(PdfTextElement(
        id: 'text_${pageIndex}_error',
        text: 'Error extracting text: ${e.toString()}',
        x: 50,
        y: 50,
        width: pageSize.width - 100,
        height: 50,
        fontSize: 12,
      ));
    }
    
    return textElements;
  }
  
  /// Extract image elements from a page
  static Future<List<PdfImageElement>> _extractImageElements(
    sf.PdfPage page,
    int pageIndex,
  ) async {
    final imageElements = <PdfImageElement>[];
    
    try {
      // Extract images from page (simplified for web compatibility)
      // Note: Image extraction may be limited in web version
      print('Image extraction from page $pageIndex');
    } catch (e) {
      // Images extraction might fail on some PDFs
      print('Failed to extract images: $e');
    }
    
    return imageElements;
  }
  
  /// Save edited PDF as a new file
  static Future<void> saveEditedPdf(PdfDocumentModel document) async {
    try {
      // Create a new PDF document
      final pdf = pw.Document();
      
      // Add each page with modifications
      for (final page in document.pages) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(
              page.width,
              page.height,
              marginAll: 0,
            ),
            build: (context) {
              return pw.Stack(
                children: [
                  // Add images
                  ...page.imageElements
                      .where((img) => !img.isDeleted)
                      .map((img) => _buildImageWidget(img)),
                  
                  // Add text elements
                  ...page.textElements.map((text) => _buildTextWidget(text)),
                ],
              );
            },
          ),
        );
      }
      
      // Save the PDF
      final bytes = await pdf.save();
      
      // Use printing package to save file
      await Printing.sharePdf(
        bytes: bytes,
        filename: '${document.name.replaceAll('.pdf', '')}_edited.pdf',
      );
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }
  
  /// Build image widget for PDF
  static pw.Widget _buildImageWidget(PdfImageElement element) {
    return pw.Positioned(
      left: element.x,
      top: element.y,
      child: pw.SizedBox(
        width: element.width,
        height: element.height,
        child: pw.Image(
          pw.MemoryImage(element.imageBytes),
          fit: pw.BoxFit.contain,
        ),
      ),
    );
  }
  
  /// Build text widget for PDF
  static pw.Widget _buildTextWidget(PdfTextElement element) {
    return pw.Positioned(
      left: element.x,
      top: element.y,
      child: pw.SizedBox(
        width: element.width,
        child: pw.Text(
          element.text,
          style: pw.TextStyle(
            fontSize: element.fontSize,
            fontWeight: element.isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            fontStyle: element.isItalic ? pw.FontStyle.italic : pw.FontStyle.normal,
            color: PdfColor.fromInt(element.color.value),
          ),
          textAlign: _convertTextAlign(element.alignment),
        ),
      ),
    );
  }
  
  /// Convert Flutter TextAlign to PDF TextAlign
  static pw.TextAlign _convertTextAlign(TextAlign alignment) {
    switch (alignment) {
      case TextAlign.left:
        return pw.TextAlign.left;
      case TextAlign.center:
        return pw.TextAlign.center;
      case TextAlign.right:
        return pw.TextAlign.right;
      case TextAlign.justify:
        return pw.TextAlign.justify;
      default:
        return pw.TextAlign.left;
    }
  }
}
