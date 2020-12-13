// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigFile _$ConfigFileFromJson(Map<String, dynamic> json) {
  return ConfigFile(
    json['localhost'] == null
        ? null
        : Config.fromJson(json['localhost'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ConfigFileToJson(ConfigFile instance) =>
    <String, dynamic>{
      'localhost': instance.localhost,
    };

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config(
    json['url'] as String,
    json['dataAddress'] as String,
    json['appAddress'] as String,
  );
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'url': instance.url,
      'dataAddress': instance.dataAddress,
      'appAddress': instance.appAddress,
    };
