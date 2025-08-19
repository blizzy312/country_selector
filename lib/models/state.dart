import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'state.g.dart';

@JsonSerializable()
class State extends Equatable {
  final int id;
  final String value;
  final int countryId;

  const State({
    required this.id,
    required this.value,
    required this.countryId,
  });

  factory State.fromJson(Map<String, dynamic> json) => _$StateFromJson(json);

  Map<String, dynamic> toJson() => _$StateToJson(this);

  @override
  List<Object?> get props => [id, value, countryId];
}