import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

/// Model data pengalaman portofolio, disesuaikan dengan ExperienceSerializer
/// dari backend Django (endpoint /api/v1/experiences/, Assignment 6).
///
/// Field hasil perhitungan server (category_display, is_ongoing, star_count,
/// dst.) tidak ikut diserialisasi saat POST karena ditetapkan/dipertahankan
/// di sisi server.
@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    required this.title,
    required this.role,
    required this.description,
    required this.startedAt,
    this.id,
    this.organization = '',
    this.category = 'part-time',
    this.thumbnail,
    this.organizationUrl,
    this.endedAt,
    this.categoryDisplay,
    this.isOngoing,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);

  /// UUID dari server. Tidak ikut diserialisasi saat POST karena Django
  /// yang menetapkan id. (Field terautentikasi: POST wajib Authorization:
  /// Token — lihat [ApiClient.createExperience].)
  @JsonKey(includeToJson: false)
  final String? id;

  final String title;

  final String role;

  /// Boleh kosong di backend (CharField blank=True), jadi default ''.
  @JsonKey(defaultValue: '')
  final String organization;

  final String description;

  /// Salah satu dari: internship, research, volunteer, part-time,
  /// full-time, freelance.
  @JsonKey(defaultValue: 'part-time')
  final String category;

  /// URL gambar thumbnail (opsional/null di backend).
  final String? thumbnail;

  /// URL situs resmi organisasi/kepanitiaan (opsional/null).
  final String? organizationUrl;

  /// Tanggal mulai dalam format ISO 8601 (yyyy-MM-dd) sesuai DateField Django.
  final String startedAt;

  /// Tanggal selesai (opsional; null = sedang berlangsung).
  final String? endedAt;

  /// Field hasil perhitungan server — hanya dari GET, tidak dikirim saat POST.
  @JsonKey(includeToJson: false)
  final String? categoryDisplay;

  @JsonKey(includeToJson: false)
  final bool? isOngoing;

  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;

  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String starredByNames;
}
