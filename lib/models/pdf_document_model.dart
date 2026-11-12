import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Represents a PDF document being edited
class PdfDocumentModel {
  final String name;
  final Uint8List originalBytes;
  final int pageCount;
  final List<PdfPageModel> pages;
  
  PdfDocumentModel({
    required this.name,
    required this.originalBytes,
    required this.pageCount,
    required this.pages,
  });
}

/// Represents a single page in the PDF
class PdfPageModel {
  final int pageNumber;
  final double width;
  final double height;
  final List<PdfTextElement> textElements;
  final List<PdfImageElement> imageElements;
  
  PdfPageModel({
    required this.pageNumber,
    required this.width,
    required this.height,
    this.textElements = const [],
    this.imageElements = const [],
  });
  
  PdfPageModel copyWith({
    List<PdfTextElement>? textElements,
    List<PdfImageElement>? imageElements,
  }) {
    return PdfPageModel(
      pageNumber: pageNumber,
      width: width,
      height: height,
      textElements: textElements ?? this.textElements,
      imageElements: imageElements ?? this.imageElements,
    );
  }
}

/// Represents a text element in the PDF
class PdfTextElement {
  final String id;
  final String text;
  final double x;
  final double y;
  final double width;
  final double height;
  final String fontFamily;
  final double fontSize;
  final TextAlign alignment;
  final Color color;
  final bool isBold;
  final bool isItalic;
  
  PdfTextElement({
    required this.id,
    required this.text,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.fontFamily = 'Roboto',
    this.fontSize = 12.0,
    this.alignment = TextAlign.left,
    this.color = const Color(0xFF000000),
    this.isBold = false,
    this.isItalic = false,
  });
  
  PdfTextElement copyWith({
    String? text,
    double? x,
    double? y,
    double? width,
    double? height,
    String? fontFamily,
    double? fontSize,
    TextAlign? alignment,
    Color? color,
    bool? isBold,
    bool? isItalic,
  }) {
    return PdfTextElement(
      id: id,
      text: text ?? this.text,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      alignment: alignment ?? this.alignment,
      color: color ?? this.color,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
    );
  }
}

/// Represents an image element in the PDF
class PdfImageElement {
  final String id;
  final Uint8List imageBytes;
  final double x;
  final double y;
  final double width;
  final double height;
  final bool isDeleted;
  
  PdfImageElement({
    required this.id,
    required this.imageBytes,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.isDeleted = false,
  });
  
  PdfImageElement copyWith({
    Uint8List? imageBytes,
    double? x,
    double? y,
    double? width,
    double? height,
    bool? isDeleted,
  }) {
    return PdfImageElement(
      id: id,
      imageBytes: imageBytes ?? this.imageBytes,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

/// ATS Compliance check result
class AtsComplianceResult {
  final bool isCompliant;
  final List<String> issues;
  final List<String> warnings;
  final List<String> recommendations;
  
  AtsComplianceResult({
    required this.isCompliant,
    this.issues = const [],
    this.warnings = const [],
    this.recommendations = const [],
  });
}
