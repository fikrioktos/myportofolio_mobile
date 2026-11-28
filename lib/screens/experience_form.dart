import 'package:material_ui/material_ui.dart';

import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Opsi kategori sesuai EXPERIENCE_CHOICES di model Experience Django.
const _categoryChoices = {
  'internship': 'Internship',
  'research': 'Research',
  'volunteer': 'Volunteer',
  'part-time': 'Part-Time',
  'full-time': 'Full-Time',
  'freelance': 'Freelance',
};

/// Regex tanggal ISO 8601 sederhana (yyyy-MM-dd).
final RegExp _dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');

/// Regex URL sederhana: skema http(s) + ada hostnya.
final RegExp _urlRegExp = RegExp(r'^https?://\S+$');

/// Form tambah experience. Field sesuai ExperienceSerializer (Assignment 6):
/// Title, Role, Organization (opsional), Description, Category,
/// Started At, Ended At (opsional), Thumbnail (opsional),
/// Organization URL (opsional).
///
/// Pembukaan dan pengiriman formulir memerlukan autentikasi lewat
/// [ensureLoggedIn]. Simpan mengirim POST terautentikasi token ke
/// /api/v1/experiences/ dan menampilkan SnackBar error (atau logout +
/// login ulang pada 401).
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _role = '';
  String _organization = '';
  String _description = '';
  String _category = 'part-time';
  String _startAt = '';
  String _endAt = '';
  String _thumbnailUrl = '';
  String _organizationUrl = '';
  bool _isSubmitting = false;

  String? _requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  String? _optionalUrlValidator(String? value, String label) {
    if (value == null || value.isEmpty) return null;
    if (!_urlRegExp.hasMatch(value)) {
      return '$label harus diawali http:// atau https://';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Aksi tulis harus terautentikasi.
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final authState = context.read<AuthState>();
    final apiClient = context.read<ApiClient>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isSubmitting = true;
    });

    final experience = Experience(
      title: _title.trim(),
      role: _role.trim(),
      organization: _organization.trim(),
      description: _description.trim(),
      category: _category,
      startedAt: _startAt.trim(),
      endedAt: _endAt.trim().isEmpty ? null : _endAt.trim(),
      thumbnail: _thumbnailUrl.trim().isEmpty ? null : _thumbnailUrl.trim(),
      organizationUrl: _organizationUrl.trim().isEmpty
          ? null
          : _organizationUrl.trim(),
    );

    try {
      final created = await apiClient.createExperience(
        experience,
        token: authState.token!,
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Experience berhasil ditambahkan!'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Judul: ${created.title}'),
                  Text('Peran: ${created.role}'),
                  Text('Kategori: ${_categoryChoices[created.category]}'),
                  Text('Mulai: ${created.startedAt}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // tutup dialog
                  // Kembali ke daftar agar entri baru langsung terlihat.
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExperienceListScreen(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        // Sesi kadaluarsa/token invalid: logout lalu minta login ulang.
        await context.read<AuthState>().logout();
        if (!mounted) return;
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'Sesi berakhir. Login ulang untuk menambah experience.',
              ),
            ),
          );
        final ok = await ensureLoggedIn(context);
        if (!mounted || !ok) return;
        // Setelah login ulang, coba sekali lagi.
        return _submit();
      }
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Gagal menyimpan (HTTP ${e.statusCode}).')),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nama Experience',
                    labelText: 'Judul Experience',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
                    });
                  },
                  validator: (value) => _requiredValidator(
                    value,
                    'Judul experience tidak boleh kosong!',
                  ),
                ),
              ),
              // === Role ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Contoh: Staff IT, Asisten Dosen',
                    labelText: 'Peran',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _role = value!;
                    });
                  },
                  validator: (value) =>
                      _requiredValidator(value, 'Peran tidak boleh kosong!'),
                ),
              ),
              // === Organization (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nama organisasi (opsional)',
                    labelText: 'Organisasi (opsional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _organization = value ?? '';
                    });
                  },
                ),
              ),
              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Deskripsi Experience',
                    labelText: 'Deskripsi Experience',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (value) => _requiredValidator(
                    value,
                    'Deskripsi experience tidak boleh kosong!',
                  ),
                ),
              ),
              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Kategori Experience',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _category,
                  items: _categoryChoices.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),
              // === Started At (wajib, yyyy-MM-dd) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Contoh: 2025-01-01',
                    labelText: 'Tanggal Mulai (yyyy-MM-dd)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _startAt = value ?? '';
                    });
                  },
                  validator: (value) {
                    final missing = _requiredValidator(
                      value,
                      'Tanggal mulai tidak boleh kosong!',
                    );
                    if (missing != null) return missing;
                    if (!_dateRegExp.hasMatch(value!)) {
                      return 'Format tanggal harus yyyy-MM-dd';
                    }
                    return null;
                  },
                ),
              ),
              // === Ended At (opsional, yyyy-MM-dd) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Kosongkan jika masih berjalan',
                    labelText: 'Tanggal Selesai (yyyy-MM-dd, opsional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _endAt = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (!_dateRegExp.hasMatch(value)) {
                      return 'Format tanggal harus yyyy-MM-dd';
                    }
                    return null;
                  },
                ),
              ),
              // === Thumbnail URL (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'https://... (opsional)',
                    labelText: 'Thumbnail URL (opsional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _thumbnailUrl = value ?? '';
                    });
                  },
                  validator: (value) =>
                      _optionalUrlValidator(value, 'Thumbnail URL'),
                ),
              ),
              // === Organization URL (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'https://... (opsional)',
                    labelText: 'Organization URL (opsional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _organizationUrl = value ?? '';
                    });
                  },
                  validator: (value) =>
                      _optionalUrlValidator(value, 'Organization URL'),
                ),
              ),
              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Simpan',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
