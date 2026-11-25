import 'package:flutter/material.dart';

import 'package:myportofolio_mobile/models/project.dart';
import 'package:url_launcher/url_launcher.dart';

/// Layar detail satu proyek yang dipilih dari daftar proyek.
///
/// Menampilkan seluruh atribut proyek; widget gambar/tautan hanya muncul
/// ketika datanya tidak kosong.
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final categoryLabels = const {
      'research': 'Research',
      'course': 'Course Project',
      'competition': 'Competition',
      'personal': 'Personal',
    };

    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              categoryLabels[project.category] ?? project.category,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 16),
            Text(project.description),
            const SizedBox(height: 16),
            _row('Teknologi', project.technologies),
            _row('Mulai', project.startedAt),
            if (project.endedAt != null) _row('Selesai', project.endedAt!),
            if (project.repositoryUrl != null &&
                project.repositoryUrl!.isNotEmpty)
              _linkTile(context, 'Repository', project.repositoryUrl!),
            if (project.reportUrl != null && project.reportUrl!.isNotEmpty)
              _linkTile(context, 'Laporan', project.reportUrl!),
            if (project.deploymentUrl != null &&
                project.deploymentUrl!.isNotEmpty)
              _linkTile(context, 'Deployment', project.deploymentUrl!),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _linkTile(BuildContext context, String label, String url) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.link),
        title: Text(label),
        subtitle: Text(url, overflow: TextOverflow.ellipsis),
        onTap: () {
          // Buka URL di browser eksternal; URL yang tidak valid diabaikan.
          launchUrl(
            Uri.tryParse(url) ?? Uri(),
            mode: LaunchMode.externalApplication,
          );
        },
      ),
    );
  }
}
