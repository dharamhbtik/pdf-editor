import 'package:flutter/material.dart';
import '../models/pdf_document_model.dart';

/// Service to check ATS (Applicant Tracking System) compliance
class AtsComplianceService {
  /// Check if PDF is ATS compliant
  static Future<AtsComplianceResult> checkCompliance(
    PdfDocumentModel document,
  ) async {
    final issues = <String>[];
    final warnings = <String>[];
    final recommendations = <String>[];
    
    // Check 1: Text extractability
    bool hasExtractableText = false;
    for (final page in document.pages) {
      if (page.textElements.isNotEmpty) {
        hasExtractableText = true;
        break;
      }
    }
    
    if (!hasExtractableText) {
      issues.add('No extractable text found. PDF may be image-based.');
      recommendations.add('Ensure PDF contains selectable text, not just images.');
    }
    
    // Check 2: Font usage
    final fonts = <String>{};
    for (final page in document.pages) {
      for (final text in page.textElements) {
        fonts.add(text.fontFamily);
      }
    }
    
    if (fonts.length > 5) {
      warnings.add('Multiple fonts detected (${fonts.length}). Consider using fewer fonts.');
      recommendations.add('Use 2-3 standard fonts for better ATS compatibility.');
    }
    
    // Check 3: Font size
    for (final page in document.pages) {
      for (final text in page.textElements) {
        if (text.fontSize < 10) {
          warnings.add('Small font size detected (${text.fontSize}pt). May be hard to read.');
          recommendations.add('Use font size of at least 10-12pt for body text.');
          break;
        }
      }
    }
    
    // Check 4: Complex formatting
    int complexFormattingCount = 0;
    for (final page in document.pages) {
      // Check for overlapping text elements
      for (int i = 0; i < page.textElements.length; i++) {
        for (int j = i + 1; j < page.textElements.length; j++) {
          if (_elementsOverlap(page.textElements[i], page.textElements[j])) {
            complexFormattingCount++;
          }
        }
      }
    }
    
    if (complexFormattingCount > 5) {
      warnings.add('Complex text layout detected. May cause parsing issues.');
      recommendations.add('Use simple, linear text layout for better ATS compatibility.');
    }
    
    // Check 5: Image-heavy content
    int totalImages = 0;
    int totalTextElements = 0;
    
    for (final page in document.pages) {
      totalImages += page.imageElements.where((img) => !img.isDeleted).length;
      totalTextElements += page.textElements.length;
    }
    
    if (totalImages > totalTextElements) {
      warnings.add('More images than text elements. ATS may not parse correctly.');
      recommendations.add('Ensure important information is in text format, not images.');
    }
    
    // Check 6: Page count
    if (document.pageCount > 3) {
      warnings.add('Document has ${document.pageCount} pages. Consider keeping it concise.');
      recommendations.add('Most ATS systems prefer 1-2 page resumes.');
    }
    
    // Check 7: Standard fonts
    final standardFonts = {
      'Arial',
      'Calibri',
      'Helvetica',
      'Times New Roman',
      'Georgia',
      'Roboto',
      'Verdana',
    };
    
    bool hasNonStandardFont = false;
    for (final font in fonts) {
      if (!standardFonts.any((sf) => font.toLowerCase().contains(sf.toLowerCase()))) {
        hasNonStandardFont = true;
        break;
      }
    }
    
    if (hasNonStandardFont) {
      warnings.add('Non-standard fonts detected. May not render correctly in ATS.');
      recommendations.add('Use standard fonts like Arial, Calibri, or Times New Roman.');
    }
    
    // Check 8: Text alignment
    int centerAlignedCount = 0;
    int rightAlignedCount = 0;
    
    for (final page in document.pages) {
      for (final text in page.textElements) {
        if (text.alignment == TextAlign.center) centerAlignedCount++;
        if (text.alignment == TextAlign.right) rightAlignedCount++;
      }
    }
    
    if (centerAlignedCount > totalTextElements * 0.3) {
      warnings.add('Excessive center alignment detected.');
      recommendations.add('Use left alignment for body text for better ATS parsing.');
    }
    
    // Check 9: Special characters
    bool hasSpecialChars = false;
    for (final page in document.pages) {
      for (final text in page.textElements) {
        if (RegExp(r'[^\x00-\x7F]').hasMatch(text.text)) {
          hasSpecialChars = true;
          break;
        }
      }
      if (hasSpecialChars) break;
    }
    
    if (hasSpecialChars) {
      warnings.add('Special characters or symbols detected.');
      recommendations.add('Use standard ASCII characters when possible.');
    }
    
    // Check 10: Headers and footers
    bool hasHeaderFooter = false;
    for (final page in document.pages) {
      for (final text in page.textElements) {
        // Check if text is in header/footer region (top 50 or bottom 50 points)
        if (text.y < 50 || text.y > page.height - 50) {
          hasHeaderFooter = true;
          break;
        }
      }
      if (hasHeaderFooter) break;
    }
    
    if (hasHeaderFooter) {
      recommendations.add('Headers/footers detected. Ensure they don\'t contain critical information.');
    }
    
    // Determine overall compliance
    final isCompliant = issues.isEmpty && warnings.length < 3;
    
    return AtsComplianceResult(
      isCompliant: isCompliant,
      issues: issues,
      warnings: warnings,
      recommendations: recommendations,
    );
  }
  
  /// Check if two text elements overlap
  static bool _elementsOverlap(PdfTextElement e1, PdfTextElement e2) {
    return !(e1.x + e1.width < e2.x ||
        e2.x + e2.width < e1.x ||
        e1.y + e1.height < e2.y ||
        e2.y + e2.height < e1.y);
  }
  
  /// Get ATS compliance score (0-100)
  static int getComplianceScore(AtsComplianceResult result) {
    int score = 100;
    
    // Deduct points for issues
    score -= result.issues.length * 20;
    
    // Deduct points for warnings
    score -= result.warnings.length * 5;
    
    return score.clamp(0, 100);
  }
  
  /// Get compliance level description
  static String getComplianceLevel(int score) {
    if (score >= 90) return 'Excellent';
    if (score >= 75) return 'Good';
    if (score >= 60) return 'Fair';
    if (score >= 40) return 'Poor';
    return 'Very Poor';
  }
}
