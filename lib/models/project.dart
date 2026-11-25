import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Model data proyek portofolio, disesuaikan dengan ProjectSerializer
/// dari backend Django (endpoint /api/v1/projects/, Tutorial 07).
///
/// Field hasil perhitungan server (category_display, is_ongoing, star_count,
/// dst.) tidak dipetakan karena json_serializable mengabaikan kunci JSON
/// yang tidak dideklarasikan di kelas ini.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    required this.description,
    required this.startedAt,
    this.id,
    this.category = 'personal',
    this.technologies = '',
    this.repositoryUrl,
    this.reportUrl,
    this.deploymentUrl,
    this.endedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  /// UUID dari server. Tidak ikut diserialisasi saat POST karena Django
  /// yang menetapkan id.
  @JsonKey(includeToJson: false)
  final String? id;

  final String title;

  final String description;

  /// Salah satu dari: research, course, competition, personal.
  @JsonKey(defaultValue: 'personal')
  final String category;

  @JsonKey(defaultValue: '')
  final String technologies;

  /// URLField yang boleh kosong/null di backend.
  final String? repositoryUrl;

  final String? reportUrl;

  final String? deploymentUrl;

  /// Tanggal mulai dalam format ISO 8601 (yyyy-MM-dd) sesuai DateField Django.
  final String startedAt;

  /// Tanggal selesai (opsional).
  final String? endedAt;
}
