import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_editor_provider.dart';
import '../utils/platform_utils.dart';
import '../widgets/pdf_viewer_widget.dart';
import '../widgets/editor_panel.dart';
import '../widgets/toolbar_widget.dart';
import '../widgets/welcome_screen.dart';
import '../models/pdf_document_model.dart';
import '../services/ats_compliance_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.picture_as_pdf, size: 28),
            const SizedBox(width: 12),
            const Text('PDF Editor Pro'),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                PlatformUtils.platformName,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Consumer<PdfEditorProvider>(
            builder: (context, provider, _) {
              if (provider.currentDocument == null) {
                return const SizedBox.shrink();
              }
              
              return Row(
                children: [
                  // ATS Compliance Button
                  IconButton(
                    icon: const Icon(Icons.verified_user),
                    tooltip: 'Check ATS Compliance',
                    onPressed: () => _showComplianceDialog(context, provider),
                  ),
                  
                  // Save Button
                  IconButton(
                    icon: const Icon(Icons.save_alt),
                    tooltip: 'Save As',
                    onPressed: provider.hasUnsavedChanges
                        ? () => provider.saveAs()
                        : null,
                  ),
                  
                  // Close Button
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Close Document',
                    onPressed: () => _confirmClose(context, provider),
                  ),
                  
                  const SizedBox(width: 8),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<PdfEditorProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading PDF...'),
                ],
              ),
            );
          }
          
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.clearError,
                    child: const Text('Dismiss'),
                  ),
                ],
              ),
            );
          }
          
          if (provider.currentDocument == null) {
            return const WelcomeScreen();
          }
          
          // Main editor layout
          return _buildEditorLayout(context, provider);
        },
      ),
    );
  }
  
  Widget _buildEditorLayout(BuildContext context, PdfEditorProvider provider) {
    final isDesktop = PlatformUtils.isDesktop || PlatformUtils.isWeb;
    
    if (isDesktop) {
      // Desktop/Web layout: Toolbar + Viewer + Editor Panel
      return Column(
        children: [
          const ToolbarWidget(),
          Expanded(
            child: Row(
              children: [
                // PDF Viewer
                const Expanded(
                  flex: 3,
                  child: PdfViewerWidget(),
                ),
                
                // Editor Panel
                if (provider.selectedTextElement != null ||
                    provider.selectedImageElement != null)
                  const SizedBox(
                    width: 350,
                    child: EditorPanel(),
                  ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Mobile layout: Stacked
      return Column(
        children: [
          const ToolbarWidget(),
          const Expanded(
            child: PdfViewerWidget(),
          ),
          
          // Editor Panel (bottom sheet style)
          if (provider.selectedTextElement != null ||
              provider.selectedImageElement != null)
            const SizedBox(
              height: 250,
              child: EditorPanel(),
            ),
        ],
      );
    }
  }
  
  void _confirmClose(BuildContext context, PdfEditorProvider provider) {
    if (provider.hasUnsavedChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text(
            'You have unsaved changes. Are you sure you want to close this document?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                provider.closeDocument();
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } else {
      provider.closeDocument();
    }
  }
  
  void _showComplianceDialog(BuildContext context, PdfEditorProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.verified_user),
            SizedBox(width: 12),
            Text('ATS Compliance Report'),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: provider.complianceResult == null
              ? const Center(child: CircularProgressIndicator())
              : _buildComplianceReport(provider.complianceResult!),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildComplianceReport(AtsComplianceResult result) {
    final score = AtsComplianceService.getComplianceScore(result);
    final level = AtsComplianceService.getComplianceLevel(score);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Score
          Center(
            child: Column(
              children: [
                Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _getScoreColor(score),
                  ),
                ),
                Text(
                  level,
                  style: TextStyle(
                    fontSize: 20,
                    color: _getScoreColor(score),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Issues
          if (result.issues.isNotEmpty) ...[
            const Text(
              'Issues:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            ...result.issues.map((issue) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(child: Text(issue)),
                ],
              ),
            )),
            const SizedBox(height: 16),
          ],
          
          // Warnings
          if (result.warnings.isNotEmpty) ...[
            const Text(
              'Warnings:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            ...result.warnings.map((warning) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(child: Text(warning)),
                ],
              ),
            )),
            const SizedBox(height: 16),
          ],
          
          // Recommendations
          if (result.recommendations.isNotEmpty) ...[
            const Text(
              'Recommendations:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            ...result.recommendations.map((rec) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(child: Text(rec)),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
  
  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 75) return Colors.lightGreen;
    if (score >= 60) return Colors.orange;
    if (score >= 40) return Colors.deepOrange;
    return Colors.red;
  }
}
