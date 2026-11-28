import 'package:material_ui/material_ui.dart';

import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Layar daftar pengalaman kerja yang datanya diambil langsung dari backend DRF.
///
/// Future diinisialisasi di [initState] (bukan di [build]) agar request HTTP
/// tidak dikirim ulang setiap widget dibangun ulang. Getter publik [reload]
/// dipakai tombol Retry, pull-to-refresh, dan setelah kembali dari layar
/// lain (mis. setelah tambah/hapus entri).
class ExperienceListScreen extends StatefulWidget {
  const ExperienceListScreen({super.key});

  @override
  State<ExperienceListScreen> createState() => _ExperienceListScreenState();
}

class _ExperienceListScreenState extends State<ExperienceListScreen> {
  late Future<List<Experience>> _experiencesFuture;

  @override
  void initState() {
    super.initState();
    _experiencesFuture = context.read<ApiClient>().getExperiences();
  }

  Future<void> _reload() async {
    final future = context.read<ApiClient>().getExperiences();
    setState(() {
      _experiencesFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Experience')),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Experience>>(
        future: _experiencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gagal memuat experience: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final experiences = snapshot.data ?? const <Experience>[];
          if (experiences.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(child: Text('Tidak ada experience.')),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              itemCount: experiences.length,
              itemBuilder: (context, index) {
                final experience = experiences[index];
                return Card(
                  child: ListTile(
                    title: Text(experience.title),
                    subtitle: Text(
                      [
                        experience.role,
                        if (experience.organization.isNotEmpty)
                          experience.organization,
                      ].join(' • '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExperienceDetailScreen(experience: experience),
                        ),
                      );
                      // Muat ulang saat kembali dari detail — entri baru
                      // atau yang baru dihapus langsung tampak.
                      if (mounted) await _reload();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
