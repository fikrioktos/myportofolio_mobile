import 'package:material_ui/material_ui.dart';

import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Layar detail satu pengalaman kerja yang dipilih dari daftar experience.
///
/// Menampilkan seluruh atribut experience (termasuk field hasil perhitungan
/// server: kategori tampilan, status berjalan, jumlah bintang) dan tombol
/// Hapus untuk pengguna yang sedang login [AuthState] — operasi ini memakai
/// DELETE terautentikasi token lewat [ApiClient.deleteExperience].
class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({required this.experience, super.key});

  final Experience experience;

  Future<void> _confirmDelete(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus experience?'),
        content: Text(
          'Entri "${experience.title}" akan dihapus dari server dan '
          'tidak bisa dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    // Operasi tulis harus terautentikasi.
    if (!await ensureLoggedIn(context)) return;
    if (!context.mounted) return;

    try {
      await context.read<ApiClient>().deleteExperience(
        experience.id!,
        token: context.read<AuthState>().token!,
      );
      if (!context.mounted) return;
      Navigator.pop(context, true);
      messenger.showSnackBar(
        const SnackBar(content: Text('Experience dihapus.')),
      );
    } on ApiException catch (e) {
      if (!context.mounted) return;
      if (e.statusCode == 401) {
        // Sesi kadaluarsa/token invalid: logout lalu minta login ulang.
        await context.read<AuthState>().logout();
        if (!context.mounted) return;
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Sesi berakhir. Login ulang untuk menghapus.'),
            ),
          );
        final ok = await ensureLoggedIn(context);
        if (!context.mounted || !ok) return;
        return _confirmDelete(context);
      }
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Gagal menghapus (HTTP ${e.statusCode}).')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    final categoryLabels = const {
      'internship': 'Internship',
      'research': 'Research',
      'volunteer': 'Volunteer',
      'part-time': 'Part-Time',
      'full-time': 'Full-Time',
      'freelance': 'Freelance',
    };
    final categoryText =
        experience.categoryDisplay ??
        categoryLabels[experience.category] ??
        experience.category;
    final ongoing = experience.isOngoing ?? experience.endedAt == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(experience.title),
        actions: [
          if (isLoggedIn)
            IconButton(
              tooltip: 'Hapus experience',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (experience.thumbnail != null &&
                experience.thumbnail!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  experience.thumbnail!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 180,
                    child: Icon(Icons.image_not_supported_outlined, size: 64),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              experience.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(categoryText, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 16),
            _row('Peran', experience.role),
            if (experience.organization.isNotEmpty)
              _row('Organisasi', experience.organization),
            _row('Deskripsi', experience.description),
            _row('Mulai', experience.startedAt),
            _row(
              'Selesai',
              experience.endedAt ?? (ongoing ? 'Sedang berlangsung' : '-'),
            ),
            _row('Bintang', '${experience.starCount}'),
            if (experience.starredByNames.isNotEmpty)
              _row('Di-star oleh', experience.starredByNames),
            if (experience.organizationUrl != null &&
                experience.organizationUrl!.isNotEmpty)
              _linkTile(
                context,
                'Situs Organisasi',
                experience.organizationUrl!,
              ),
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
