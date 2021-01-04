// To parse this JSON data, do
//
//     final accounts = accountsFromJson(jsonString);

import 'dart:collection';
import 'dart:convert';

Accounts accountsFromJson(String str) => Accounts.fromJson(json.decode(str));

String accountsToJson(Accounts data) => json.encode(data.toJson());

class Accounts {
  Accounts({
    this.addresses,
    this.privateKeys,
  });

  LinkedHashMap<String, Address> addresses;
  LinkedHashMap<String, String> privateKeys;

  factory Accounts.fromJson(Map<String, dynamic> json) => Accounts(
        addresses: LinkedHashMap.from(json["addresses"])
            .map((k, v) => MapEntry<String, Address>(k, Address.fromJson(v))),
        privateKeys: LinkedHashMap.from(json["private_keys"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "addresses": Map.from(addresses)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "private_keys": Map.from(privateKeys)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class Address {
  Address({
    this.secretKey,
    this.publicKey,
    this.address,
    this.account,
  });

  Key secretKey;
  Key publicKey;
  String address;
  Account account;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        secretKey: Key.fromJson(json["secretKey"]),
        publicKey: Key.fromJson(json["publicKey"]),
        address: json["address"],
        account: Account.fromJson(json["account"]),
      );

  Map<String, dynamic> toJson() => {
        "secretKey": secretKey.toJson(),
        "publicKey": publicKey.toJson(),
        "address": address,
        "account": account.toJson(),
      };
}

class Account {
  Account({
    this.nonce,
    this.balance,
    this.stateRoot,
    this.codeHash,
  });

  Nonce nonce;
  Balance balance;
  String stateRoot;
  String codeHash;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        nonce: nonceValues.map[json["nonce"]],
        balance: balanceValues.map[json["balance"]],
        stateRoot: json["stateRoot"],
        codeHash: json["codeHash"],
      );

  Map<String, dynamic> toJson() => {
        "nonce": nonceValues.reverse[nonce],
        "balance": balanceValues.reverse[balance],
        "stateRoot": stateRoot,
        "codeHash": codeHash,
      };
}

enum Balance { THE_0_X3635_C9_ADC5_DEA00000 }

final balanceValues =
    EnumValues({"0x3635c9adc5dea00000": Balance.THE_0_X3635_C9_ADC5_DEA00000});

enum Nonce { THE_0_X }

final nonceValues = EnumValues({"0x": Nonce.THE_0_X});

class Key {
  Key({
    this.type,
    this.data,
  });

  Type type;
  List<int> data;

  factory Key.fromJson(Map<String, dynamic> json) => Key(
        type: typeValues.map[json["type"]],
        data: List<int>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}

enum Type { BUFFER }

final typeValues = EnumValues({"Buffer": Type.BUFFER});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
