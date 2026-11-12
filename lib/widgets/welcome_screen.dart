import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/pdf_editor_provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.filePdf,
                size: 80,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Title
            Text(
              'PDF Editor Pro',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Subtitle
            Text(
              'Edit PDF text, manage images, and ensure ATS compliance',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 48),
            
            // Open PDF Button
            FilledButton.icon(
              onPressed: () {
                context.read<PdfEditorProvider>().loadPdfFile();
              },
              icon: const Icon(Icons.folder_open),
              label: const Text('Open PDF File'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Features
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                _buildFeatureCard(
                  context,
                  icon: Icons.edit,
                  title: 'Edit Text',
                  description: 'Modify text content and formatting',
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.image,
                  title: 'Manage Images',
                  description: 'Delete, replace, or reposition images',
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.format_align_left,
                  title: 'Text Alignment',
                  description: 'Change text alignment and style',
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.verified_user,
                  title: 'ATS Compliant',
                  description: 'Check and ensure ATS compatibility',
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.save_alt,
                  title: 'Non-Destructive',
                  description: 'Original file remains untouched',
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.devices,
                  title: 'Cross-Platform',
                  description: 'Works on mobile, web, and desktop',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
