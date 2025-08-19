import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'country.g.dart';

@JsonSerializable()
class Country extends Equatable {
  final int id;
  final String value;

  const Country({
    required this.id,
    required this.value,
  });

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);

  @override
  List<Object?> get props => [id, value];
}