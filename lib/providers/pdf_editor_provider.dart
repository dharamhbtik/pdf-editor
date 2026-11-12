import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import '../models/pdf_document_model.dart';
import '../services/pdf_service.dart';
import '../services/ats_compliance_service.dart';

class PdfEditorProvider extends ChangeNotifier {
  PdfDocumentModel? _currentDocument;
  int _currentPageIndex = 0;
  String? _errorMessage;
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;
  PdfTextElement? _selectedTextElement;
  PdfImageElement? _selectedImageElement;
  AtsComplianceResult? _complianceResult;
  
  // Getters
  PdfDocumentModel? get currentDocument => _currentDocument;
  int get currentPageIndex => _currentPageIndex;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get hasUnsavedChanges => _hasUnsavedChanges;
  PdfTextElement? get selectedTextElement => _selectedTextElement;
  PdfImageElement? get selectedImageElement => _selectedImageElement;
  AtsComplianceResult? get complianceResult => _complianceResult;
  
  PdfPageModel? get currentPage {
    if (_currentDocument == null || _currentPageIndex >= _currentDocument!.pages.length) {
      return null;
    }
    return _currentDocument!.pages[_currentPageIndex];
  }
  
  int get totalPages => _currentDocument?.pageCount ?? 0;
  
  /// Load a PDF file
  Future<void> loadPdfFile() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );
      
      if (result != null && result.files.first.bytes != null) {
        final file = result.files.first;
        _currentDocument = await PdfService.loadPdf(
          bytes: file.bytes!,
          name: file.name,
        );
        _currentPageIndex = 0;
        _hasUnsavedChanges = false;
        _selectedTextElement = null;
        _selectedImageElement = null;
        
        // Run ATS compliance check
        await checkAtsCompliance();
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load PDF: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Navigate to specific page
  void goToPage(int pageIndex) {
    if (_currentDocument != null && 
        pageIndex >= 0 && 
        pageIndex < _currentDocument!.pageCount) {
      _currentPageIndex = pageIndex;
      _selectedTextElement = null;
      _selectedImageElement = null;
      notifyListeners();
    }
  }
  
  /// Navigate to next page
  void nextPage() {
    if (_currentPageIndex < totalPages - 1) {
      goToPage(_currentPageIndex + 1);
    }
  }
  
  /// Navigate to previous page
  void previousPage() {
    if (_currentPageIndex > 0) {
      goToPage(_currentPageIndex - 1);
    }
  }
  
  /// Select a text element for editing
  void selectTextElement(PdfTextElement element) {
    _selectedTextElement = element;
    _selectedImageElement = null;
    notifyListeners();
  }
  
  /// Select an image element for editing
  void selectImageElement(PdfImageElement element) {
    _selectedImageElement = element;
    _selectedTextElement = null;
    notifyListeners();
  }
  
  /// Deselect all elements
  void deselectAll() {
    _selectedTextElement = null;
    _selectedImageElement = null;
    notifyListeners();
  }
  
  /// Update text element
  void updateTextElement(PdfTextElement updatedElement) {
    if (_currentDocument == null || currentPage == null) return;
    
    final pageIndex = _currentPageIndex;
    final page = currentPage!;
    
    final updatedTextElements = page.textElements.map((element) {
      return element.id == updatedElement.id ? updatedElement : element;
    }).toList();
    
    final updatedPage = page.copyWith(textElements: updatedTextElements);
    _updatePage(pageIndex, updatedPage);
    _hasUnsavedChanges = true;
    _selectedTextElement = updatedElement;
    notifyListeners();
  }
  
  /// Delete text element
  void deleteTextElement(String elementId) {
    if (_currentDocument == null || currentPage == null) return;
    
    final pageIndex = _currentPageIndex;
    final page = currentPage!;
    
    final updatedTextElements = page.textElements
        .where((element) => element.id != elementId)
        .toList();
    
    final updatedPage = page.copyWith(textElements: updatedTextElements);
    _updatePage(pageIndex, updatedPage);
    _hasUnsavedChanges = true;
    _selectedTextElement = null;
    notifyListeners();
  }
  
  /// Update image element
  void updateImageElement(PdfImageElement updatedElement) {
    if (_currentDocument == null || currentPage == null) return;
    
    final pageIndex = _currentPageIndex;
    final page = currentPage!;
    
    final updatedImageElements = page.imageElements.map((element) {
      return element.id == updatedElement.id ? updatedElement : element;
    }).toList();
    
    final updatedPage = page.copyWith(imageElements: updatedImageElements);
    _updatePage(pageIndex, updatedPage);
    _hasUnsavedChanges = true;
    _selectedImageElement = updatedElement;
    notifyListeners();
  }
  
  /// Delete image element
  void deleteImageElement(String elementId) {
    if (_currentDocument == null || currentPage == null) return;
    
    final pageIndex = _currentPageIndex;
    final page = currentPage!;
    
    final updatedImageElements = page.imageElements.map((element) {
      if (element.id == elementId) {
        return element.copyWith(isDeleted: true);
      }
      return element;
    }).toList();
    
    final updatedPage = page.copyWith(imageElements: updatedImageElements);
    _updatePage(pageIndex, updatedPage);
    _hasUnsavedChanges = true;
    _selectedImageElement = null;
    notifyListeners();
  }
  
  /// Replace image element
  Future<void> replaceImage(String elementId) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      
      if (result != null && result.files.first.bytes != null) {
        final imageBytes = result.files.first.bytes!;
        
        if (_currentDocument == null || currentPage == null) return;
        
        final pageIndex = _currentPageIndex;
        final page = currentPage!;
        
        final updatedImageElements = page.imageElements.map((element) {
          if (element.id == elementId) {
            return element.copyWith(imageBytes: imageBytes);
          }
          return element;
        }).toList();
        
        final updatedPage = page.copyWith(imageElements: updatedImageElements);
        _updatePage(pageIndex, updatedPage);
        _hasUnsavedChanges = true;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to replace image: $e';
      notifyListeners();
    }
  }
  
  /// Save edited PDF as new file
  Future<void> saveAs() async {
    if (_currentDocument == null) return;
    
    try {
      _isLoading = true;
      notifyListeners();
      
      await PdfService.saveEditedPdf(_currentDocument!);
      _hasUnsavedChanges = false;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to save PDF: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Check ATS compliance
  Future<void> checkAtsCompliance() async {
    if (_currentDocument == null) return;
    
    try {
      _complianceResult = await AtsComplianceService.checkCompliance(_currentDocument!);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to check ATS compliance: $e';
      notifyListeners();
    }
  }
  
  /// Close current document
  void closeDocument() {
    _currentDocument = null;
    _currentPageIndex = 0;
    _hasUnsavedChanges = false;
    _selectedTextElement = null;
    _selectedImageElement = null;
    _complianceResult = null;
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Helper method to update a page
  void _updatePage(int pageIndex, PdfPageModel updatedPage) {
    if (_currentDocument == null) return;
    
    final updatedPages = List<PdfPageModel>.from(_currentDocument!.pages);
    updatedPages[pageIndex] = updatedPage;
    
    _currentDocument = PdfDocumentModel(
      name: _currentDocument!.name,
      originalBytes: _currentDocument!.originalBytes,
      pageCount: _currentDocument!.pageCount,
      pages: updatedPages,
    );
  }
  
  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
