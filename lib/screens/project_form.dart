import 'package:flutter/material.dart';

import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Opsi kategori sesuai PROJECT_CATEGORIES di model Project Django.
const _categoryChoices = {
  'research': 'Research',
  'course': 'Course Project',
  'competition': 'Competition',
  'personal': 'Personal',
};

/// Regex tanggal ISO 8601 sederhana (yyyy-MM-dd).
final RegExp _dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');

/// Regex URL sederhana: skema http(s) + ada hostnya.
final RegExp _urlRegExp = RegExp(r'^https?://\S+$');

/// Form tambah proyek. Field sesuai ProjectSerializer (Tutorial 07):
/// Title, Description, Category, Tech Stack, Repository URL, Started At,
/// Ended At (opsional), Report URL dan Deployment URL (opsional).
///
/// Simpan mengirim POST terautentikasi token ke /api/v1/projects/.
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _description = "";
  String _category = "personal";
  String _technologies = "";
  String _repositoryUrl = "";
  String _reportUrl = "";
  String _deploymentUrl = "";
  String _startedAt = "";
  String _endedAt = "";
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
      return "$label harus diawali http:// atau https://";
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

    final project = Project(
      title: _title.trim(),
      description: _description.trim(),
      category: _category,
      technologies: _technologies.trim(),
      repositoryUrl: _repositoryUrl.trim().isEmpty
          ? null
          : _repositoryUrl.trim(),
      reportUrl: _reportUrl.trim().isEmpty ? null : _reportUrl.trim(),
      deploymentUrl: _deploymentUrl.trim().isEmpty
          ? null
          : _deploymentUrl.trim(),
      startedAt: _startedAt.trim(),
      endedAt: _endedAt.trim().isEmpty ? null : _endedAt.trim(),
    );

    try {
      final created = await apiClient.createProject(
        project,
        token: authState.token!,
      );
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Proyek berhasil ditambahkan!'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama: ${created.title}'),
                  Text('Kategori: ${_categoryChoices[created.category]}'),
                  Text('Teknologi: ${created.technologies}'),
                  Text('Mulai: ${created.startedAt}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // tutup dialog
                  Navigator.pop(context); // kembali ke layar sebelumnya
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
                'Sesi berakhir. Login ulang untuk menambah proyek.',
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
        title: const Center(child: Text('Add Project Form')),
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
                    hintText: "Nama Proyek",
                    labelText: "Nama Proyek",
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
                    "Nama proyek tidak boleh kosong!",
                  ),
                ),
              ),
              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Deskripsi Proyek",
                    labelText: "Deskripsi Proyek",
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
                    "Deskripsi proyek tidak boleh kosong!",
                  ),
                ),
              ),
              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori Proyek",
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
              // === Technologies ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Flutter, Django, Figma",
                    labelText: "Teknologi yang Digunakan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _technologies = value ?? "";
                    });
                  },
                ),
              ),
              // === Repository URL (opsional, divalidasi formatnya) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://github.com/...",
                    labelText: "Repository URL (opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _repositoryUrl = value ?? "";
                    });
                  },
                  validator: (value) =>
                      _optionalUrlValidator(value, "Repository URL"),
                ),
              ),
              // === Started At (wajib, yyyy-MM-dd) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: 2026-01-01",
                    labelText: "Tanggal Mulai (yyyy-MM-dd)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _startedAt = value ?? "";
                    });
                  },
                  validator: (value) {
                    final missing = _requiredValidator(
                      value,
                      "Tanggal mulai tidak boleh kosong!",
                    );
                    if (missing != null) return missing;
                    if (!_dateRegExp.hasMatch(value!)) {
                      return "Format tanggal harus yyyy-MM-dd";
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
                    hintText: "Kosongkan jika masih berjalan",
                    labelText: "Tanggal Selesai (yyyy-MM-dd, opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _endedAt = value ?? "";
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (!_dateRegExp.hasMatch(value)) {
                      return "Format tanggal harus yyyy-MM-dd";
                    }
                    return null;
                  },
                ),
              ),
              // === Report URL (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://... (opsional)",
                    labelText: "Report URL (opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _reportUrl = value ?? "";
                    });
                  },
                  validator: (value) =>
                      _optionalUrlValidator(value, "Report URL"),
                ),
              ),
              // === Deployment URL (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://... (opsional)",
                    labelText: "Deployment URL (opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _deploymentUrl = value ?? "";
                    });
                  },
                  validator: (value) =>
                      _optionalUrlValidator(value, "Deployment URL"),
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
                            "Save",
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
