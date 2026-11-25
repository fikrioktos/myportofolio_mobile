import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambahkan sertifikasi baru.
///
/// StatefulWidget karena nilai isian dan tanggal yang dipilih berubah
/// selama pengguna mengetik. Validasi dijalankan lewat [GlobalKey] pada
/// [Form] saat tombol Simpan ditekan.
class CertificationFormPage extends StatefulWidget {
  const CertificationFormPage({super.key});

  @override
  State<CertificationFormPage> createState() => _CertificationFormPageState();
}

class _CertificationFormPageState extends State<CertificationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _issuedController = TextEditingController();
  final _expiredController = TextEditingController();

  String _name = "";
  String _issuer = "";
  String _credentialUrl = "";
  DateTime? _issuedDate;
  DateTime? _expiredDate;

  @override
  void dispose() {
    _issuedController.dispose();
    _expiredController.dispose();
    super.dispose();
  }

  /// Mengubah [date] menjadi teks dd/MM/yyyy untuk ditampilkan di kolom tanggal.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Membuka date picker dan menyimpan tanggal yang dipilih ke [controller].
  Future<DateTime?> _pickDate(
    TextEditingController controller,
    DateTime? initial,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = _formatDate(picked);
      });
    }
    return picked;
  }

  /// Mengosongkan seluruh isian dan tanggal setelah dialog ditutup.
  void _resetForm() {
    _formKey.currentState!.reset();
    _issuedController.clear();
    _expiredController.clear();
    setState(() {
      _name = "";
      _issuer = "";
      _credentialUrl = "";
      _issuedDate = null;
      _expiredDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Certification Form',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        // Tombol reset mengosongkan seluruh isian dan menghapus pesan error.
        actions: [
          IconButton(
            tooltip: 'Reset formulir',
            icon: const Icon(Icons.refresh),
            onPressed: _resetForm,
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Nama Sertifikasi ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 100,
                  decoration: InputDecoration(
                    hintText: "Contoh: Google Data Analytics",
                    labelText: "Nama Sertifikasi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _name = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama sertifikasi tidak boleh kosong!";
                    }
                    if (value.trim().length > 100) {
                      return "Nama sertifikasi maksimal 100 karakter!";
                    }
                    return null;
                  },
                ),
              ),
              // === Lembaga Penerbit ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Coursera, Dicoding",
                    labelText: "Lembaga Penerbit",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _issuer = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Lembaga penerbit tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // === Tanggal Terbit ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _issuedController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Pilih tanggal",
                    labelText: "Tanggal Terbit",
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onTap: () async {
                    final picked = await _pickDate(
                      _issuedController,
                      _issuedDate,
                    );
                    if (picked != null) {
                      setState(() {
                        _issuedDate = picked;
                      });
                    }
                  },
                  validator: (String? value) {
                    if (_issuedDate == null) {
                      return "Tanggal terbit wajib dipilih!";
                    }
                    return null;
                  },
                ),
              ),
              // === Tanggal Kedaluwarsa (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _expiredController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Kosongkan jika tidak kedaluwarsa",
                    labelText: "Tanggal Kedaluwarsa (opsional)",
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onTap: () async {
                    final picked = await _pickDate(
                      _expiredController,
                      _expiredDate,
                    );
                    if (picked != null) {
                      setState(() {
                        _expiredDate = picked;
                      });
                    }
                  },
                  validator: (String? value) {
                    if (_expiredDate != null &&
                        _issuedDate != null &&
                        _expiredDate!.isBefore(_issuedDate!)) {
                      return "Tanggal kedaluwarsa tidak boleh sebelum tanggal terbit!";
                    }
                    return null;
                  },
                ),
              ),
              // === URL Kredensial (opsional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://... (opsional)",
                    labelText: "URL Kredensial",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _credentialUrl = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    final uri = Uri.tryParse(value.trim());
                    final isHttp =
                        uri != null &&
                        (uri.scheme == 'http' || uri.scheme == 'https') &&
                        uri.host.isNotEmpty;
                    if (!isHttp) {
                      return "URL harus diawali http:// atau https://!";
                    }
                    return null;
                  },
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Diambil sebelum dialog dibuka; context di dalam dialog tidak valid setelah ditutup.
                        final messenger = ScaffoldMessenger.of(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Sertifikasi berhasil ditambahkan!',
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama Sertifikasi: $_name'),
                                    Text('Lembaga Penerbit: $_issuer'),
                                    Text(
                                      'Tanggal Terbit: ${_issuedDate == null ? '-' : _formatDate(_issuedDate!)}',
                                    ),
                                    Text(
                                      'Tanggal Kedaluwarsa: ${_expiredDate == null ? '-' : _formatDate(_expiredDate!)}',
                                    ),
                                    Text(
                                      'URL Kredensial: ${_credentialUrl.isEmpty ? '-' : _credentialUrl}',
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _resetForm();
                                    messenger.showSnackBar(
                                      const SnackBar(
                                        content: Text('Sertifikasi tersimpan'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Simpan",
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
