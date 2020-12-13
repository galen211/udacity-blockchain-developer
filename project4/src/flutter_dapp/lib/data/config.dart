import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class ConfigFile {
  final Config localhost;

  ConfigFile(this.localhost);

  factory ConfigFile.fromJson(Map<String, dynamic> json) =>
      _$ConfigFileFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigFileToJson(this);
}

@JsonSerializable()
class Config {
  final String url;
  final String dataAddress;
  final String appAddress;

  Config(this.url, this.dataAddress, this.appAddress);

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
