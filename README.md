# PDF Editor Pro

A comprehensive cross-platform PDF editor built with Flutter for Mobile, Web, and Desktop platforms.

## Features

### 🎯 Core Functionality
- **PDF Loading**: Open and view PDF files from any source
- **Text Editing**: Edit text content directly in the PDF
- **Image Management**: Delete, remove, or replace images
- **Text Alignment**: Change text alignment (left, center, right, justify)
- **Non-Destructive Editing**: Original file remains untouched
- **Save As**: Export edited PDF as a new file
- **ATS Compliance**: Check and ensure ATS (Applicant Tracking System) compatibility

### 📝 Text Editing Features
- Edit existing text content
- Change font size
- Modify text alignment
- Bold and italic formatting
- Text color modification
- Delete text elements

### 🖼️ Image Editing Features
- Delete images from PDF
- Replace images with new ones
- Reposition images
- Resize images

### ✅ ATS Compliance Checking
- Text extractability verification
- Font usage analysis
- Font size validation
- Layout complexity detection
- Image-to-text ratio check
- Standard font recommendations
- Compliance score (0-100)
- Detailed recommendations

## Platform Support

- ✅ **Web**: Full support
- ✅ **Android**: Full support
- ✅ **iOS**: Full support
- ✅ **Windows**: Full support
- ✅ **macOS**: Full support
- ✅ **Linux**: Full support

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- For mobile: Android Studio / Xcode
- For desktop: Platform-specific build tools

### Installation

1. **Navigate to project directory**:
   ```bash
   cd /Users/dkumar/CascadeProjects/pdf_editor
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   
   **For Web:**
   ```bash
   flutter run -d chrome
   ```
   
   **For Mobile:**
   ```bash
   flutter run -d <device_id>
   ```
   
   **For Desktop:**
   ```bash
   # Windows
   flutter run -d windows
   
   # macOS
   flutter run -d macos
   
   # Linux
   flutter run -d linux
   ```

## Usage Guide

### Loading a PDF

1. Click "Open PDF" button
2. Select a PDF file from your device
3. PDF will load and display the first page

### Editing Text

1. Click on any text element to select it
2. Edit panel appears on the right (desktop) or bottom (mobile)
3. Modify text content, alignment, size, or style
4. Changes apply immediately

### Managing Images

1. Click on an image to select it
2. Options appear:
   - **Delete**: Remove the image
   - **Replace**: Choose a new image
   - **Resize**: Drag corners to resize

### Checking ATS Compliance

1. Click "Check ATS Compliance" button
2. View compliance score and detailed report
3. Follow recommendations to improve compliance

### Saving Your Work

1. Click "Save As" button
2. Choose save location
3. New PDF file is created with your edits
4. Original file remains unchanged

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   └── pdf_document_model.dart       # Data models
├── providers/
│   └── pdf_editor_provider.dart      # State management
├── screens/
│   ├── home_screen.dart              # Main screen
│   ├── pdf_viewer_screen.dart        # PDF viewing
│   └── editor_screen.dart            # Editing interface
├── services/
│   ├── pdf_service.dart              # PDF operations
│   └── ats_compliance_service.dart   # ATS checking
├── widgets/
│   ├── text_editor_panel.dart        # Text editing UI
│   ├── image_editor_panel.dart       # Image editing UI
│   ├── toolbar.dart                  # Main toolbar
│   └── compliance_report.dart        # ATS report display
└── utils/
    └── platform_utils.dart           # Platform detection
```

## Technical Details

### Dependencies
- **pdf**: PDF generation
- **printing**: PDF saving and sharing
- **syncfusion_flutter_pdf**: PDF parsing and manipulation
- **file_picker**: File selection
- **provider**: State management
- **flutter_screenutil**: Responsive UI

### PDF Processing
1. **Loading**: Uses Syncfusion PDF library to parse PDF structure
2. **Extraction**: Extracts text and images with position data
3. **Editing**: Maintains element positions and properties
4. **Saving**: Generates new PDF with modifications using pdf package

### ATS Compliance Checks
1. Text extractability
2. Font usage (standard fonts preferred)
3. Font size (minimum 10pt recommended)
4. Layout complexity
5. Image-to-text ratio
6. Page count
7. Special characters
8. Text alignment
9. Headers/footers
10. Overall structure

## Limitations

### Current Version
- SVG images not supported
- Complex PDF forms may not edit correctly
- Encrypted PDFs require password
- Very large PDFs (>50MB) may be slow

### Platform-Specific
- **Web**: File system access limited
- **Mobile**: Screen size constraints for detailed editing
- **Desktop**: Best experience with larger screens

## Performance

### Recommended Specifications
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 100MB free space
- **Screen**: 1280x720 minimum resolution

### File Size Limits
- **Optimal**: < 10MB
- **Good**: 10-25MB
- **Acceptable**: 25-50MB
- **Slow**: > 50MB

## Troubleshooting

### PDF Won't Load
- Check file is valid PDF
- Ensure file isn't corrupted
- Try with smaller PDF first
- Check file permissions

### Text Not Editable
- Some PDFs have text as images
- Scanned documents need OCR first
- Check ATS compliance report

### Images Not Showing
- Image format may not be supported
- PDF may use external image references
- Try re-saving PDF in different viewer

### Save Fails
- Check storage permissions
- Ensure enough disk space
- Try different save location
- Check file name is valid

## Future Enhancements

- [ ] OCR for scanned PDFs
- [ ] Advanced text formatting
- [ ] Table editing
- [ ] Form field editing
- [ ] Digital signatures
- [ ] PDF merging/splitting
- [ ] Watermark addition
- [ ] Password protection
- [ ] Batch processing
- [ ] Cloud storage integration

## ATS Compliance Guide

### What is ATS?
Applicant Tracking Systems (ATS) are software used by employers to parse and rank resumes. ATS-compliant PDFs ensure your document is correctly read by these systems.

### Best Practices
1. **Use Standard Fonts**: Arial, Calibri, Times New Roman
2. **Simple Layout**: Avoid complex formatting
3. **Left Alignment**: Use for body text
4. **Readable Font Size**: 10-12pt minimum
5. **Text Over Images**: Important info should be text
6. **Standard Sections**: Clear headings
7. **No Headers/Footers**: For critical information
8. **ASCII Characters**: Avoid special symbols
9. **1-2 Pages**: Keep it concise
10. **Test Before Sending**: Use compliance checker

### Compliance Score
- **90-100**: Excellent - Ready to submit
- **75-89**: Good - Minor improvements needed
- **60-74**: Fair - Several issues to address
- **40-59**: Poor - Major revisions required
- **0-39**: Very Poor - Significant problems

## License

This project is open source and available for personal and commercial use.

## Support

For issues, questions, or contributions, please refer to the project repository.

---

**Built with Flutter** 💙 | **Cross-Platform PDF Editing** 📄 | **ATS Compliant** ✅
